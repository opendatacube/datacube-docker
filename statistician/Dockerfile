FROM osgeo/gdal:ubuntu-small-3.4.2

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
    # Developer convenience
    git \
    wget \
    unzip \
    htop \
    tmux \
    vim \
    # Yaml parsing speedup, I think
    libyaml-dev \
    lsb-release \
    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -vrf /var/lib/apt/lists/* \
    && rm -vrf /var/lib/{apt,dpkg,cache,log}

# Setup PostgreSQL APT repository and install postgresql-client-13
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update \
    && apt-get install -y postgresql-client-13 \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# Add in the dask configuration
COPY distributed.yaml /etc/dask/distributed.yaml

COPY setup_reqs.txt requirements.txt constraints.txt version.txt /conf/

RUN cat /conf/version.txt \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r /conf/setup_reqs.txt\
  && pip install --no-cache-dir \
    -r /conf/requirements.txt \
    -c /conf/constraints.txt

RUN pip freeze

WORKDIR /tmp

RUN odc-stats --version
