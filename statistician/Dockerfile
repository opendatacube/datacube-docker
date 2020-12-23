FROM opendatacube/geobase:wheels as env_builder

ARG py_env_path=/env

ENV LC_ALL=C.UTF-8

# Install our Python requirements
RUN mkdir -p /conf
COPY requirements.txt version.txt /conf/
RUN cat /conf/version.txt \
    && env-build-tool new /conf/requirements.txt ${py_env_path} /wheels

# Below is the actual image that does the running
FROM opendatacube/geobase:runner

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/env/bin:${PATH}" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

COPY --from=env_builder /env /env

# Add in the dask configuration
COPY distributed.yaml /root/.config/dask/distributed.yaml 

ADD requirements-apt-run.txt /tmp/
RUN apt-get update \
    && sed 's/#.*//' /tmp/requirements-apt-run.txt | xargs apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

RUN odc-stats --help
