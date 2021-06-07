ARG V_BASE=3.3.0
ARG py_env_path=/env

FROM opendatacube/geobase-builder:${V_BASE} as env_builder
ENV LC_ALL=C.UTF-8
# Install our Python requirements
COPY requirements.txt constraints.txt version.txt /conf/

ARG py_env_path
RUN cat /conf/version.txt \
    && env-build-tool new /conf/requirements.txt /conf/constraints.txt ${py_env_path}

# Below is the actual image that does the running
FROM opendatacube/geobase-runner:${V_BASE}

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/env/bin:${PATH}" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

# Do the apt install process, including more recent Postgres/PostGIS
RUN apt-get update && apt-get install -y wget gnupg \
    && rm -rf /var/lib/apt/lists/*

ADD requirements-apt-run.txt /tmp/
RUN apt-get update \
    && sed 's/#.*//' /tmp/requirements-apt-run.txt | xargs apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 odc \
  && useradd --gid 1000 --uid 1000 --create-home --shell /bin/bash -N odc \
  && adduser odc users \
  && install -d -o odc -g odc /env \
  && install -d -o odc -g odc /code \
  && true

ARG py_env_path
COPY --from=env_builder /env /env

# Copy Datacube bootstrapping and other scripts
ADD ./assets /code

# Allow non-root user to read/write the python env and code dir
RUN chown -R odc:odc /env /code
WORKDIR /home/odc
USER odc

## Do some symlinking
RUN ln -s /code/bootstrap-odc.sh /usr/local/bin/bootstrap-odc.sh
