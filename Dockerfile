FROM stackbrew/ubuntu:13.10

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y exim4
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mailman

RUN mkdir -p /var/www/lists
RUN rm /etc/apache2/sites-enabled/*
ADD apache2/lists.drugis.org /etc/apache2/sites-enabled/lists.drugis.org.conf
RUN ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

ADD apache2-fg.sh /usr/local/bin/apache2-fg
RUN chmod +x /usr/local/bin/apache2-fg

# If you have an existing mailman configuration, create a TAR of the data using
# cd /var/lib/mailman && sudo tar -cpvW -f mailman.data.tar ./data ./archives ./lists && sudo gzip mailman.data.tar
# If not, comment out the below lines:
ADD mailman/mailman.data.tar.gz /var/lib/mailman/mailman.data.tar.gz
RUN cd /var/lib/mailman && tar xzf mailman.data.tar.gz
RUN rm /var/lib/mailman/mailman.data.tar.gz

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/apache2-fg"]
