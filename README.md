# Raspberry Pi Home Security & Monitoring Server

A small home security and monitoring project built on a Raspberry Pi 4. The aim of this project was to turn the Pi into something useful for my home network while also showing practical skills in Linux, networking, DNS filtering, monitoring, and security hardening.

## Overview

This project uses a Raspberry Pi as a lightweight DNS filtering and monitoring server. Pi-hole is used to filter DNS requests from my Windows PC, while Prometheus and Grafana are used to collect and visualise system and DNS metrics.

Fail2Ban was also added to monitor SSH login attempts and provide basic brute-force protection.

## Features

- Pi-hole DNS filtering
- Windows PC configured to use the Pi as DNS
- Static DHCP reservation for the Raspberry Pi
- SSH access for remote management
- Fail2Ban protection for SSH
- Prometheus metrics collection
- Node Exporter for Raspberry Pi system metrics
- Pi-hole Exporter for DNS metrics
- Grafana dashboards for system and Pi-hole monitoring

## Hardware Used

- Raspberry Pi 4 Model B
- 1GB RAM
- microSD card
- Power supply
- Wi-Fi connection

## Network Details

| Item | Value |
|---|---|
| Hostname | `pi-security-server` |
| Raspberry Pi IP | `192.168.1.13` |
| Interface | `wlan0` |
| Pi-hole | `http://192.168.1.13/admin` |
| Prometheus | `http://192.168.1.13:9090` |
| Grafana | `http://192.168.1.13:3000` |
| Node Exporter | `http://192.168.1.13:9100/metrics` |
| Pi-hole Exporter | `http://192.168.1.13:9617/metrics` |

## Technologies Used

- Raspberry Pi OS / Debian
- Linux
- SSH
- Pi-hole
- Fail2Ban
- Prometheus
- Node Exporter
- Grafana
- Docker
- Pi-hole Exporter

## Architecture

```text
Windows PC
   |
   | DNS requests
   v
Raspberry Pi 4
   |
   |-- Pi-hole: DNS filtering
   |-- Fail2Ban: SSH protection
   |-- Node Exporter: system metrics
   |-- Pi-hole Exporter: DNS metrics
   |-- Prometheus: metrics collection
   |-- Grafana: dashboards
```

## Setup Summary

The Raspberry Pi was given a reserved local IP address so that the services could be accessed consistently. Pi-hole was installed and configured on the `wlan0` interface. My Windows PC was then manually configured to use the Raspberry Pi as its DNS server.

After that, Fail2Ban was added for SSH protection, and monitoring was set up using Prometheus, Node Exporter, Pi-hole Exporter, and Grafana.

## Pi-hole DNS Filtering

Pi-hole is used to filter DNS requests from my Windows PC.

Current setup:

```text
Pi-hole IP: 192.168.1.13
Interface: wlan0
DNS provider: Cloudflare
Query logging: enabled
```

My Windows PC was configured to use:

```text
Preferred DNS: 192.168.1.13
```

This means only my PC is currently using Pi-hole, rather than changing DNS for the whole home network.

## Screenshot: Pi-hole Dashboard

<img width="1250" height="931" alt="image" src="https://github.com/user-attachments/assets/ae57a348-9574-4b4a-8446-50c490baf597" />



## Screenshot: Pi-hole Query Log

<img width="1258" height="929" alt="pihole-query-log" src="https://github.com/user-attachments/assets/9ad008ed-4a3e-4d66-be55-6d8babc3c27a" />


## Security Hardening

Fail2Ban was installed to monitor SSH login attempts and help protect the Raspberry Pi from repeated failed login attempts.

The SSH jail was configured with:

```ini
[sshd]
enabled = true
port = ssh
filter = sshd
backend = systemd
maxretry = 3
findtime = 10m
bantime = 1h
```

Useful command:

```bash
sudo fail2ban-client status sshd
```

## Screenshot: Fail2Ban SSH Status


<img width="1621" height="233" alt="fail2ban-sshd-status" src="https://github.com/user-attachments/assets/89da34c4-db85-4223-9538-04489de5ef16" />


## Monitoring

Prometheus is used to collect metrics from the Raspberry Pi and Pi-hole.

Metrics collected:

```text
Node Exporter: localhost:9100
Pi-hole Exporter: localhost:9617
```

Prometheus scrape targets:

```yaml
scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'pihole'
    static_configs:
      - targets: ['localhost:9617']
```

## Screenshot: Prometheus Targets

<img width="1911" height="728" alt="prometheus-targets" src="https://github.com/user-attachments/assets/adb9bd0c-2576-4395-8bd5-a079972a6555" />


## Grafana Dashboards

Two Grafana dashboards were used for this project.

The first dashboard monitors Pi-hole activity, including DNS queries, clients seen, ads blocked, and forward destinations.

The second dashboard uses Node Exporter to monitor the Raspberry Pi itself, including CPU, RAM, disk usage, network traffic, and uptime.

## Screenshot: Grafana Pi-hole Dashboard


<img width="1616" height="789" alt="pihole-monitoring-dashboard" src="https://github.com/user-attachments/assets/c5f413a3-7716-4607-bb9b-1f6563994889" />


## Screenshot: Node Exporter Dashboard

<img width="1597" height="920" alt="node-exporter-dashboard" src="https://github.com/user-attachments/assets/46a40488-6545-45db-b574-fd3b889337d9" />


## Useful Commands

Check Pi-hole status:

```bash
pihole status
```

Check Fail2Ban SSH jail:

```bash
sudo fail2ban-client status sshd
```

Check Node Exporter metrics:

```bash
curl http://localhost:9100/metrics | head
```

Check Pi-hole Exporter metrics:

```bash
curl http://localhost:9617/metrics | grep pihole | head
```

Test Pi-hole data in Prometheus:

```bash
curl "http://localhost:9090/api/v1/query?query=pihole_dns_queries_today"
```

## What I Learned

This project helped me get more hands-on experience with Linux administration, DNS filtering, SSH access, basic security hardening, Docker, Prometheus, and Grafana.

It also gave me a better understanding of how monitoring tools fit together in a small home lab environment.

## Future Improvements

- Set up SSH key-based login
- Disable SSH password authentication
- Add Grafana alerts for downtime or high resource usage
- Create an automated Pi-hole backup script
- Add a basic maintenance script for updates and health checks
