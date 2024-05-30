#!/bin/bash

# Definir variáveis de ambiente
export ROS_DOMAIN_ID=1
export ROS_LOCALHOST_ONLY=0

CONTAINER_NAME="micro_xrce_dds_agent_container"
IMAGE_NAME="micro_xrce_dds_agent_image"

# Verificar se a variável DISPLAY está definida
if [ -z "$DISPLAY" ]; then
    echo "Erro: a variável DISPLAY não está definida."
    exit 1
fi

# Permitir conexões locais ao servidor X para aplicativos GUI no Docker
xhost +local:docker

# Configuração para encaminhamento X11 para habilitar aplicativos GUI
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Verifica se o container está em execução
if [ $(docker ps -q -f name=$CONTAINER_NAME) ]; then
    echo "O container '$CONTAINER_NAME' já está em execução."
else
    echo "Iniciando o container '$CONTAINER_NAME'..."
    docker start $CONTAINER_NAME

    if [ $? -ne 0 ]; then
        echo "Erro ao iniciar o container '$CONTAINER_NAME'."
        exit 1
    fi
fi

# Abrir um console interativo no container
echo "Abrindo console no container '$CONTAINER_NAME'..."
docker exec -it \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH" \
    $CONTAINER_NAME /bin/bash

if [ $? -ne 0 ]; then
    echo "Erro ao abrir o console no container '$CONTAINER_NAME'."
    exit 1
fi
