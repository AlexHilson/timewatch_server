server {
    listen 443 ssl;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        proxy_pass ${proxy_pass};
        proxy_http_version 1.1;
        proxy_set_header Upgrade $$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $$host;
        proxy_cache_bypass $$http_upgrade;
    }
}
