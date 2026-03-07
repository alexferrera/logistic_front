
#!/bin/bash

# === Script para generar estructura hexagonal ===
# Uso: ./generate.sh academics

MODULE_NAME=$1

if [ -z "$MODULE_NAME" ]; then
    echo "❌ Error: debes pasar el nombre del módulo."
    echo "✅ Ejemplo: ./generate.sh academics"
    exit 1
fi

mkdir -p "./lib/features/$MODULE_NAME/bloc"
mkdir -p "./lib/features/$MODULE_NAME/data"
mkdir -p "./lib/features/$MODULE_NAME/data/datasources"
mkdir -p "./lib/features/$MODULE_NAME/data/models"
mkdir -p "./lib/features/$MODULE_NAME/data/repositories"
mkdir -p "./lib/features/$MODULE_NAME/view"
mkdir -p "./lib/features/$MODULE_NAME/widgets"


echo "✅ Estructura creada dentro de: $MODULE_NAME"