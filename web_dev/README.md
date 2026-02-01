# 🚀 Entorno de Desarrollo Web Full-Stack — Podman

## 📂 Estructura de archivos

```
proyecto/
├── Dockerfile          → Imagen basada en Alpine Linux 3.21
├── entrypoint.sh       → Script de inicio (MongoDB + shell)
└── README.md           → Este archivo
```

---

## ⚡ Construcción de la imagen

Coloca los archivos en una carpeta y ejecuta:

```bash
podman build -t webdev .
```

---

## 🏃 Ejecución del contenedor

### Modo interactivo (shell bash)

```bash
podman run -it \
  -p 8081:8080 \
  -v $(pwd)/src:/app/src \
  --name webdev \
  webdev
```

### Modo detached (segundo plano)

```bash
podman run -d \
  -p 8081:8080 \
  -v $(pwd)/src:/app/src \
  --name webdev \
  webdev sleep infinity

# Entrar al contenedor después
podman exec -it webdev bash
```

### Desglose de los flags

| Flag | Explicación |
|------|-------------|
| `-p 8081:8080` | Puerto 8081 de tu máquina → puerto 8080 del contenedor |
| `-v $(pwd)/src:/app/src` | Monta tu carpeta `src/` local dentro del contenedor |
| `--name webdev` | Nombre para referencia fácil |
| `-it` | Terminal interactiva con TTY |

---

## 📦 Tecnologías incluidas

### Runtime & Core
- **Node.js** — Runtime de JavaScript
- **npm** — Gestor de paquetes
- **TypeScript** — Tipado estático para JS
- **ts-node** — Ejecutar TypeScript directamente
- **Python 3** — Lenguaje auxiliar de scripting

### Front-End
- **React + @types/react** — Biblioteca de UI
- **Astro** — Framework para webs estáticas y SSR (`create-astro`)
- **ESLint** — Linter
- **Prettier** — Formateo automático

### Back-End
- **MongoDB** — Base de datos NoSQL (se inicia automáticamente)
- **Flask / FastAPI** — Frameworks web de Python
- **Uvicorn** — Servidor ASGI para FastAPI
- **Nodemon** — Reinicio automático del servidor Node en desarrollo

### Herramientas
- **Git** — Control de versiones
- **Vim / Nano** — Editores en terminal
- **curl / wget** — Transferencias HTTP
- **GCC / G++** — Para compilar módulos nativos de Node (node-gyp)

---

## 🛠️ Proyectos de ejemplo

### Crear un proyecto Astro

```bash
cd /app
npx create-astro@latest mi-proyecto
cd mi-proyecto
npm run dev -- --host 0.0.0.0 --port 8080
```

### Crear un proyecto React con TypeScript

```bash
cd /app
npx create-react-app mi-react --template typescript
cd mi-react
# Editar package.json → scripts.start → agregar BROWSER=none HOST=0.0.0.0
npm start
```

### Crear un servidor Express + TypeScript

```bash
cd /app
mkdir mi-api && cd mi-api
npm init -y
npm install express typescript @types/node @types/express ts-node nodemon
# Crear tsconfig.json e index.ts, luego:
npx nodemon --exec ts-node index.ts
```

### Crear una API con FastAPI (Python)

```bash
cd /app
mkdir mi-api-python && cd mi-api-python
# Crear main.py con FastAPI
uvicorn main:app --host 0.0.0.0 --port 8080 --reload
```

### Conectar a MongoDB desde Node

```javascript
// npm install mongoose
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost:27017/mi_db');
```

### Conectar a MongoDB desde Python

```python
# pip install pymongo (ya instalado)
from pymongo import MongoClient
client = MongoClient('mongodb://localhost:27017')
db = client['mi_db']
```

---

## 🔧 Gestión del contenedor

```bash
# Iniciar contenedor parado
podman start webdev

# Detener contenedor
podman stop webdev

# Eliminar contenedor
podman rm webdev

# Eliminar imagen
podman rmi webdev

# Ver logs
podman logs webdev

# Ver recursos consumidos
podman stats webdev
```

---

## 📝 Notas importantes

- **MongoDB** se inicia automáticamente al arrancar el contenedor. Los datos se almacenan en `/data/db` dentro del contenedor. Si quieres persistencia, monta un volumen: `-v $(pwd)/mongodata:/data/db`.
- El contenedor corre con un **usuario no root** (`devuser`) por seguridad.
- La imagen está basada en **Alpine Linux 3.21**, la más ligera y segura para contenedores.
- Si necesitas instalar paquetes adicionales de npm o pip dentro del contenedor, puedes hacerlo normalmente desde la shell.
