class VocessLocutor < ApplicationRecord
  include VozUploader.attachment(:voz)
  belongs_to :concurso
end
