class Api::SmallBusinessesController < ApplicationController
    def create
        begin
            small_business = SmallBusiness.new(small_business_params)
            SmallBusiness.transaction do
                small_business.password_hash = BCrypt::Password.create(params[:password])
                small_business.save!
            end

            render json: {small_business: small_business.attributes.except("password_hash", "session_token")}, status: 200
        rescue => e
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
    
                render json: {
                    :CNPJ => user[:CNPJ],
                    :CEP => user[:CEP],
                    :username => user[:username],
                    :name => user[:name],
                    :city => user[:city],
                    :st_number => user[:st_number],
                    :street => user[:street],
                    :state => user[:state],
                    :address_observation => user[:address_observation],
                    :average_rating => user[:average_rating],
                    :total_ratings => user[:total_ratings],
                    :photo_url => user[:photo_url],
                    :category => user[:category],
                    :financial_rating => user[:financial_rating]
                }, status: 200
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
        params.permit(:CNPJ, :CEP, :username, :name, :city, :st_number, :street, :state, :address_observation, :category)
    end
end