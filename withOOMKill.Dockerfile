FROM busybox:1.37

RUN adduser -D static

WORKDIR /home/static
COPY files .
RUN mv test.html index.html

COPY start-with-oom.sh /usr/local/bin/start-with-oom.sh
RUN chmod +x /usr/local/bin/start-with-oom.sh

USER static
EXPOSE 3000
CMD ["/usr/local/bin/start-with-oom.sh"]