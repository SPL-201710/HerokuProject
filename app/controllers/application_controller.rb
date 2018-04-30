class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_devise_params, if: :devise_controller?
  before_action :homeConcurso
  
  def configure_devise_params
      devise_parameter_sanitizer.permit(:sign_up) do |user|
          user.permit(:nombres, :email, :password, :password_confirmation, :apellidos, :nombreEmpresa)
      end
  end
  
  def homeConcurso
       @concursos = Concurso.where concursoURL: params[:concursoURL]
    end

end
