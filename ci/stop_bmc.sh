#!/usr/bin/env bash
pkill -f qemu-system-arm 2>/dev/null && echo "QEMU остановлен" || echo "QEMU не запущен"
