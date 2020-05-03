class Product < ApplicationRecord
    mount_base64_uploader :photo_url, ImageUploader
    belongs_to :small_business

    def get_photo_url
        return self.photo_url.url
    end
end
