# 🦀 Entorno de Desarrollo Rust — Podman

## 📂 Estructura

```
rust-dev/
├── podman-compose.yml    → Orquestación del contenedor
├── Dockerfile            → Imagen basada en Debian Bookworm Slim
├── src/                  → Tu código Rust (se monta en /app/src)
└── README.md
```

Crea la carpeta `src/` antes de levantar:

```bash
mkdir -p src
```

---

## ⚡ Comandos principales

| Acción | Comando |
|--------|---------|
| Construir + levantar | `podman-compose up --build` |
| Levantar (sin rebuild) | `podman-compose up` |
| Entrar al contenedor | `podman-compose exec rustdev bash` |
| Detener | `podman-compose down` |
| Borrar + cache de compilación | `podman-compose down -v` |

---

## 🛠️ Flujo de trabajo típico

### 1. Crear un proyecto nuevo desde dentro del contenedor

```bash
podman-compose exec rustdev bash
cd /app/src
cargo new mi-proyecto
cd mi-proyecto
```

### 2. Compilar y testear

```bash
cargo build          # compilar (debug)
cargo build --release # compilar optimizado
cargo test           # ejecutar tests
cargo run            # compilar + ejecutar
```

### 3. Linting y formateo

```bash
cargo fmt            # formatear código
cargo clippy         # linter con sugerencias
```

---

## 📦 Qué hay instalado

| Herramienta | Uso |
|-------------|-----|
| `rustc` (stable) | Compilador |
| `cargo` | Gestor de paquetes y build |
| `rustfmt` | Formateo automático |
| `clippy` | Linter inteligente |
| `rust-src` | Fuente de la librería estándar (para rust-analyzer) |
| `gcc` / `make` | Compilar crates con dependencias C |
| `libsqlite3-dev` | Soporte nativo para `rusqlite` |
| `libssl-dev` | Soporte nativo para `openssl` / `reqwest` |
| `zlib1g-dev` | Soporte nativo para `flate2` |
| `git` | Control de versiones |

---

## 🔧 Troubleshooting

| Problema | Solución |
|----------|----------|
| La primera compilación es lenta | Es normal: Rust compila todas las dependencias desde cero. Las siguientes son rápidas gracias al cache en `rust_target_cache`. |
| `error: could not compile` con crate nativo | Probablemente falta una librería `-dev` del sistema. Entra al contenedor y hazlo: `sudo apt-get install -y <paquete>-dev` |
| Quiero usar un puerto para un servidor | Descomenta `ports` en el compose y ajusta según tu proyecto. |
| Los cambios en `src/` no se ven | El volumen `./src:/app/src` es en tiempo real. Si compilas fuera del contenedor los cambios no aplican: compila siempre desde dentro. |
| Quiero el toolchain `nightly` | Dentro del contenedor: `rustup toolchain install nightly` y luego `rustup default nightly` |
