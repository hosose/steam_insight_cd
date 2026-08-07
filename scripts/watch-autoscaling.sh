#!/usr/bin/env bash
# macOS/Linux에서 HPA, Pod, Node 상태를 2초 간격으로 함께 표시한다.
set -euo pipefail

while true; do
  clear
  echo "========== HPA =========="
  kubectl get hpa -n steam-insight || true
  echo
  echo "========== POD =========="
  kubectl get pods -n steam-insight -o wide || true
  echo
  echo "========== POD METRICS =========="
  kubectl top pods -n steam-insight || true
  echo
  echo "========== NODE =========="
  kubectl get nodes || true
  sleep 2
done
