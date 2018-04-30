class Concurso < ApplicationRecord
    include ImageUploader.attachment(:image)
    has_many :voces_locutors
    has_many :vocess_locutors
    belongs_to :administrator
    #mount_uploader :image, PictureUploader
end
