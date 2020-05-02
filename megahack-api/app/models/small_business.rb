class SmallBusiness < ApplicationRecord
    # mount_uploader :photo, :PhotoUploader
    has_many :products, dependent: :destroy
end
