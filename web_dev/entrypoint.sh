#!/bin/bash
# ==============================================================
# ENTRYPOINT — Entorno de desarrollo web full-stack
# ==============================================================
# Este script:
#   1. Inicia MongoDB en segundo plano
#   2. Verifica que MongoDB esté listo
#   3. Muestra un banner informativo
#   4. Ejecuta el comando pasado al contenedor (o abre bash)
# ==============================================================

set -e

# ─── COLORES ─────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ─── FUNCIÓN: Iniciar MongoDB ────────────────────────────────
start_mongo() {
    echo -e "${YELLOW}[*] Iniciando MongoDB...${NC}"
    mongod --dbpath /data/db --logpath /data/log/mongod.log --fork --bind_ip 127.0.0.1 --port 27017 2>/dev/null || true

    # Esperar a que MongoDB esté disponible (max 10 intentos)
    for i in $(seq 1 10); do
        if mongosh --eval "db.adminCommand({ping:1})" --quiet 2>/dev/null; then
            echo -e "${GREEN}[✓] MongoDB listo en mongodb://localhost:27017${NC}"
            return 0
        fi
        echo -e "${YELLOW}[*] Esperando a MongoDB... (intento $i/10)${NC}"
        sleep 1
    done

    echo -e "${RED}[✗] MongoDB no respondió a tiempo. Revisa los logs en /data/log/mongod.log${NC}"
    return 1
}

# ─── FUNCIÓN: Banner informativo ─────────────────────────────
show_banner() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       ENTORNO DE DESARROLLO WEB FULL-STACK (Podman)     ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║  Runtime & Herramientas                                  ║${NC}"
    echo -e "${CYAN}║    • Node.js $(node --version | tr -d '\n' | sed 's/^/    /')                                        ║${NC}"
    echo -e "${CYAN}║    • npm     $(npm --version | tr -d '\n' | sed 's/^/    /')                                        ║${NC}"
    echo -e "${CYAN}║    • TypeScript (tsc --version)                          ║${NC}"
    echo -e "${CYAN}║    • Python  $(python3 --version | tr -d '\n' | sed 's/^/    /')                              ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║  Front-End                                               ║${NC}"
    echo -e "${CYAN}║    • React + TypeScript                                  ║${NC}"
    echo -e "${CYAN}║    • Astro (create-astro)                                ║${NC}"
    echo -e "${CYAN}║    • ESLint + Prettier                                   ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║  Back-End                                               ║${NC}"
    echo -e "${CYAN}║    • Express / Fastify (npm install al crear proyecto)   ║${NC}"
    echo -e "${CYAN}║    • Python: Flask / FastAPI + Uvicorn                   ║${NC}"
    echo -e "${CYAN}║    • MongoDB (activo en localhost:27017)                 ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║  Puertos                                                 ║${NC}"
    echo -e "${CYAN}║    • Contenedor 8080 → Máquina host 8081                ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║  Comandos útiles                                         ║${NC}"
    echo -e "${CYAN}║    npx create-astro@latest myapp                         ║${NC}"
    echo -e "${CYAN}║    npx create-react-app myapp --template typescript      ║${NC}"
    echo -e "${CYAN}║    mongosh                  → Shell de MongoDB           ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ─── MAIN ────────────────────────────────────────────────────
start_mongo
show_banner

# Si se pasó un comando al contenedor, ejecutarlo
# Si no, abrir una shell interactiva
if [ $# -gt 0 ]; then
    exec "$@"
else
    exec bash
fi
