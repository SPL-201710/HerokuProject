#!/bin/bash

echo " Revisando Voces subidas por el portal de Publivoz..."

DATABASE="/home/ec2-user/environment/db/development.sqlite3"
PATHSOURCE="/home/ec2-user/environment/public/vocesLoaded/cache/"
PATHDEST="/home/ec2-user/environment/public/vocesLoaded/storage/"

function runSelect()
{
	SQL=$1
	RES=`sqlite3 $DATABASE "${SQL}"` 
	echo $RES
}

qryVoces="SELECT id,trim(originalURL),trim(emailLocutor),trim(nombresLocutor),trim(apellidosLocutor) FROM vocess_locutors where estado='En proceso' and originalURL!='' and emailLocutor!='' and convertidaURL='';";

result=`runSelect "${qryVoces}"`



## para descomentar cuando hayan datos
for ROW in $result; do
#echo "${ROW}" 
#echo "-------------------------"
		id=`echo ${ROW} | awk '{split($0,a,"|"); print a[1]}'`
        file=`echo ${ROW} | awk '{split($0,a,"|"); print a[2]}' | awk -F / '{print $4}'`
        new_file=`echo ${file} | cut -d'.' -f1`
        #echo "NEW FILE:"  $new_file
		 new_url=`echo ${ROW} | awk '{split($0,a,"|"); print a[2]}'| sed 's/cache/storage/g' | awk -F / '{print "/"$2"/"$3"/" }'`
		 new_url=${new_url}${file}
#		 echo "NEW URL:" $new_url
        email=`echo ${ROW} | awk '{split($0,a,"|"); print a[3]}'`
        nombre=`echo ${ROW} | awk '{split($0,a,"|"); print a[4]}'`
        apellidos=`echo ${ROW} | awk '{split($0,a,"|"); print a[5]}'` 
#echo "EMAIL: $email  , NOMBRE: $nombre  , APELLIDOS: $apellidos"

### Convertimos el archivo a formato mp3 ---------------------------------
	echo "ffmeg -i ${PATHSOURCE}${file}  ${PATHDEST}${new_file}.mp3"

### Actualizamos la DB ---------------------------------
echo "ID: ${id}"
   sqlite3 $DATABASE " UPDATE vocess_locutors set estado='Convertida', convertidaURL=${new_url}  Where id=  ${id};" 

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

sendmail -t < template_email.txt
	
done;
