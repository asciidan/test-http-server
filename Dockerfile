FROM busybox:1.37

RUN adduser -D static
USER static
WORKDIR /home/static

COPY files .
RUN mv test.html index.html
CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]
EXPOSE 3000
