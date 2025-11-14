#!/bin/bash

# Função para exibir mensagens
mensagem() {
    echo -e "\n[INFO] $1\n"
}

# Passo 1: Confirmação do usuário
mensagem "Este script irá instalar um servidor WEB e configurar uma página padrão."
read -p "Deseja continuar? (s/n): " resposta
if [[ "$resposta" != "s" ]]; then
    mensagem "Operação cancelada pelo usuário."
    exit 1
fi

# Passo 2: Atualizar pacotes
mensagem "Atualizando pacotes..."
sudo apt-get update -y

# Passo 3: Instalar Apache
mensagem "Instalando servidor Apache..."
sudo apt-get install apache2 -y

# Passo 4: Baixar template HTML
mensagem "Baixando template HTML..."
wget -O /tmp/index.html https://raw.githubusercontent.com/startbootstrap/startbootstrap-clean-blog/master/index.html

# Passo 5: Publicar template no Apache
mensagem "Publicando template no servidor..."
sudo mv /tmp/index.html /var/www/html/index.html

# Passo 6: Reiniciar serviço Apache
mensagem "Reiniciando serviço Apache..."
sudo systemctl restart apache2

mensagem "Instalação concluída! Acesse http://localhost para ver a página."
