class Api::SmallBusinessesController < ApplicationController
    def create
        begin
            small_business = SmallBusiness.new(small_business_params)
            SmallBusiness.transaction do
                small_business.password_hash = BCrypt::Password.create(params[:password])
                if !small_business.valid?
                    raise MegaExceptions::ExistingRecord
                end
                small_business.save!
            end

            render json: {small_business: small_business.formatted_json}, status: 200
        rescue MegaExceptions::ExistingRecord
            render status: 409
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end

    def index
        begin
            raise MegaExceptions::BadParameters if params[:page].nil? || params[:city].nil?
            page = params[:page].to_i
            city = params[:city]
            category = params[:category]
            subcategory = params[:subcategory]

            offset = (page-1)*15
            small_businesses = SmallBusiness.where('lower(city) = ?', city.downcase)

            if !category.nil?
                small_businesses = small_business.where(category: category)
                small_businesses = small_businesses.where(subcategory: subcategory) if !subcategory.nil?
            end

            output = []
            ordered = small_businesses.order(:financial_rating)

            ordered.offset(offset).limit(15).each do |sb|
                output << sb.formatted_json
            end

            total = ordered.count
            total_pages = (total/15.to_f).ceil

            render json: {total: total, page: page, total_pages: total_pages, city: city, small_businesses: output, category: category, subcategory: subcategory}
        rescue MegaExceptions::BadParameters
            render status: 400 
        rescue => e
            render status: 500
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end

    def show
        begin
            
            if params[:id] == 'login'
                username = params[:username]
                password = params[:password]
    
                user_login = login(username, password)
    
                render json: {session_token: user_login[:session_token], id: user_login[:id]}, status: 200
            else
                user = SmallBusiness.find(params[:id])
    
                if user.nil?
                    raise MegaExceptions::UnknowUser
                end
    
                render json: user.formatted_json, status: 200
            end
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    
    def destroy
        begin
            session_token = params[:session_token]

            small_business = SmallBusiness.find_by(session_token: session_token)
            small_business.update(session_token: "") if !small_business.nil?

            render status: 200
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end


    def update
        begin
            sb = SmallBusiness.find(params[:id])

            if params[:new_rating]
                total_ratings = sb.total_ratings
                current_rating = sb.average_rating
                if total_ratings > 0
                    new_total = total_ratings + 1
                    new_avg = (total_ratings*current_rating + params[:new_rating])/new_total.to_f

                    sb.update(total_ratings: new_total, average_rating: new_avg)
                else
                    sb.update(total_ratings: 1, average_rating: params[:new_rating])
                end
            end

            render json: {small_business: sb.formatted_json}, status: 200
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end    
    end

    private

    def login(username, password)
        user = SmallBusiness.find_by(username: username)

        if user.nil?
            raise MegaExceptions::UnknowUser
        elsif BCrypt::Password.new(user.password_hash) != password
            raise MegaExceptions::InvalidPassword
        else
            session_token = SecureRandom.hex(10)
            user.update(session_token: session_token)
        end

        return {id: user[:id], session_token: session_token}
    end

    def small_business_params
        params.permit(:CNPJ, :CEP, :username, :company_name, :trading_name, :city, :st_number, :street, :state, :address_observation, :category, :photo_url)
    end
end