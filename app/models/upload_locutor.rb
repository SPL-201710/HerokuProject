class UploadConcurso < ApplicationRecord
    include VozUploader::Attachment.new(:voz)
end
