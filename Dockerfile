FROM nginx:latest

# Override nginx config: run worker as root.
COPY nginx.conf /etc/nginx/nginx.conf

# Remove default nginx static content.
RUN rm -rf /usr/share/nginx/html/*

# Copy H5 site files to nginx web root.
COPY . /usr/share/nginx/html

# Ensure nginx worker process can read all files/directories.
RUN chmod 755 /usr/share /usr/share/nginx /usr/share/nginx/html \
  && find /usr/share/nginx/html -type d -exec chmod 755 {} \; \
  && find /usr/share/nginx/html -type f -exec chmod 644 {} \;

EXPOSE 80

CMD ["sh", "-c", "chown -R root:root /usr/share/nginx/html 2>/dev/null || true; chmod 755 /usr/share /usr/share/nginx /usr/share/nginx/html 2>/dev/null || true; find /usr/share/nginx/html -type d -exec chmod 755 {} \\; 2>/dev/null || true; find /usr/share/nginx/html -type f -exec chmod 644 {} \\; 2>/dev/null || true; echo \"[entrypoint] effective user: $(id)\"; ls -ld /usr/share/nginx/html || true; ls -l /usr/share/nginx/html/index.html || true; exec nginx -c /etc/nginx/nginx.conf -g 'daemon off;'"]
