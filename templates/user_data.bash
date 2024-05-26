#!/usr/bin/env bash

set -xeuo pipefail

timedatectl set-timezone Asia/Tokyo

dnf install -y git python3.11 python3.11-pip

pip3.11 install poetry==1.7.1

git clone "https://github.com/yktakaha4/aws-fis-newbie"

cd "aws-fis-newbie"
poetry install

cat <<EOF > /etc/systemd/system/web.service
[Unit]
Description=web
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user
Environment=POSTGRES_HOST=${postgres_host}
Environment=POSTGRES_PORT=${postgres_port}
Environment=POSTGRES_USER=${postgres_user}
Environment=POSTGRES_PASSWORD=${postgres_password}
Environment=POSTGRES_DB=${postgres_db}
ExecStart=/home/ec2-user/.local/bin/poetry run python /home/ec2-user/aws-fis-newbie/web.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable web
systemctl start web
