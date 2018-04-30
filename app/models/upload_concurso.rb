class UploadConcurso < ApplicationRecord
    include ImageUploader::Attachment.new(:image)
end
