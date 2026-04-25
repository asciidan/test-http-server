FROM busybox:1.37

# Bust cache by fetching a constantly changing URL
ADD "https://time.akamai.com/?ms" /tmp/bustcache

RUN sleep 30

RUN adduser -D static
USER static
WORKDIR /home/static

COPY files .
RUN mv test.html index.html
CMD ["busybox", "httpd", "-f", "-v", "-p", "80"]
EXPOSE 80
