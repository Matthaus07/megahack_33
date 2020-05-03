class User < ApplicationRecord
    validates :CPF, uniqueness: { case_sensitive: false }
    validates :username, uniqueness: {case_sensitive: false}
    validates :CEP, presence: true
    enum gender: [:male, :female, :not_informed]
    
end
