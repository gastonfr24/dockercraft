#!/bin/bash
################################################################################
# DockerCraft - Optimization Recommendations Script
#
# Description:
#   Analyzes server configuration and provides optimization recommendations.
#
# Usage:
#   ./scripts/optimize-recommendations.sh [CONTAINER_NAME]
#
################################################################################

set -eo pipefail

CONTAINER="${1:-minecraft-server}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  DockerCraft - Optimization Recommendations"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if container exists
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
    echo "Container '$CONTAINER' not found"
    exit 1
fi

echo "Analyzing server configuration..."
echo ""

# Recommendation 1: Memory
echo "📊 Memory Configuration:"
MEM=$(docker inspect "$CONTAINER" --format '{{.HostConfig.Memory}}' 2>/dev/null || echo "0")
if [ "$MEM" = "0" ]; then
    echo "  ⚠️  No memory limit set - recommend setting memory limit"
    echo "     Example: MEMORY=4G in .env"
else
    echo "  ✓ Memory limit configured"
fi
echo ""

# Recommendation 2: CPU
echo "💻 CPU Configuration:"
CPU=$(docker inspect "$CONTAINER" --format '{{.HostConfig.NanoCpus}}' 2>/dev/null || echo "0")
if [ "$CPU" = "0" ]; then
    echo "  💡 Consider setting CPU limits for better resource management"
    echo "     Add to docker-compose.yml:"
    echo "     deploy:"
    echo "       resources:"
    echo "         limits:"
    echo "           cpus: '4'"
fi
echo ""

# Recommendation 3: View Distance
echo "🌍 View Distance:"
echo "  💡 Reducing view distance improves performance:"
echo "     - view-distance=6  (40% less RAM, best performance)"
echo "     - view-distance=8  (25% less RAM, good balance)"
echo "     - view-distance=10 (default, more RAM usage)"
echo ""

# Recommendation 4: Server Type
echo "⚙️  Server Type:"
echo "  💡 Using Paper server provides best performance"
echo "     Set TYPE=PAPER in .env"
echo ""

# Recommendation 5: Auto-pause
echo "⏸️  Auto-pause:"
echo "  💡 Enable auto-pause to save resources when no players online"
echo "     Set ENABLE_AUTOPAUSE=TRUE in .env"
echo ""

# Recommendation 6: JVM Flags
echo "🚀 JVM Optimization:"
echo "  ✓ Aikar's flags recommended (enabled by default)"
echo "     Set USE_AIKAR_FLAGS=TRUE in .env"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Recommendations Complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For detailed optimization guide, see: docs/PERFORMANCE.md"

exit 0

