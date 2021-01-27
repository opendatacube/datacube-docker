ARG py_env_path=/env

FROM opendatacube/geobase:builder-3.0.4 as env_builder
ARG py_env_path

ENV LC_ALL=C.UTF-8

# Install our Python requirements
RUN mkdir -p /conf
COPY requirements.txt constraints.txt version.txt /conf/
RUN cat /conf/version.txt \
  && python3 -m venv ${py_env_path} \
  && ${py_env_path}/bin/python -m pip install -U pip wheel setuptools -c /conf/constraints.txt \
  && ${py_env_path}/bin/python -m pip install -r /conf/requirements.txt -c /conf/constraints.txt \
  && rm -rf /root/.cache/pip \
  && echo done

# Below is the actual image that does the running
FROM opendatacube/geobase:runner-3.0.4
ARG py_env_path

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="${py_env_path}/bin:${PATH}" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

# Add in the dask configuration
COPY distributed.yaml /etc/dask/distributed.yaml

ADD apt-run.txt /tmp/
RUN apt-get update \
    && sed 's/#.*//' /tmp/apt-run.txt | xargs apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

COPY --from=env_builder $py_env_path $py_env_path

RUN env && echo $PATH && pip freeze && pip check
RUN odc-stats --help
