FROM mambaorg/micromamba:git-7545124-jammy as stats-conda

USER root
COPY env.yaml /conf/
RUN micromamba create  -y -p /env -f /conf/env.yaml && \
    micromamba clean --all --yes && \
    micromamba env export -p /env --explicit


ARG MAMBA_DOCKERFILE_ACTIVATE=1
COPY requirements.txt /conf/
RUN micromamba run -p /env pip install --no-cache-dir \
    --no-build-isolation -r /conf/requirements.txt

FROM ubuntu:jammy-20220815
COPY --from=stats-conda /env /env
COPY distributed.yaml  /etc/dask/

ENV GDAL_DRIVER_PATH=/env/lib/gdalplugins \ 
    PROJ_LIB=/env/share/proj \
    GDAL_DATA=/env/share/gdal \
    PATH=/env/bin:$PATH

WORKDIR /tmp

RUN odc-stats --version 

