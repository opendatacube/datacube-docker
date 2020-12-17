FROM opendatacube/geobase:wheels as env_builder

ARG py_env_path=/env

ENV LC_ALL=C.UTF-8

# Install our requirements
RUN mkdir -p /conf
COPY requirements.txt version.txt /conf/
RUN cat /conf/version.txt \
    && env-build-tool new /conf/requirements.txt ${py_env_path} /wheels

FROM opendatacube/geobase:runner
COPY --from=env_builder /env /env

ENV PATH="/env/bin:${PATH}"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Do the apt install process, including more recent Postgres/PostGIS
RUN apt-get update && apt-get install -y wget gnupg \
    && rm -rf /var/lib/apt/lists/*
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" \
    >> /etc/apt/sources.list.d/postgresql.list

ADD requirements-apt-run.txt /tmp/
RUN apt-get update \
    && sed 's/#.*//' /tmp/requirements-apt-run.txt | xargs apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Copy Datacube bootstrapping and other scripts
ADD ./assets /code

## Do some symlinking
RUN ln -s /code/bootstrap-odc.sh /usr/local/bin/bootstrap-odc.sh
