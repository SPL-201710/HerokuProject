#!/bin/bash

echo " Revisando Voces subidas por el portal de Publivoz..."

PATHSOURCE="/var/www/Proyecto-locutores/public/vocesLoaded/cache/"
PATHDEST="/var/www/Proyecto-locutores/public/vocesLoaded/store/"


###.........................................................................


#results="$(mysql --user root --default-character-set utf8 --password=Locutores123 development -Bse 'SELECT id,trim(originalURL),trim(emailLocutor),trim(nombresLocutor),trim(apellidosLocutor) FROM vocess_locutors where estado="En proceso" and originalURL!="" and emailLocutor!="" ;')"

results="$(mysql --host voces-locutores.ceeeapdxjz5l.us-east-2.rds.amazonaws.com --user AdminVoces  --default-character-set utf8 --password=Locutores123 development -Bse 'SELECT id,trim(originalURL),trim(emailLocutor),trim(nombresLocutor),trim(apellidosLocutor) FROM vocess_locutors where estado="En proceso" and originalURL!="" and emailLocutor!="" ;')"

IFS=$'\n'

for i in $results; do
    id=`echo ${i}|awk '{print $1}'`;

    originalURL=`echo ${i}|awk '{print $2}'`
    
    file=`echo ${i}|awk '{print $2}'| cut -d'/' -f4`;
    new_file=`echo ${file} | cut -d'.' -f1`

    new_url=`echo ${originalURL} | sed 's/cache/store/g' | awk -F / '{print "/"$2"/"$3"/" }'`
    new_url=${new_url}${new_file}.mp3

    email=`echo ${i}|awk '{print $3}'`;
    nombre=`echo ${i}|awk '{print $4}'`;
    apellidos=`echo ${i}|awk '{print $5}'`;
 
echo "EMAIL: $email  , NOMBRE: $nombre  , APELLIDOS: $apellidos , ID: $id ,  originalURL: $originalURL"
echo "NEW FILE:  $new_file , FILE: $file , new_url $new_url"
echo "........................................"

###.........................................................................
### Convertimos el archivo a formato mp3 ---------------------------------

    echo "Convirtiendo:  ffmpeg -i ${PATHSOURCE}${file}  ${PATHDEST}${new_file}.mp3"
    /usr/bin/ffmpeg -i ${PATHSOURCE}${file}  ${PATHDEST}${new_file}.mp3

### Actualizamos la DB ---------------------------------

mysql --host voces-locutores.ceeeapdxjz5l.us-east-2.rds.amazonaws.com --user AdminVoces  --default-character-set utf8 --password=Locutores123 development -Bse "UPDATE vocess_locutors set estado='Convertida', convertidaURL='$new_url'  Where id=$id;"
echo "UPDATE vocess_locutors set estado='Convertida', convertidaURL='$new_url'  Where id=$id;"

### Construimos el cuerpo del correo personalizado ---------------------------------
        echo "To:${email}" > template_email.txt
        echo "Subject: Su audio ya es público" >> template_email.txt
        echo "From: publivoz@publivoz.com">> template_email.txt
        echo"">> template_email.txt
        echo "Cordial saludo ${nombre} ${apellidos},">> template_email.txt
        echo"">> template_email.txt
        echo "Es un placer para nosotros informale que su audio ha sido actualizado al estado activo, por lo cual ya es visible desde nuestro portal.">> template_email.txt
        echo "Para verlo y reproducirlo por favor acceda a esta url: ${new_url}.">> template_email.txt
        echo "Le deseamos la mejor de las suertes en el concurso.">> template_email.txt
        echo"">> template_email.txt
        echo "Gracias por hacer parte de este proyecto.">> template_email.txt
        echo"">> template_email.txt
        echo "Attentamente el grupo de trabajo de Publivoz.">> template_email.txt

## Enviamos el correo con el template
	/usr/sbin/sendmail -t < template_email.txt

	
done;
unset IFS

