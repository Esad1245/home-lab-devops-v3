Home Lab DevOps v3 ✨

A complete DevOps Azure Home Lab project featuring Terraform, Kubernetes (AKS), GitHub Actions, CI/CD, Prometheus, Grafana, and Ingress – built to demonstrate professional DevOps skills.

🌐 Overview

This project sets up a production-like cloud infrastructure in Azure:

Infrastructure as Code with Terraform

Kubernetes workloads (API + Web App)

CI/CD pipelines with GitHub Actions

Observability with Prometheus, Grafana, and alert rules

Security using RBAC, secrets, and Ingress controller

📈 Technologies

Area

Technology

Infrastructure

Terraform, Azure Resource Group, AKS

CI/CD

GitHub Actions, GitHub Secrets

Kubernetes

AKS, Deployments, Services, Ingress

Observability

Prometheus, Grafana, Alertmanager

Logging

Azure Monitor (optional), Grafana dashboards

Security

Secrets Store CSI Driver, RBAC, TLS, private endpoints

🧰 Project Structure

home-lab-devops-v3/
├── api/                         # Node.js API with Dockerfile
├── app/                         # HTML frontend with Dockerfile
├── terraform/                   # Terraform code for Azure + AKS
├── k8s/                         # Kubernetes manifests for workloads, ingress, monitoring
├── .github/workflows/           # CI/CD workflows (deploy.yaml)
└── README.md

🚀 Getting Started

1. Clone the repo

git clone https://github.com/Esad1245/home-lab-devops-v3.git
cd home-lab-devops-v3

2. Set up Azure credentials

Add the following secrets to your GitHub repository:

AZURE_SUBSCRIPTION_ID

AZURE_CLIENT_ID

AZURE_CLIENT_SECRET

AZURE_TENANT_ID

AZURE_CREDENTIALS

3. Deploy with Terraform

cd terraform
terraform init
terraform apply

4. Trigger CI/CD workflow

Pushing to main branch will automatically deploy to AKS via GitHub Actions:

git push origin main

🔹 Features

Full automation from infrastructure to deployment

Node.js API & static HTML frontend

Prometheus monitoring + Grafana dashboards

Path-based Ingress routing for all apps

Secure setup using Kubernetes RBAC & Secrets

Optional logging with Azure Monitor

📊 Grafana Dashboards

Node Exporter (ID: 1860)

Kubernetes cluster & workload dashboards

Alertmanager Overview

🌎 Live Demo

http://50.85.54.34/grafana http://50.85.54.34/api http://50.85.54.34/app

Ingress is set up with NGINX and path-based routing

⏱️ Azure Auto Shutdown

AKS is configured to shut down automatically at night (e.g. 23:00) to save costs. You can manage or adjust this using Azure CLI or Automation.

📄 License

MIT License

🧠 Interview Ready?

Yes! This project is built to impress employers and demonstrate your real-world DevOps abilities:

Terraform + CI/CD + AKS + Monitoring

Clean documentation and structure

Focus on automation, security, and observability

✨ Contributing

Feedback, PRs, and ideas are welcome!

✅ CI Status Badge

Coming soon...


