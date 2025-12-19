FROM nginx:alpine

# Устанавливаем curl для health checks
RUN apk add --no-cache curl

# Копируем конфигурацию nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY html/ /usr/share/nginx/html/

# Создаем health check endpoint
RUN echo '{"status": "healthy", "service": "demo-app"}' > /usr/share/nginx/html/health

# Экспортируем порты
EXPOSE 80 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
