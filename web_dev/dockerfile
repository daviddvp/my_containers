# ==============================================================
# IMAGEN BASE: Alpine Linux 3.21
# ==============================================================
# Alpine es la elección óptima para contenedores:
#   - Imagen base ~5MB (vs ~80MB de Ubuntu/Debian slim)
#   - Superficie de ataque mínima (menos CVEs)
#   - Arranque rápido, consumo de memoria mínimo
#   - Paquetero apk con índices comprimidos
# ==============================================================

FROM alpine:3.21

# ==============================================================
# METADATOS
# ==============================================================
LABEL maintainer="Dev"
LABEL description="Entorno de desarrollo web full-stack con Podman"
LABEL version="1.0"

# ==============================================================
# VARIABLES DE ENTORNO
# ==============================================================
ENV NODE_ENV=development
ENV PORT=8080
ENV MONGO_URI=mongodb://localhost:27017
ENV PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# ==============================================================
# DEPENDENCIAS DEL SISTEMA (una sola capa para minimizar tamaño)
# ==============================================================
# Paquetes necesarios:
#   - nodejs / npm          → Runtime JS + gestor de paquetes
#   - python3 / py3-pip     → Scripting auxiliar y herramientas
#   - mongodb               → Base de datos NoSQL
#   - git                   → Control de versiones
#   - curl / wget           → Transferencias HTTP
#   - openssh               → Conectividad remota (opcional)
#   - vim / nano            → Editores en terminal
#   - bash                  → Shell más completa que ash
#   - make                  → Build automation
#   - gcc / g++ / make      → Compilación de nativos de Node (node-gyp)
#   - python3-dev           → Headers para compilar módulos nativos
# ==============================================================
RUN apk add --no-cache \
    nodejs \
    npm \
    python3 \
    py3-pip \
    mongodb \
    mongodb-dev \
    git \
    curl \
    wget \
    openssh \
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
# INSTALACIÓN DE HERRAMIENTAS GLOBALES DE NODE
# ==============================================================
# - TypeScript (tsc)     → Compilador TS
# - ts-node              → Ejecutar .ts directamente en Node
# - Astro                → Framework de webs estáticas/SSR
# - React                → Biblioteca de interfaz
# - Vue CLI              → Framework alternativo (opcional)
# - Next.js              → Framework React full-stack (opcional)
# - nodemon              → Reinicio automático en desarrollo
# - eslint               → Linter JS/TS
# - prettier             → Formateo de código
# ==============================================================
RUN npm install -g \
    typescript \
    ts-node \
    create-astro \
    react \
    react-dom \
    @types/react \
    @types/node \
    nodemon \
    eslint \
    prettier \
    --prefer-offline \
    && npm cache clean --force

# ==============================================================
# PYTHON: Herramientas auxiliares
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
# USUARIO NO ROOT (seguridad en contenedores)
# ==============================================================
RUN addgroup -S devgroup \
    && adduser -S devuser -G devgroup -s /bin/bash

# ==============================================================
# DIRECTORIO DE TRABAJO
# ==============================================================
WORKDIR /app
RUN chown -R devuser:devgroup /app

# ==============================================================
# CONFIGURACIÓN DE MONGODB
# ==============================================================
# Crear directorios necesarios para MongoDB
RUN mkdir -p /data/db /data/log \
    && chown -R devuser:devgroup /data

# ==============================================================
# SCRIPT DE INICIO
# Inicia MongoDB en segundo plano y luego el servidor principal
# ==============================================================
COPY --chown=devuser:devgroup entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# ==============================================================
# USUARIO ACTIVO
# ==============================================================
USER devuser

# ==============================================================
# PUERTO EXPUESTO
# ==============================================================
EXPOSE 8080

# ==============================================================
# ENTRYPOINT
# ==============================================================
ENTRYPOINT ["/app/entrypoint.sh"]
