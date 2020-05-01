class User::LoginController < ApplicationController
    def create
        begin
            is_user = params[:is_user]
            username = params[:username]
            password = params[:password]

            if is_user == true
                session_token = login_user(username, password)
            else
                session_token = login_enterprise(username, password)
            end
            
            render json: {session_token: session_token}, status: 200
        rescue MegaExceptions::UnknowUser
            render status: 404
        rescue MegaExceptions::InvalidPassword
            render status: 401
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
    
    def login_user(username, password)
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
    def login_enterprise(username, password)
        user = Enterprise.find_by(username: username)

        if enterprise.nil?
            raise MegaExceptions::UnknowUser
        elsif BCrypt::Password.new(enterprise.password_hash) != password
            raise MegaExceptions::InvalidPassword
        else
            session_token = SecureRandom.hex(10)
            enterprise.update(session_token: session_token)
        end

        return session_token
    end
end