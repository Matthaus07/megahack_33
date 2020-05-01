class Api::UsersController < ApplicationController
    def create
        begin
            User.transaction do
                user = User.new(user_params)
                user.password_hash = BCrypt::Password.create(params[:password])
                user.save!
            end

            render status: 200
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

                session_token = login(username, password)

                render json: {session_token: session_token}, status: 200
            else
                user = User.find(params[:id])

                if user.nil?
                    raise MegaExceptions::UnknowUser
                end

                render json: {
                    :CPF => user[:CPF],
                    :CEP => user[:CEP],
                    :username => user[:username],
                    :first_name => user[:first_name],
                    :last_name => user[:last_name],
                    :city => user[:city],
                    :st_number => user[:st_number],
                    :street => user[:street],
                    :state => user[:state],
                    :address_observation => user[:address_observation]
                }, status: 200
            end
        rescue MegaExceptions::UnknowUser
            render status: 404
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    
    def destroy
        begin
            session_token = params[:session_token]

            user = User.find_by(session_token: session_token)
            user.update(session_token: "") if !user.nil?

            render status: 200
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    
    # Private methods

    private

    def login(username, password)
        user = User.find_by(username: username)

        if user.nil?
            raise MegaExceptions::UnknowUser
        elsif BCrypt::Password.new(user.password_hash) != password
            raise MegaExceptions::InvalidPassword
        else
            session_token = SecureRandom.hex(10)
            user.update(session_token: session_token)
        end

        return session_token        
    end
    

    def user_params
        params.permit(:CPF, :CEP, :username, :first_name, :last_name, :city, :st_number, :street, :state, :address_observation)
    end
end
