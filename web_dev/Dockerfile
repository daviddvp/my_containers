# ==============================================================
# IMAGEN BASE: Alpine Linux 3.21
# ==============================================================
# Alpine es la elección óptima para contenedores:
#   - Imagen base ~5MB (vs ~80MB de Ubuntu/Debian slim)
#   - Superficie de ataque mínima (menos CVEs)
#   - Arranque rápido, consumo de memoria mínimo
# ==============================================================

FROM alpine:3.21

# ==============================================================
# METADATOS
# ==============================================================
LABEL maintainer="Dev"
LABEL description="Entorno de desarrollo web full-stack"
LABEL version="2.0"

# ==============================================================
# VARIABLES DE ENTORNO
# ==============================================================
ENV NODE_ENV=development
ENV PORT=8080
# MongoDB corre en su propio contenedor (servicio "mongo" del compose)
ENV MONGO_HOST=mongo
ENV MONGO_PORT=27017
ENV MONGO_URI=mongodb://mongo:27017

# ==============================================================
# DEPENDENCIAS DEL SISTEMA
# ==============================================================
# mongodb / mongodb-dev NO van aquí: MongoDB corre en un
# contenedor separado definido en podman-compose.yml
# ==============================================================
RUN apk add --no-cache \
      nodejs \
      npm \
      python3 \
      py3-pip \
      git \
      curl \
      wget \
      vim \
      nano \
      bash \
      make \
      gcc \
      g++ \
      python3-dev \
      libffi-dev \
      openssl-dev \
    && rm -rf /var/cache/apk/*

# ==============================================================
# HERRAMIENTAS GLOBALES DE NODE
# ==============================================================
RUN npm install -g \
      typescript \
      ts-node \
      react \
      react-dom \
      @types/react \
      @types/node \
      nodemon \
      eslint \
      prettier \
    && npm cache clean --force

# ==============================================================
# PYTHON: frameworks y utilidades
# ==============================================================
RUN pip3 install --break-system-packages --no-cache-dir \
      flask \
      fastapi \
      uvicorn \
      pymongo \
      httpx \
      black \
      pylint

# ==============================================================
# USUARIO NO ROOT
# ==============================================================
RUN addgroup -S devgroup \
 && adduser  -S devuser -G devgroup -s /bin/bash

# ==============================================================
# DIRECTORIO DE TRABAJO
# ==============================================================
WORKDIR /app
RUN chown devuser:devgroup /app

# ==============================================================
# ENTRYPOINT
# ==============================================================
COPY --chown=devuser:devgroup entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER devuser

EXPOSE 8080

ENTRYPOINT ["/app/entrypoint.sh"]
