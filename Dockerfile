FROM alpine

RUN apk add --no-cache openssh

RUN mkdir /var/run/sshd \
    && mkdir -p 700 /root/.ssh \
    && install -b -m 600 /dev/null /root/.ssh/authorized_keys

ADD docker-entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["-D"]
