class User::LogoutController < ApplicationController
    def create
        begin
            session_token = params[:session_token]

            user = User.find_by(session_token: session_token)
            if user.nil?
                enterprise = Enterprise.find_by(session_token: session_token)
                enterprise.update(session_token: "") if !enterprise.nil?
            else
                user.update(session_token: "")
            end

            render status: 200
        rescue => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
        end
    end
end