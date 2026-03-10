### VS Code in the Browser with HTTPS using Nginx + Docker

![Docker](https://img.shields.io/badge/docker-ready-blue)
![VS Code](https://img.shields.io/badge/code--server-vscode-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20windows-blue)
![Security](https://img.shields.io/badge/security-https-important)

Run **VS Code in the browser securely** using **code-server**, **Nginx reverse proxy**, and **Docker Compose**.

This project provides a **simple and secure lab/development environment** where:

* VS Code runs inside Docker
* Only HTTPS is exposed to the network
* code-server itself is **never directly accessible**
* Traffic is encrypted using TLS

Designed for:

* Personal development environments
* University labs
* Internal networks
* Secure remote programming

---

# Architecture

## System Overview

```
           ┌───────────────────────┐
           │        Browser        │
           │ https://IP:8123       │
           └────────────┬──────────┘
                        │
                        │ HTTPS (TLS)
                        ▼
            ┌──────────────────────┐
            │      Nginx Proxy     │
            │   Docker Container   │
            └────────────┬─────────┘
                         │
                         │ HTTP (internal docker network)
                         ▼
            ┌──────────────────────┐
            │     code-server      │
            │   Docker Container   │
            └──────────────────────┘
```

### Security Design

* Only **Nginx exposes a network port**
* `code-server` runs on an **internal Docker network**
* TLS encryption protects browser traffic
* Password authentication protects VS Code

---

# Features

✔ VS Code in the browser
✔ HTTPS encrypted connection
✔ Docker-based deployment
✔ Isolated backend container
✔ Persistent workspace storage
✔ Works on Linux / Windows / Mac

---

# Requirements

Install:

* Docker
* Docker Compose

Verify installation:

```bash
docker --version
docker compose version
```

---

# Project Structure

```
secure-code-server-docker
│
├── docker-compose.yml
├── nginx.conf
├── README.md
│
└── ssl
    ├── nginx-selfsigned.crt
    └── nginx-selfsigned.key
```

---

# Quick Start

## 1️⃣ Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/secure-code-server-docker.git
cd secure-code-server-docker
```

---

## 2️⃣ Generate SSL Certificate

Create SSL folder:

```bash
mkdir ssl
```

Generate certificate using Docker:

```bash
docker run --rm -v ${PWD}/ssl:/ssl alpine/openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /ssl/nginx-selfsigned.key \
-out /ssl/nginx-selfsigned.crt \
-subj "/C=US/ST=Texas/L=Denton/O=Lab/OU=CodeServer/CN=localhost"
```

---

## 3️⃣ Start the Server

```bash
docker compose up -d
```

Check containers:

```bash
docker ps
```

---

# Access the Server

Open a browser:

```
https://YOUR-IP:8123
```

Example:

```
https://192.168.1.25:8123
```

⚠ Because the certificate is self-signed, the browser will display a **security warning**.

Choose:

```
Advanced → Proceed
```

---

# Login Credentials

Default password defined in:

```
docker-compose.yml
```

Example:

```yaml
environment:
  - PASSWORD=changeme
```

---

# Change Password

Edit:

```yaml
docker-compose.yml
```

Example:

```yaml
environment:
  - PASSWORD=myNewSecurePassword
```

Restart containers:

```bash
docker compose down
docker compose up -d
```

---

# Docker Networking

Docker Compose automatically creates an **internal network**.

```
nginx → code-server
```

The service name acts as DNS.

Example inside nginx config:

```
proxy_pass http://code-server:8080;
```

This resolves automatically using Docker's internal DNS.

---

# Persistent Storage

Docker volumes store user data:

| Volume             | Purpose                     |
| ------------------ | --------------------------- |
| code-server-data   | extensions & workspace data |
| code-server-config | settings & configuration    |

Data persists even if containers restart.

---

# Security

## Network Protection

| Component   | Exposure                     |
| ----------- | ---------------------------- |
| Nginx       | Exposed (HTTPS only)         |
| Code Server | Internal Docker network only |

Users **cannot directly access code-server**.

---

## Encryption

TLS encryption protects browser communication.

```
Browser → HTTPS → Nginx → HTTP → code-server
```

Internal Docker traffic remains inside the host.

---

## Authentication

code-server requires password authentication.

```
auth: password
```

---

## Recommended Usage

Not recommended for:

* Public internet exposure
* Production hosting without additional security layers

---

# Useful Commands

### View running containers

```bash
docker ps
```

### View logs

```bash
docker logs code-server
docker logs code-server-nginx
```

### Restart services

```bash
docker compose restart
```

### Stop server

```bash
docker compose down
```

---

# Troubleshooting

| Problem                       | Cause                   | Solution                            |
| ----------------------------- | ----------------------- | ----------------------------------- |
| Nginx cannot load certificate | Missing SSL files       | Ensure files exist in `/ssl` folder |
| Browser connection refused    | Container not running   | Run `docker ps`                     |
| Cannot login                  | Wrong password          | Update PASSWORD in compose file     |
| Cannot reach server           | Firewall blocked        | Ensure port **8123** open           |
| 502 Bad Gateway               | code-server not running | Check container logs                |

---

# Logs

Check nginx logs:

```bash
docker logs code-server-nginx
```

Check code-server logs:

```bash
docker logs code-server
```

---

# License

MIT License

Free for personal and educational use.

---

# Contributing

Pull requests welcome.

For major changes, please open an issue first to discuss improvements.

---

# Acknowledgements

* code-server
* Docker
* Nginx
* OpenSSL

---

