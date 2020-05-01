class Api::SmallBusinessesController < ApplicationController
    def create
        begin
            SmallBusiness.transaction do
                small_business = SmallBusiness.new(small_business_params)
                small_business.password_hash = BCrypt::Password.create(params[:password])
                small_business.save!
            end

            render status: 200
        rescue => exception
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

    def small_business_params
        params.permit(:CNPJ, :CEP, :username, :name, :city, :st_number, :street, :state, :address_observation, :category)
    end
end