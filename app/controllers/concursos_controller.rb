class ConcursosController < ApplicationController
    #before_action :set_concurso, only: [:show, :edit, :update, :destroy]
    require "aws-sdk"
    require 'securerandom'

    def index
	if administrator_signed_in?
	  #@concursos = Concurso.where administrator_id: current_administrator.id
	  Aws.config.update({ region: "us-east-2" })
          credentials = Aws::SharedCredentials.new(profile_name: 'default')
          dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)
          table_name = 'concursos'

          parameter = {
            table_name: table_name,
            key_condition_expression: "#admin = :administrator",
            expression_attribute_names: {
              "#admin" => "administrator_id"
            },
            expression_attribute_values: {
               ":administrator" => current_administrator.id
            }
          }

          begin
                @concursos = dynamodb.query(parameter)
                puts "Query succeeded."
          rescue  Aws::DynamoDB::Errors::ServiceError => error
                puts "Unable to query table:"
                flash[:danger] = "#{error.message}"
          end
	end
    end
	
    def homeConcursos
        Aws.config.update({ region: "us-east-2" })
        credentials = Aws::SharedCredentials.new(profile_name: 'default')
    	dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)
	table_name = 'concursos'	
	#@concursos = Concurso.find_by concursoURL: params[:concursoURL]
	parameter = {
		table_name: table_name,
		index_name: 'concursoURL-index',
		select: 'ALL_PROJECTED_ATTRIBUTES',
                key_condition_expression: "concursoURL= :concursoURL",
                expression_attribute_values: {
                        ":concursoURL" => params[:concursoURL]
                }

	}

	begin
	    @concursos = Concurso.new
	    result = dynamodb.query(parameter)
            result.items.each{|concurso|
		@concursos.administrator_id = concurso["administrator_id"]
          	@concursos.id = concurso["id"]
		session[:concurso_id] = concurso["id"] 
	    	@concursos.nombreConcurso = concurso["nombreConcurso"]
            	@concursos.fechaInicio = concurso["fechaInicio"]
            	@concursos.fechaFin = concurso["fechaFin"]
            	@concursos.valorPagar = concurso["valorPagar"]
            	@concursos.recomendaciones = concurso["recomendaciones"]
           	@concursos.guionConcurso = concurso["guionConcurso"]
            	@concursos.imageBanner = concurso["imageBanner"]
            	@concursos.concursoURL = concurso["concursoURL"]
            	@concursos.created_at = concurso["created_at"]
            	@concursos.updated_at = concurso["updated_at"]
            	@concursos.image_data = concurso["image_data"]
	    }
	
	    table_name = 'vocess_locutors'
	    parameter = {
                table_name: table_name,
                key_condition_expression: "#conc = :concurso",
                expression_attribute_names: {
                   "#conc" => "concurso_id"
                },
                expression_attribute_values: {
                   ":concurso" => session[:concurso_id]
                }
            }

    	    vocess_locutor = VocessLocutor.new
	    @vocess_locutors = []
	    results =  dynamodb.query(parameter) 
	    result.items.each{|voz|
		vocess_locutor.concurso_id = voz["concurso_id"]
		vocess_locutor.id = voz["id"]
		vocess_locutor.nombresLocutor = voz["nombresLocutor"]
		vocess_locutor.apellidosLocutor = voz["apellidosLocutor"]
		vocess_locutor.emailLocutor = voz["emailLocutor"]
		vocess_locutor.originalURL = voz["originalURL"]
		vocess_locutor.convertidaURL = voz["convertidaURL"]
		vocess_locutor.comentarios = voz["comentarios"]
		vocess_locutor.estado = voz["estado"]
		vocess_locutor.created_at = voz["created_at"]
		vocess_locutor.updated_at = voz["updated_at"]
		vocess_locutor.voz_data = voz["@vocess_locutors"]
		@vocess_locutors << vocess_locutor
	    }
    	    puts "Query succeeded."
	   # @vocess_locutors = @vocess_locutors.select {|e| e.estado=="En proceso" }
	    @vocess_locutor_new = VocessLocutor.new
# 	    @vocess_locutors = @vocess_locutors.where(:estado => 'Convertida').paginate(:page => params[:page], per_page: 30).order(created_at: :desc)
	rescue  Aws::DynamoDB::Errors::ServiceError => error
    	    puts "Unable to query table:"
    	    flash[:danger] = "#{error.message}"
	end

	#@concursos = Concurso.find_by concursoURL: params[:concursoURL]
	#@vocess_locutors = @vocess_locutors.paginate(:page => params[:page], per_page: 30)
	#.order(created_at: :desc)
	#@vocess_locutors = @concursos.vocess_locutors.where(:estado => 'Convertida').paginate(:page => params[:page], per_page: 30).order(created_at: :desc)
	#@vocess_locutor = VocessLocutor.new
    	#session[:concursoURL] = params[:concursoURL]
    end
	
    def find
    	@vocess_locutor = VocessLocutor.new
    	@concursos = Concurso.new
    end

    def new
	@concursos = Concurso.new
	session[:concurso_id] = nil
    end
    
    def create
        Aws.config.update({ region: "us-east-2" })
	credentials = Aws::SharedCredentials.new(profile_name: 'default')
	dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)

	#render plain: params[:concurso].inspect
        @concursos = current_administrator.concursos.new concurso_params
        begin
          table_name = 'concursos'
	  if session[:concurso_id].nil?
	     concurso_id = SecureRandom.hex
	     url_imagen = @concursos.image_url
	     cache_imagen = @concursos.cached_image_data
	     created = Time.now.to_s
          else 
	     parameter = {
                table_name: table_name,
                    key: {
                  	administrator_id: current_administrator.id,
                   	id: session[:concurso_id]
                   }	
	     }

             result = dynamodb.get_item(parameter)	     
	     concurso_id = session[:concurso_id]
	     created = result.item["created_at"]

	     if @concursos.image_url.nil?
		url_imagen = result.item["imageBanner"]
	        cache_imagen = result.item["image_data"]
	     else
		url_imagen = @concursos.image_url
                cache_imagen = @concursos.cached_image_data
	     end
 	   end

           item = {
                administrator_id: @concursos.administrator_id,
                id: concurso_id,
                nombreConcurso: @concursos.nombreConcurso,
                fechaInicio: @concursos.fechaInicio.to_s,
                fechaFin: @concursos.fechaFin.to_s,
                valorPagar: @concursos.valorPagar,
                recomendaciones: @concursos.recomendaciones,
                guionConcurso: @concursos.guionConcurso,
                imageBanner: url_imagen,
                image_data: cache_imagen,
                concursoURL: @concursos.concursoURL,
                created_at: created,
                updated_at: Time.now.to_s
           }

           params = {
                table_name: table_name,
                item: item
           }

           result = dynamodb.put_item(params)
  	 
	   redirect_to @concursos
	rescue  Aws::DynamoDB::Errors::ServiceError => error
       	    puts "No se puede crear el concurso:"
            flash[:danger] = "#{error.message}"
	    #flash[:danger] = 'Ha ocurrido un error y no se creó el concurso. Revise la información y el formato del archivo guardado e inténtelo de nuevo.'
    	end
    end
    
    def show
	@concursos = Concurso.new
        Aws.config.update({ region: "us-east-2" })
        credentials = Aws::SharedCredentials.new(profile_name: 'default')
        dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)
        table_name = 'concursos'
        parameter = {
            table_name: table_name,
                key: {
                   administrator_id: current_administrator.id,
                   id: params[:id]
                }
        }

        begin
            result = dynamodb.get_item(parameter)
            @concursos.administrator_id = result.item["administrator_id"]
            @concursos.id = result.item["id"]
            @concursos.nombreConcurso = result.item["nombreConcurso"]
            @concursos.fechaInicio = result.item["fechaInicio"]
            @concursos.fechaFin = result.item["fechaFin"]
            @concursos.valorPagar = result.item["valorPagar"]
            @concursos.recomendaciones = result.item["recomendaciones"]
            @concursos.guionConcurso = result.item["guionConcurso"]
            @concursos.imageBanner = result.item["imageBanner"]
            @concursos.concursoURL = result.item["concursoURL"]
            @concursos.created_at = result.item["created_at"]
            @concursos.updated_at = result.item["updated_at"]
            @concursos.image_data = result.item["image_data"]
    	    @vocess_locutors = @concursos.vocess_locutors.paginate(:page => params[:page], per_page: 30).order(created_at: :desc)
    	    session[:concurso_id] = params[:id]
	end
    end

    def edit
	@concursos = Concurso.new
	Aws.config.update({ region: "us-east-2" })
        credentials = Aws::SharedCredentials.new(profile_name: 'default')
        dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)
        table_name = 'concursos'     
	session[:concurso_id] = params[:id]
	parameter = {
    	    table_name: table_name,
    		key: {
        	   administrator_id: current_administrator.id,
        	   id: session[:concurso_id]
    		}
	}
      
        begin
            result = dynamodb.get_item(parameter)
            @concursos.administrator_id = result.item["administrator_id"]
	    @concursos.id = result.item["id"]
	    @concursos.nombreConcurso = result.item["nombreConcurso"]
	    @concursos.fechaInicio = result.item["fechaInicio"]
	    @concursos.fechaFin = result.item["fechaFin"]
	    @concursos.valorPagar = result.item["valorPagar"]
	    @concursos.recomendaciones = result.item["recomendaciones"]
	    @concursos.guionConcurso = result.item["guionConcurso"]
	    @concursos.imageBanner = result.item["imageBanner"]
	    @concursos.concursoURL = result.item["concursoURL"]
	    @concursos.created_at = result.item["created_at"]
	    @concursos.updated_at = result.item["updated_at"]
	    @concursos.image_data = result.item["image_data"]
        rescue  Aws::DynamoDB::Errors::ServiceError => error
                flash[:danger] = "#{error.message}"
        end
    end

    def update
#	@concursos = Concurso.find params[:id]
#	@concursos.imageBanner = @concursos.image_url
#	@concursos.update concurso_params
#	redirect_to @concursos
    end

    def destroy
#	@concursos = Concurso.find params[:id]
        Aws.config.update({ region: "us-east-2" })
        credentials = Aws::SharedCredentials.new(profile_name: 'default')
        dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)
        table_name = 'concursos'
        parameter = {
            table_name: table_name,
            key: {
                administrator_id: current_administrator.id,
                id: params[:id]
            }
        }

        begin
            result = dynamodb.delete_item(parameter)
            puts "Deleted item."
	rescue  Aws::DynamoDB::Errors::ServiceError => error
    	    puts "Unable to update item:"
     	    puts "#{error.message}"
	end
        redirect_to concursos_path
    end
    
    private
    
    def concurso_params
        params.require(:concurso).permit(:nombreConcurso, :fechaInicio, :fechaFin, :valorPagar, :recomendaciones, :guionConcurso, :image, :concursoURL)
    end  
end
