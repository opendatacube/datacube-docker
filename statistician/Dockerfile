FROM opendatacube/geobase:wheels as env_builder

ARG py_env_path=/env

ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install our requirements
RUN mkdir -p /conf
COPY requirements.txt /conf/
RUN env-build-tool new /conf/requirements.txt ${py_env_path} /wheels

FROM opendatacube/geobase:runner
COPY --from=env_builder /env /env
RUN apt-get update \
    && apt-get install -y \
    libtiff-tools \
    python-pip \
    && pip install --upgrade awscli \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/env/bin:${PATH}"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
