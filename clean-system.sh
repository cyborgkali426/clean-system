#!/bin/bash

# Script para limpar arquivos temporários, cache e sujeira do sistema
# Compatível com Debian 12

# Função para exibir mensagens formatadas
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
    log "Erro: Este script deve ser executado como root."
    exit 1
fi

log "Iniciando a limpeza do sistema..."

# 1. Limpar pacotes desnecessários (pacotes órfãos)
log "Removendo pacotes desnecessários..."
apt-get autoremove -y >/dev/null 2>&1
apt-get autoclean -y >/dev/null 2>&1
apt-get clean -y >/dev/null 2>&1

# 2. Limpar arquivos temporários
log "Limpando arquivos temporários..."
rm -rf /tmp/* >/dev/null 2>&1
rm -rf /var/tmp/* >/dev/null 2>&1

# 3. Limpar cache do sistema
log "Limpando cache do apt..."
find /var/cache/apt/ -type f -delete >/dev/null 2>&1

# 4. Limpar logs antigos
log "Limpando logs antigos..."
find /var/log/ -type f -exec truncate -s 0 {} \; >/dev/null 2>&1

# 5. Limpar thumbnails gerados pelo usuário
log "Limpando thumbnails..."
rm -rf /home/*/.cache/thumbnails/* >/dev/null 2>&1
rm -rf /root/.cache/thumbnails/* >/dev/null 2>&1

# 6. Limpar arquivos de backup do sistema
log "Limpando arquivos de backup..."
rm -f /etc/*.dpkg-old >/dev/null 2>&1
rm -f /etc/*.dpkg-new >/dev/null 2>&1
rm -f /etc/*.dpkg-dist >/dev/null 2>&1

# 7. Limpar arquivos de swap
log "Limpando arquivos de swap..."
swapoff -a >/dev/null 2>&1
swapon -a >/dev/null 2>&1

# 8. Limpar pacotes baixados (.deb) no diretório /var/cache/apt/archives/
log "Limpando pacotes .deb baixados..."
rm -rf /var/cache/apt/archives/*.deb >/dev/null 2>&1

# 9. Limpar histórico de comandos dos usuários
log "Limpando histórico de comandos..."
for user_home in /home/*; do
    [ -f "$user_home/.bash_history" ] && >"$user_home/.bash_history"
done
[ -f /root/.bash_history ] && > /root/.bash_history

# 10. Limpar arquivos de configuração de aplicativos
log "Limpando arquivos de configuração de aplicativos..."
rm -rf /home/*/.config/* >/dev/null 2>&1
rm -rf /root/.config/* >/dev/null 2>&1

# Finalização
log "Limpeza concluída com sucesso!"
log "O sistema está mais limpo e organizado."