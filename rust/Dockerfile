# ==============================================================
# IMAGEN BASE: Debian 12 Bookworm Slim
# ==============================================================
# Por qué no Alpine:
#   Alpine usa musl libc. Una gran parte del ecosistema de crates
#   de Rust asume glibc, y muchos binarios precompilados no existen
#   para musl. Esto fuerza compilaciones desde fuente que fallan
#   o requieren parches manuales.
#
# Debian Slim (~30MB) da glibc, es estable y tiene todo el
# ecosistema de herramientas de compilación disponible.
# ==============================================================

FROM debian:bookworm-slim

# ==============================================================
# METADATOS
# ==============================================================
LABEL maintainer="Dev"
LABEL description="Entorno de desarrollo Rust con Podman"
LABEL version="1.0"

# ==============================================================
# VARIABLES DE ENTORNO
# ==============================================================
ENV CARGO_HOME=/usr/local/cargo
ENV RUSTUP_HOME=/usr/local/rustup
ENV PATH="${CARGO_HOME}/bin:${RUSTUP_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# ==============================================================
# DEPENDENCIAS DEL SISTEMA
# ==============================================================
# - curl               → descargar rustup
# - ca-certificates    → TLS para curl
# - build-essential    → gcc, make, libc-dev (necesarios para
#                         compilar crates con dependencias C como
#                         openssl, libsqlite3, zlib…)
# - pkg-config         → detectar bibliotecas del sistema
# - git                → control de versiones y crates desde git
# - vim / nano         → editores en terminal
# - libsqlite3-dev     → crate rusqlite (muy común)
# - libssl-dev         → crate openssl / reqwest con feature ssl
# - zlib1g-dev         → crate flate2 con feature zlib
# ==============================================================
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      build-essential \
      pkg-config \
      git \
      vim \
      nano \
      bash \
      libsqlite3-dev \
      libssl-dev \
      zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# ==============================================================
# RUSTUP + TOOLCHAIN STABLE
# ==============================================================
# Componentes instalados:
#   - rustc          → compilador
#   - cargo          → gestor de paquetes y build
#   - rustfmt        → formateo de código
#   - clippy         → linter (warnings inteligentes)
#   - rust-src       → fuente de la librería estándar (para rust-analyzer)
# ==============================================================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y \
         --default-toolchain stable \
         --component rustfmt clippy rust-src \
 && rm -rf /tmp/rustup*

# ==============================================================
# USUARIO NO ROOT
# ==============================================================
RUN groupadd -r devgroup \
 && useradd  -r -g devgroup -s /bin/bash -m devuser \
 && chown -R devuser:devgroup ${CARGO_HOME} ${RUSTUP_HOME}

# ==============================================================
# DIRECTORIO DE TRABAJO
# ==============================================================
WORKDIR /app
RUN chown devuser:devgroup /app

USER devuser

# ==============================================================
# VERIFICACIÓN EN BUILD TIME
# ==============================================================
RUN rustc --version && cargo --version && rustfmt --version && cargo clippy --version

# ==============================================================
# SHELL POR DEFECTO
# ==============================================================
CMD ["bash"]
