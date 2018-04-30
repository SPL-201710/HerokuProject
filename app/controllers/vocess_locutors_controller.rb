class VocessLocutorsController < ApplicationController
  before_action :set_vocess_locutor, only: [:show, :edit, :update, :destroy]
  before_action :set_concurso
  require 'aws-sdk'
  require 'securerandom'

  # GET /vocess_locutors
  # GET /vocess_locutors.json
  def index	
    if administrator_signed_in?
      @vocess_locutors = VocessLocutor.all
    end
  end
  
  def find
    @vocess_locutor = VocessLocutor.new
    @concursos = Concurso.new
  end
  
  # GET /vocess_locutors/1
  # GET /vocess_locutors/1.json
  def show
  end

  # GET /vocess_locutors/new
  def new
    @vocess_locutor = VocessLocutor.new
    #@concursos = Concurso.new
  end

  # GET /vocess_locutors/1/edit
  def edit
  end

  # POST /vocess_locutors
  # POST /vocess_locutors.json
  def create
    Aws.config.update({ region: "us-east-2" })
    credentials = Aws::SharedCredentials.new(profile_name: 'default')
    dynamodb = Aws::DynamoDB::Client.new(credentials: credentials)

    @vocess_locutor = VocessLocutor.new(vocess_locutor_params)
    vocess_locutor_id = SecureRandom.hex  
    begin	
    	 table_name = 'vocess_locutors'
    	 item = {
		concurso_id: session[:concurso_id],
		id: vocess_locutor_id,	 
	       	nombresLocutor: @vocess_locutor.nombresLocutor,
		apellidosLocutor: @vocess_locutor.apellidosLocutor,
		emailLocutor: @vocess_locutor.emailLocutor,
		originalURL: @vocess_locutor.voz_url,
		convertidaURL: nil,
		comentarios: @vocess_locutor.comentarios,
		estado: "En proceso",
		created_at: Time.now.to_s,
		updated_at: Time.now.to_s,
		voz_data: @vocess_locutor.cached_voz_data
     	}
     	params = {
    		table_name: table_name,
    		item: item
     	}
        result = dynamodb.put_item(params)
        flash[:success] = 'Hemos recibido tu voz y la estamos procesando para que sea publicada en la página del concurso y 
                            pueda ser posteriormente revisada por nuestro equipo de trabajo. Tan pronto la voz quede publicada 
                            en la página del concurso te notificaremos por email.'
        #UserMailer.welcome_email(@vocess_locutor).deliver
	# mandamos el valor a la cola antes de redicreecionar
		# load credentials from disk
	creds = YAML.load(File.read('sqsCredenciales.yml'))
	sqs = Aws::SQS::Client.new(region: 'us-east-2', 
				   access_key_id: creds['access_key_id'],
				   secret_access_key: creds['secret_access_key'])

	urlPaso = sqs.get_queue_url(queue_name: 'ColaAudiosPorConvertir.fifo').queue_url
	sqs.send_message(queue_url: urlPaso, message_body: vocess_locutor_id,  message_group_id: '1')
	# Fin cola
        redirect_to "/homeConcursos?concursoURL="+session[:concursoURL]
        #format.html { redirect_to @vocess_locutor.concurso, notice: '' }
        #format.json { render :show, status: :created, location: @vocess_locutor }
    rescue  Aws::DynamoDB::Errors::ServiceError => error
	puts "No se puede crear el registro:"
       	flash[:danger] = error.message
       	#flash[:danger] = 'Ha ocurrido un error y no se recibió su voz. Revise la información y el formato del archivo guardado e inténtelo de nuevo.'
       	#format.html { render :new }
       	#format.json { render json: @vocess_locutor.errors, status: :unprocessable_entity }
        redirect_to "/homeConcursos?concursoURL="+session[:concursoURL]
    end
  end
  # PATCH/PUT /vocess_locutors/1
  # PATCH/PUT /vocess_locutors/1.json
  def update
    respond_to do |format|
      if @vocess_locutor.update(vocess_locutor_params)
        format.html { redirect_to @vocess_locutor.concurso, notice: 'Vocess locutor was successfully updated.' }
        format.json { render :show, status: :ok, location: @vocess_locutor }
      else
        format.html { render :edit }
        format.json { render json: @vocess_locutor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vocess_locutors/1
  # DELETE /vocess_locutors/1.json
  def destroy
    @vocess_locutor.destroy
    respond_to do |format|
      format.html { redirect_to @concurso, notice: 'Vocess locutor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_concurso
      @concursos = Concurso.find_by concursoURL: session[:concursoURL]
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_vocess_locutor
      @vocess_locutor = VocessLocutor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vocess_locutor_params
      params.require(:vocess_locutor).permit(:concurso_id, :nombresLocutor, :apellidosLocutor, :emailLocutor, :voz, :comentarios)
    end
end
