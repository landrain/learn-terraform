# Install Nginx
 
```
Run ./install-nginx.sh
```

# Setup Certbot

```
1. sudo apt-get remove certbot
2. sudo snap install --classic certbot
3. sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

# Adding Reverse Proxy Server Configuration

```
1. Add service config in /etc/nginx/conf.d
2. Find example on /etc/nginx/conf.d/airbyte.conf
3. Generate SSL certificate using cerbot : sudo certbot --nginx
```
