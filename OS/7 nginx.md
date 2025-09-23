# Конспект по работе с Nginx
```bash
# Установка
sudo dnf install nginx

# Запуск/остановка/перезагрузка
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx

# Плавная перезагрузка конфига
sudo systemctl reload nginx

# Автозагрузка
sudo systemctl enable nginx
sudo systemctl disable nginx

# Статус
sudo systemctl status nginx

# Проверка конфигурации (ОБЯЗАТЕЛЬНО перед перезагрузкой!)
sudo nginx -t

# Просмотр версии и настроек
nginx -v
nginx -V

# Перезапуск с проверкой конфига
sudo nginx -t && sudo systemctl reload nginx

# Основной конфиг
/etc/nginx/nginx.conf

# Дополнительные конфиги
/etc/nginx/conf.d/*.conf

# Конфиги сайтов (в некоторых дистрибутивах)
/etc/nginx/sites-available/
/etc/nginx/sites-enabled/

# Корневая директория по умолчанию
/usr/share/nginx/html/

# Копирование файлов
sudo cp index.html /usr/share/nginx/html/

# Права доступа
sudo chown -R nginx:nginx /usr/share/nginx/html/
sudo chmod -R 644 /usr/share/nginx/html/

# Открыть порты
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Разрешить нестандартный порт
sudo semanage port -a -t http_port_t -p tcp 8080

# Разрешить сетевые подключения
sudo setsebool -P httpd_can_network_connect 1
```