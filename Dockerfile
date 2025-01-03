# Use the PostGIS image as the base
FROM postgis/postgis:15-3.4

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
       clang-13 \
       llvm-13 \
       llvm-13-dev \
       llvm-13-linker-tools \
       llvm-13-runtime \
       llvm-13-tools \
       postgresql-server-dev-15 \
    # Clean up to reduce layer size
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch v0.5.1 https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    # Clean up unnecessary files
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-15 libpq-dev wget git \
    && rm -rf /tmp/pgvector

# Copy initialization scripts
COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
