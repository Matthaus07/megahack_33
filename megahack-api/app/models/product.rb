class Product < ApplicationRecord
    mount_base64_uploader :photo_url, ImageUploader
    belongs_to :small_business
    validates :price, presence: true
    validates :name, presence: true

    def get_photo_url
        return self.photo_url.url
    end

    def formatted_json
        return {
            id: self.id,
            name: self.name,
            price: self.price,
            quantity: self.quantity,
            photo_url: self.get_photo_url,
            small_business_id: self.small_business_id,
            description: self.description
        }
    end
    
end
