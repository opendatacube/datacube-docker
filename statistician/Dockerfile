FROM opendatacube/geobase:wheels as env_builder

ARG py_env_path=/env

ENV LC_ALL=C.UTF-8

# Install our Python requirements
RUN mkdir -p /conf
COPY requirements.txt /conf/
RUN env-build-tool new /conf/requirements.txt ${py_env_path} /wheels

FROM opendatacube/geobase:runner

ENV DEBIAN_FRONTEND=noninteractive

COPY --from=env_builder /env /env

ADD requirements-apt-run.txt /tmp/
RUN apt-get update \
    && sed 's/#.*//' /tmp/requirements-apt-run.txt | xargs apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/env/bin:${PATH}"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
