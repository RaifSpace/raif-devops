#!/bin/bash
set -e

REPO="/backup"
export RESTIC_PASSWORD="123abc"
SSH_KEY="backup_key"

# Функция для выполнения бэкапа
backup_server() {
    SERVER=$1
    SOURCE=$2
    TAG=$3

    echo "Starting backup for $SERVER ($TAG)..."
    ssh -i $SSH_KEY yc-user@$SERVER "sudo tar czf - $SOURCE" | sudo -E restic -r $REPO backup --stdin --stdin-filename "${SERVER}_${TAG}_$(date +%Y-%m-%d).tar.gz" --tag $TAG
    echo "Backup for $SERVER ($TAG) completed."
}

# Полный бэкап (воскресенье)
if [ $(date +%u) -eq 7 ]; then
    backup_server "89.169.159.157" "/etc /boot /root /var /usr /opt /home /srv" "full"
    backup_server "89.169.135.4" "/etc /boot /root /var /usr /opt /home /srv" "full"
    backup_server "89.169.154.113" "/etc /boot /root /var /usr /opt /home /srv" "full"
else
    # Инкрементальный бэкап
    backup_server "89.169.159.157" "/etc/openvpn" "incremental"
    backup_server "89.169.135.4" "/home/yc-user/easy-rsa" "incremental"
    backup_server "89.169.154.113" "/var/lib/prometheus /etc/prometheus" "incremental"
fi

# Ротация бэкапов
echo "Rotating backups..."
sudo -E restic -r $REPO forget --keep-last 7 --keep-daily 30 --keep-weekly 12 --keep-monthly 12 --prune
echo "Backup rotation completed."
