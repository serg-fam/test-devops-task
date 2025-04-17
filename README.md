# DevOps Test Task: Deployment Guide

This project deploys a containerized Python application with CI/CD, monitoring (Prometheus/Grafana/Alertmanager), and system metrics collection.

---

## Prerequisites
- **Docker** 
- **Docker Compose**
- Available ports: `5000`, `8080`, `3000`, `9090`, `9093`, `9100`, `8081`

---

## Quick Start

### 1. Clone and deploy

git clone https://github.com/your-username/test-devops-task.git
cd test-devops-task
docker compose up -d

### 2. Access services
| Service        | URL                        | Credentials             |
|----------------|----------------------------|-------------------------|
| Python App     | http://localhost:5000      | -                       |
| Jenkins        | http://localhost:8080      | Initial password from logs |
| Grafana        | http://localhost:3000      | `admin`/`admin`         |
| Prometheus     | http://localhost:9090      | -                       |
| Alertmanager   | http://localhost:9093      | -                       |

---

##  Component Configuration

### Jenkins CI/CD Pipeline
1. **Get initial admin password**:
   
   docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

2. Install recommended plugins
3. Create **Freestyle Project**:
   - Under **Source Code Management**:  
     - Select Git: `https://github.com/your-username/devops-test-task.git`
   - Under **Build** → **Process Job DSLs**:  
     - Check "Use DSL script from SCM"  
     - Script path: `jenkins/Jenkinsfile`

Pipeline stages:
1. **Build**: Creates Docker image
2. **Deploy**: Starts app container
3. **Test**: Verifies `/health` endpoint

---

## Monitoring Stack

### Architecture
- **Prometheus**: Collects metrics from:
  - Node Exporter (host metrics)
  - cAdvisor (container metrics)
  - Application (HTTP health)
- **Alertmanager**: Processes alerts from Prometheus
- **Grafana**: Visualizes metrics via dashboards

### Setup
1. **Grafana**:
   - Import dashboards:
     - Docker & System Monitoring: ID `10619`
     - Alertmanager: ID `11074`
2. **Alertmanager**:
   - Configure receivers in `alertmanager/alertmanager.yml`:
     ```yaml
     receivers:
     - name: 'slack-notifications'
       slack_configs:
       - api_url: 'https://hooks.slack.com/services/XXX/YYY/ZZZ'
         channel: '#alerts'
     ```
3. **Prometheus Alerts**:
   - Preconfigured rules in `prometheus/alerts.yml`:
     - High CPU (>80% for 5m)
     - Container memory (>512MB for 5m)

---

##  Maintenance

### Backup Jenkins

./scripts/backup.sh  # Creates backup in ./backups/

### Stop infrastructure

docker compose down

### Restart components

docker compose restart [service_name]

## Optimizations
- **Docker layer caching** in `app/Dockerfile`
- **Parallel test stages** (extend Jenkinsfile)
- **Prometheus retention tuning** (add to `prometheus.yml`):
  
  retention: 7d
  
---

## Troubleshooting

| Issue                          | Solution                                  |
|--------------------------------|-------------------------------------------|
| Port conflicts                 | Check `docker compose ps`                |
| Pipeline failures              | Check `docker compose logs jenkins`      |
| Missing metrics                | Verify Prometheus targets: `http://localhost:9090/targets` |
| Alerts not firing              | Check Alertmanager status: `http://localhost:9093/#/status` |

---

This README provides:
- Full deployment instructions
- Monitoring/alerting explanations
- Maintenance procedures
- Architecture overview
- Troubleshooting guide
- Ready-to-use commands
