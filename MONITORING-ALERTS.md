### Changes:
1. Added `alerting` section pointing to Alertmanager
2. Added `evaluation_interval` parameter to control alert rule check frequency
3. Specified correct path to alert rules file (`alerts.yml`)

### Verification Steps:
1. Restart Prometheus:

docker compose restart prometheus

2. Check Alertmanager status in Prometheus UI:
   - Open http://localhost:9090/status
   - Under **Alertmanagers** section, you should see `alertmanager:9093`

3. Verify loaded rules:
   - Navigate to http://localhost:9090/rules
   - Alert rules from `alerts.yml` should be visible

4. Trigger test alert:

# Simulate high CPU load
docker compose exec app stress --cpu 2 --timeout 60s

After 5 minutes, the **HighCPU** alert will appear in Alertmanager (http://localhost:9093).