class UploadLocutorController < ApplicationController
    def new
    @upload_locutor = UploadLocutor.new
    end
     
    def create
        @upload_locutor = UploadLocutor.new(upload_locutor_params)
        if @upload_locutor.save
            flash[:success] = 'Hemos recibido tu voz y la estamos procesando para que sea publicada en la página del concurso y pueda ser posteriormente revisada por 
            nuestro equipo de trabajo. Tan pronto la voz quede publicada en la página del concurso te notificaremos por email.'
            redirect_to voces_locutors_path
        else
            render 'new'
        end
    end
    private
    def upload_locutor_params
        params.require(:upload_locutor).permit(:nombre, :image)
    end
end
