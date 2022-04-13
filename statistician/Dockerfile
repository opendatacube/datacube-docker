FROM osgeo/gdal:ubuntu-small-3.3.2

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y \
    # Build tools\
    build-essential \
    python3-pip \
    python3-dev \
    # For Psycopg2
    libpq-dev\
    postgresql-client-13 \
    # Developer convenience
    git \
    wget \
    unzip \
    htop \
    tmux \
    vim \
    # Yaml parsing speedup, I think
    libyaml-dev \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -vrf /var/lib/apt/lists/* \
    && rm -vrf /var/lib/{apt,dpkg,cache,log}

# Add in the dask configuration
COPY distributed.yaml /etc/dask/distributed.yaml

COPY requirements.txt constraints.txt version.txt /conf/

RUN cat /conf/version.txt \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir \
    -r /conf/requirements.txt \
    -c /conf/constraints.txt

RUN pip freeze

WORKDIR /tmp

RUN odc-stats --version
