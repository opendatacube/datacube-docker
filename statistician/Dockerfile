ARG py_env_path=/env
ARG V_BASE=3.3.0

FROM opendatacube/geobase-builder:${V_BASE} as env_builder
ENV LC_ALL=C.UTF-8

# Install our Python requirements
COPY requirements.txt constraints.txt nobinary.txt version.txt /conf/
ARG py_env_path
RUN cat /conf/version.txt \
  && NOBINARY=/conf/nobinary.txt env-build-tool new /conf/requirements.txt /conf/constraints.txt ${py_env_path} \
  && rm -rf /root/.cache/pip \
  && echo done

# Below is the actual image that does the running
FROM opendatacube/geobase-runner:${V_BASE}

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

# Add in the dask configuration
COPY distributed.yaml /etc/dask/distributed.yaml

RUN apt-get update \
    && apt-get install -y \
         libtiff-tools \
         git \
         htop \
         tmux \
         wget \
         curl \
         nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

ARG py_env_path
COPY --from=env_builder $py_env_path $py_env_path
ENV PATH="${py_env_path}/bin:${PATH}"

RUN env && echo $PATH && pip freeze && pip check
RUN odc-stats --help
