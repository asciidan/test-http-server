FROM busybox:1.37

RUN adduser -D static

WORKDIR /home/static
COPY files .
RUN mv test.html index.html

COPY start-with-json-logs.sh /usr/local/bin/start-with-json-logs.sh
RUN chmod +x /usr/local/bin/start-with-json-logs.sh

USER static
EXPOSE 80
CMD ["/usr/local/bin/start-with-json-logs.sh"]
