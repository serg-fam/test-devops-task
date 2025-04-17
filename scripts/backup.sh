#!/bin/bash
BACKUP_DIR="./backups"
mkdir -p $BACKUP_DIR
docker compose exec -T jenkins tar czf - /var/jenkins_home > "$BACKUP_DIR/jenkins_$(date +%F).tar.gz"