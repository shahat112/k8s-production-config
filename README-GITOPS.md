# GitOps Infrastructure with ArgoCD

Этот проект демонстрирует полноценную GitOps инфраструктуру на базе ArgoCD.

## 🚀 Быстрый старт

### 1. Настройка ArgoCD Applications
```bash
# Применить ArgoCD Applications
./setup-argocd.sh

# Проверить статус
./check-sync.sh
2. Доступ к интерфейсам
ArgoCD UI: http://argocd.158.160.206.202.nip.io

Логин: admin

Пароль: см. вывод setup-argocd.sh

Grafana: http://grafana.158.160.206.202.nip.io (admin/admin)

Prometheus: http://prometheus.158.160.206.202.nip.io

Приложения:

Dev: http://dev.demo-app.158.160.206.202.nip.io

Prod: http://prod.demo-app.158.160.206.202.nip.io

📁 Структура проекта
text
k8s-manifests/
├── base/demo-app/          # Базовые манифесты
├── overlays/dev/           # Конфигурация для dev
├── overlays/prod/          # Конфигурация для prod
└── applications/           # ArgoCD Application манифесты
🔄 GitOps Workflow
Разработка (ветка develop):

Изменения в коде → Push в develop

ArgoCD автоматически деплоит в dev namespace

Продакшн (ветка main):

Merge develop → main

ArgoCD автоматически деплоит в prod namespace

Мануальное подтверждение можно настроить через SyncPolicy

🛠️ Полезные команды
Ручной деплой
bash
# Dev
kubectl kustomize k8s-manifests/overlays/dev | kubectl apply -f -

# Prod
kubectl kustomize k8s-manifests/overlays/prod | kubectl apply -f -
Проверка статуса
bash
# Проверить статус синхронизации
./check-sync.sh

# Проверить все поды
./check-status.sh

# Посмотреть логи ArgoCD
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
Работа с ArgoCD CLI
bash
# Скачать ArgoCD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd

# Логин в ArgoCD
./argocd-login.sh

# Список приложений
argocd app list

# Информация о приложении
argocd app get demo-app-dev

# Ручная синхронизация
argocd app sync demo-app-dev
🔧 Настройка GitHub Actions
Создайте репозиторий на GitHub

Добавьте секреты:

KUBE_CONFIG - содержимое kubeconfig файла

Настройте remote и запушите код:

bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
🚨 Мониторинг и алерты
Приложения автоматически мониторятся через:

Prometheus: Сбор метрик

Grafana: Дашборды

AlertManager: Алерты

Метрики доступны на порту 8080: http://<pod-ip>:8080/metrics
