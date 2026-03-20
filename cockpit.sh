#!/bin/bash

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Eye candy
info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; } 
err()   { echo -e "${RED}[ERROR]${NC} $*"; }

info "Установка Cockpit Manager..."

. /etc/os-release
apt install -t ${VERSION_CODENAME}-backports cockpit -y

USERNAME="wizzard"

# Проверка, существует ли пользователь
if id "$USERNAME" &>/dev/null; then
    err "Ошибка: пользователь $USERNAME уже существует!"
    exit 1
fi

# Запрос пароля (скрытый ввод)
echo -n "Введите пароль для пользователя $USERNAME: "
read -s PASSWORD
echo

# Проверка, что пароль не пустой
if [ -z "$PASSWORD" ]; then
    echo "Ошибка: пароль не может быть пустым!"
    exit 1
fi

useradd -m -s /bin/bash "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG sudo "$USERNAME"

info "Пользователь $USERNAME успешно создан!"

cat > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf <<EOF
[keyfile]
unmanaged-devices=none
EOF

nmcli con add type dummy con-name fake ifname fake0 ip4 192.0.2.2/24 gw4 192.0.2.1

cat > /etc/cockpit/cockpit.conf <<EOF
[WebService]
AllowMultiHost=false
RequireHost = false
LoginTo = false

[Session]
IdleTimeout=0
EOF

systemctl restart cockpit

info "Cockpit Manager установлен."

