FROM registry.fedoraproject.org/fedora-minimal
RUN microdnf install -y \
        cups \
	cups-client \
        hplip
EXPOSE 631
CMD ["/usr/sbin/cupsd", "-f"]
