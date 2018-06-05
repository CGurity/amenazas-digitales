#!/bin/bash
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

DIALOG=${DIALOG=dialog}

tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

$DIALOG --clear --title "Captura de tráfico" \
        --menu "¿Usando cuál variable deseas detener automáticamente la captura?" 20 51 4 \
        "1"  "Por defecto: 10Mb" \
        "2" "Por tamaño de captura (En Kb)" \
        "3" "Por tiempo (En segundos)" 2> $tempfile

retval=$?

choice=`cat $tempfile`

case $retval in
  0)
    echo "'$choice' seleccionado";
    if [ $choice == 1 ]
    then
      argument="filesize:10000"
      goon=1
    else
      if [ $choice == 2 ]
      then
        autostop="filesize:"
        variable="tamaño"
        message="Define el tamaño del archivo de captura (en Kb)"
      fi
      if [ $choice == 3 ]
      then
        autostop="duration:"
        variable="duración"
        message="Define la duración de la captura de tráfico (en segundos)"
      fi
      tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
      trap "rm -f $tempfile" 0 1 2 5 15

      $DIALOG --title "Definir $variable de la captura" --clear \
              --inputbox "$message:" 16 51 2> $tempfile

      retval=$?

      case $retval in
        0)
          value=`cat $tempfile`
          argument=$autostop$value
          goon=1
          ;;
        1)
          clear
          echo "Cancel pressed."
          goon=0;;
        255)
          if test -s $tempfile ; then
            cat $tempfile
          else
            clear
            echo "ESC pressed."
            goon=0
          fi
          ;;
      esac
    fi
    clear
    if ! [[ "$value" =~ ^[0-9]+$ ]]
    then
      clear
      echo "Intenta de nuevo e introduce un valor entero"
      goon=0
    fi
    if [[ $goon == 1 ]]; then
      echo $argument
      echo "tshark -i br0 -a $argument -w nombre_archivo"
      STR=$(date +%Y-%m-%d-%H-%M)
      folder=./captures/$STR
      mkdir $folder
      echo "Creating directory captures/$STR"
      echo "Making capture and storing it in captures/$STR/capture.pcap"
      sudo tshark -i wlx503eaa3a13e7 -a $argument -w $folder/capture.pcap
      FILES=./analysis/*
      for f in $FILES
      do
        echo "Processing $f file..."
        # take action on each file. $f store current file name
        source $f
      done
      chown -R $SUDO_USER:$SUDO_USER $folder
    fi;;
  1)
    clear
    echo "Cancel pressed.";;
  255)
    clear
    echo "ESC pressed.";;
esac
