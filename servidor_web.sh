#!/bin/bash
# -----------------------------------------------------------
# Script: websetup_interativo.sh
# Autor: Fidelis
# Função: Instalar e configurar servidor WEB Apache no Debian
# Versão: Interativa com seleção de template
# -----------------------------------------------------------
set -e
echo "💖 Bem-vindo ao instalador automático do servidor Apache!"
echo "Este script foi criado por Fidleis"
sleep 2
# -----------------------------------------------------------
# 1. Confirmar início
# -----------------------------------------------------------
read -p "➡️ Deseja iniciar a instalação do servidor web? (s/n): " START
if [[ "$START" != "s" && "$START" != "S" ]]; then
    echo "❌ Instalação cancelada."
    exit 0
fi
echo "🚀 Iniciando instalação..."
sleep 1
# -----------------------------------------------------------
# 2. Ajustar repositórios
# -----------------------------------------------------------
echo "📝 Fazendo backup e ajustando sources.list..."
cp /etc/apt/sources.list /etc/apt/sources.list.bkp
sed -i '1s/^/#/' /etc/apt/sources.list
# -----------------------------------------------------------
# 3. Instalar pacotes
# -----------------------------------------------------------
echo "📦 Atualizando pacotes e instalando Apache..."
apt-get update -y
apt-get install -y apache2 wget unzip
# -----------------------------------------------------------
# 4. Perguntar se deve iniciar o Apache agora
# -----------------------------------------------------------
read -p "➡️ Deseja iniciar o Apache agora? (s/n): " START_APACHE
if [[ "$START_APACHE" == "s" || "$START_APACHE" == "S" ]]; then
    systemctl start apache2
    echo "⚙️ Apache iniciado!"
else
    echo "ℹ️ Apache não foi iniciado."
fi
# -----------------------------------------------------------
# 5. Perguntar se deve habilitar na inicialização
# -----------------------------------------------------------
read -p "➡️ Deseja habilitar o Apache na inicialização do sistema? (s/n): " ENABLE_APACHE
if [[ "$ENABLE_APACHE" == "s" || "$ENABLE_APACHE" == "S" ]]; then
    systemctl enable apache2
    echo "🔄 Apache habilitado no boot!"
else
    echo "ℹ️ Apache não será carregado automaticamente."
fi
# -----------------------------------------------------------
# 6. Escolher template
# -----------------------------------------------------------
echo ""
echo "🎨 Escolha o template do seu site:"
echo "1) 🏢 Barber Shop - Site moderno para barbearia"
echo "2) 🎯 Finance Business - Site corporativo/financeiro"
echo "3) 🍕 Little Fashion - Loja virtual de moda"
echo "4) 💼 Mini Finance - Portfolio minimalista"
echo "5) 🏋️ Pod Talk - Site de podcast/fitness"
echo ""
read -p "Digite o número do template (1-5): " TEMPLATE_CHOICE
case $TEMPLATE_CHOICE in
    1)
        TEMPLATE_NAME="Barber Shop"
        TEMPLATE_URL="https://www.tooplate.com/zip-templates/2134_barber_shop.zip"
        TEMPLATE_DIR="2134_barber_shop"
        ;;
    2)
        TEMPLATE_NAME="Finance Business"
        TEMPLATE_URL="https://www.tooplate.com/zip-templates/2135_mini_finance.zip"
        TEMPLATE_DIR="2135_mini_finance"
        ;;
    3)
        TEMPLATE_NAME="Little Fashion"
        TEMPLATE_URL="https://www.tooplate.com/zip-templates/2130_little_fashion.zip"
        TEMPLATE_DIR="2130_little_fashion"
        ;;
    4)
        TEMPLATE_NAME="Mini Finance"
        TEMPLATE_URL="https://www.tooplate.com/zip-templates/2132_clean_work.zip"
        TEMPLATE_DIR="2132_clean_work"
        ;;
    5)
        TEMPLATE_NAME="Pod Talk"
        TEMPLATE_URL="https://www.tooplate.com/zip-templates/2133_moso_interior.zip"
        TEMPLATE_DIR="2133_moso_interior"
        ;;
    *)
        echo "⚠️ Opção inválida! Usando template padrão (Barber Shop)..."
        TEMPLATE_NAME="Barber Shop"
        TEMPLATE_URL="https://www.tooplate.com/zip-templates/2134_barber_shop.zip"
        TEMPLATE_DIR="2134_barber_shop"
        ;;
esac
# -----------------------------------------------------------
# 7. Baixar e instalar o template escolhido
# -----------------------------------------------------------
echo "🌐 Baixando template: $TEMPLATE_NAME..."
cd /tmp
rm -f template.zip
wget -O template.zip "$TEMPLATE_URL"
unzip -o template.zip
echo "📂 Instalando template no servidor..."
rm -rf /var/www/html/*
cp -r "$TEMPLATE_DIR"/* /var/www/html/
# Ajustar permissões
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
# -----------------------------------------------------------
# 8. Detectar IP automaticamente
# -----------------------------------------------------------
echo "🔍 Detectando IP da interface Host-Only..."
IP_HOSTONLY=$(ip -4 addr show | grep 'inet 192\.168' | awk '{print $2}' | cut -d'/' -f1 | head -n1)
# -----------------------------------------------------------
# 9. Verificar status do Apache
# -----------------------------------------------------------
APACHE_STATUS=$(systemctl is-active apache2 2>/dev/null || echo "inactive")
# -----------------------------------------------------------
# 10. Conclusão
# -----------------------------------------------------------
echo ""
echo "============================================================"
echo "✅ Instalação concluída com sucesso!"
echo "🎨 Template aplicado: $TEMPLATE_NAME"
echo "🔧 Status do Apache: $APACHE_STATUS"
echo ""
if [ -n "$IP_HOSTONLY" ]; then
    echo "🌐 Acesse seu site em:"
    echo "👉 http://$IP_HOSTONLY"
else
    echo "⚠️ Não foi possível detectar o IP automaticamente."
    echo "💡 Use o comando: ip addr show"
    echo "   Procure por um IP no formato 192.168.x.x"
fi
echo ""
echo "📊 Comandos úteis:"
echo "   • Verificar status: systemctl status apache2"
echo "   • Reiniciar Apache: systemctl restart apache2"
echo "   • Ver logs: tail -f /var/log/apache2/error.log"
echo ""
echo "✨ Script finalizado. Servidor web ativo e rodando!"
echo "👩‍💻 Criado por Fidelis"
echo "============================================================"
