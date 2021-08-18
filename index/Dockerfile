ARG V_BASE=3.3.0

FROM opendatacube/geobase-builder:${V_BASE} as env_builder
ENV LC_ALL=C.UTF-8

ARG py_env_path=/env

# Install our Python requirements
COPY requirements.txt constraints.txt nobinary.txt version.txt /conf/

RUN cat /conf/version.txt \
  && NOBINARY=/conf/nobinary.txt env-build-tool new /conf/requirements.txt /conf/constraints.txt ${py_env_path} \
  && rm -rf /root/.cache/pip \
  && echo done

ENV PATH="${py_env_path}/bin:${PATH}"
RUN pip freeze

# Below is the actual image that does the running
FROM opendatacube/geobase-runner:${V_BASE}
ARG py_env_path=/env

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="${py_env_path}/bin:${PATH}" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

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

COPY --from=env_builder /env /env

# Copy Datacube bootstrapping and other scripts
ADD ./assets /code
RUN wget -q https://github.com/opendatacube/datacube-dataset-config/archive/refs/heads/main.zip \
    -O /tmp/datacube-dataset-config.zip \
    && unzip -q /tmp/datacube-dataset-config.zip -d /tmp \
    && cp -r /tmp/datacube-dataset-config-main/odc-product-delete /code/odc-product-delete \
    && rm -r /tmp/datacube-dataset-config-main /tmp/datacube-dataset-config.zip

# Allow non-root user to read/write the python env and code dir
RUN chown -R odc:odc /env /code

## Do some symlinking
RUN ln -s /code/bootstrap-odc.sh /usr/local/bin/bootstrap-odc.sh

WORKDIR /home/odc
USER odc

RUN s3-to-dc --help
