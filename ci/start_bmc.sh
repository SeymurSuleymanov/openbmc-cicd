#!/usr/bin/env bash
# Запуск OpenBMC (romulus) в QEMU в фоне
IMAGE="${OPENBMC_IMAGE:-$HOME/openbmc_lab/openbmc-romulus.mtd}"
bash "$(dirname "$0")/stop_bmc.sh" >/dev/null 2>&1
setsid nohup qemu-system-arm -m 1024 -M romulus-bmc -nographic \
  -drive file="$IMAGE",format=raw,if=mtd -net nic \
  -net user,hostfwd=:127.0.0.1:2222-:22,hostfwd=:127.0.0.1:2443-:443,hostfwd=udp:127.0.0.1:2623-:623,hostname=qemu \
  > "$HOME/qemu_pipeline.log" 2>&1 < /dev/null &
echo "QEMU запущен, pid=$!"
