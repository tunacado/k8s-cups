FROM registry.fedoraproject.org/fedora-minimal
MAINTAINER Robb Manes <robbmanes@protonmail.com>

# Copy entrypoint script
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Setup environment variables
ENV CUPS_CONF=/etc/cups
ENV CUPS_LOGS=/var/log/cups
ENV CUPS_SPOOL=/var/spool/cups
ENV CUPS_CACHE=/var/cache/cups

# Install necessary packages
RUN microdnf install -y \
        cups \
	cups-client \
        hplip

# Setup cache before first run
RUN mkdir -p ${CUPS_CACHE}

# Setup non-root user for execution
RUN chgrp -R 0 ${CUPS_CONF} && \
    chgrp -R 0 ${CUPS_LOGS} && \
    chgrp -R 0 ${CUPS_SPOOL} && \
    chgrp -R 0 ${CUPS_CACHE} && \
    chmod -R g=u ${CUPS_CONF} && \
    chmod -R g=u ${CUPS_LOGS} && \
    chmod -R g=u ${CUPS_SPOOL} && \
    chmod -R g=u ${CUPS_CACHE} && \
    chmod -R g=u /etc/passwd

# We listen on non-standard port 6631 as rootless cannot
# bind ports under 1000
EXPOSE 6631

# Do not run as root
USER 1001

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
