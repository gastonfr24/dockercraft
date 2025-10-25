#!/bin/bash
# Script para obtener la IP pública del servidor

echo "🌐 Obteniendo IP pública..."
echo ""

# Intentar múltiples servicios
PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || \
            curl -s ipinfo.io/ip 2>/dev/null || \
            curl -s icanhazip.com 2>/dev/null || \
            echo "No se pudo obtener")

if [ "$PUBLIC_IP" != "No se pudo obtener" ]; then
    echo "✅ Tu IP pública es: $PUBLIC_IP"
    echo ""
    echo "Conectar desde Minecraft:"
    echo "  $PUBLIC_IP:25565"
else
    echo "❌ No se pudo obtener la IP pública"
    echo "Verifica tu conexión a internet"
fi

