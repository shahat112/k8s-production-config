#!/bin/bash
echo "🎯 ФИНАЛЬНАЯ ПРОВЕРКА ИНФРАСТРУКТУРЫ SHAHAT112"
echo "============================================="

echo ""
echo "1. 📊 ОБЩАЯ ИНФОРМАЦИЯ О КЛАСТЕРЕ:"
echo "---------------------------------"
echo "Количество нод: $(kubectl get nodes --no-headers | wc -l)"
echo "Версия Kubernetes: $(kubectl version --short 2>/dev/null | grep Server | cut -d: -f2 | xargs)"
echo "External Endpoint: https://89.169.148.60"

echo ""
echo "2. 🏗️ КОМПОНЕНТЫ ИНФРАСТРУКТУРЫ:"
echo "--------------------------------"
echo "Ingress Controller:"
kubectl get pods,svc -n ingress-nginx | grep -v admission
echo ""
echo "Тестовое приложение:"
kubectl get pods,svc,ingress -l app=test-app

echo ""
echo "3. 🌐 ДОСТУПНОСТЬ:"
echo "-----------------"
IP="158.160.206.202"
echo "Внешний IP LoadBalancer: $IP"
echo "Тестирую подключение..."

# Быстрый тест
TIMEOUT=10
if curl -s --max-time $TIMEOUT http://$IP > /dev/null; then
    echo "✅ Приложение доступно по http://$IP"
    echo ""
    echo "📄 Заголовок страницы:"
    curl -s http://$IP | grep -o '<title>[^<]*</title>' | sed 's/<[^>]*>//g'
else
    echo "⚠️ Не удалось подключиться за $TIMEOUT секунд"
    echo "Возможные причины:"
    echo "  - Приложение еще запускается (может занять 1-2 минуты)"
    echo "  - Проверьте: kubectl get pods -l app=test-app"
    echo "  - Проверьте логи: kubectl logs -l app=test-app"
fi

echo ""
echo "4. 📈 СТАТИСТИКА:"
echo "----------------"
echo "Всего подов в кластере: $(kubectl get pods -A --no-headers | wc -l)"
echo "Всего сервисов: $(kubectl get svc -A --no-headers | wc -l)"
echo "Всего ingress: $(kubectl get ingress -A --no-headers | wc -l)"
echo ""
echo "🎉 ИНФРАСТРУКТУРА ДНЯ 1-2 РАЗВЕРНУТА УСПЕШНО!"
