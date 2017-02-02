FROM docker:1.13.0-dind

RUN apk --update add logrotate
RUN echo "*/5 *	* * *	/usr/sbin/logrotate /etc/logrotate.conf" >> /etc/crontabs/root
RUN mkdir -p /var/log/nginx
ADD logrotate.conf /etc/logrotate.conf
ADD start.sh /root/start.sh
RUN chmod +x /root/start.sh

CMD ["/root/start.sh"]