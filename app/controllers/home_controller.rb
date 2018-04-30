class HomeController < ApplicationController
	before_action :set_concurso

	def index
		
	end
	
	def find
	    @vocess_locutor = VocessLocutor.new
	    @concursos = Concurso.new
	end
	
	private
		def set_concurso
	    	if administrator_signed_in?
				@concursos = Concurso.where administrator_id: current_administrator.id
			end
	    end
end
