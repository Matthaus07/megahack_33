class SmallBusiness < ApplicationRecord
    mount_base64_uploader :photo_url, ImageUploader
    has_many :products, dependent: :destroy
    validates :CNPJ, uniqueness: { case_sensitive: false }
    validates :username, uniqueness: {case_sensitive: false}
    validates :company_name, presence: true
    validates :trading_name, presence: true
    validates :city, presence: true
    validates :CEP, presence: true

    def get_photo_url
        return self.photo_url.url
    end
    
    def formatted_json
        if self.total_ratings == 0
            avg_rating = nil
        else
            avg_rating = self.average_rating
        end

        return {
            id: self.id,
            CNPJ: self.CNPJ,
            username: username,
            company_name: self.company_name,
            trading_name: self.trading_name,
            street: self.street,
            city: self.city,
            st_number: self.st_number,
            average_rating: avg_rating,
            total_ratings: self.total_ratings,
            address_observation: self.address_observation,
            category: self.category,
            subcategory: self.subcategory,
            photo_url: self.get_photo_url,
            CEP: self.CEP,
            financial_rating: self.financial_rating
        }
    end
    

end
