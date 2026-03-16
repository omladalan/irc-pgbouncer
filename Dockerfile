FROM debian:trixie-slim

# Update and install
RUN apt update && apt upgrade -y \
    && apt install -y pgbouncer \       
    && rm -rf /var/lib/apt/lists/*

RUN chown postgres:postgres /etc/pgbouncer/pgbouncer.ini && chmod 640 /etc/pgbouncer/pgbouncer.ini

COPY ./initialize.sh /usr/local/bin/initialize.sh

RUN chmod +x /usr/local/bin/initialize.sh

USER postgres

EXPOSE 6432

CMD ["/usr/local/bin/initialize.sh"]