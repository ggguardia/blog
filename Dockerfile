FROM centos/python-36-centos7:latest

USER root

COPY . /tmp/src

RUN mv /tmp/src/.s2i/bin /tmp/scripts

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src
    

USER 1001

ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1

RUN /opt/app-root/bin/python3.9 -m pip install --upgrade pip

RUN pip uninstall psycopg2; pip list --outdated; pip install --upgrade wheel; pip install --upgrade setuptools; pip install psycopg2

RUN /tmp/scripts/assemble

CMD [ "/tmp/scripts/run" ]
