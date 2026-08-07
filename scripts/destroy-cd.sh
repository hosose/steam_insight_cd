#!/usr/bin/env bash
set -Eeuo pipefail

kubectl delete application steam-insight \
  -n argocd \
  --ignore-not-found \
  --wait=true \
  --timeout=15m

kubectl delete appproject steam-insight \
  -n argocd \
  --ignore-not-found

kubectl delete namespace argocd \
  --ignore-not-found \
  --wait=true \
  --timeout=15m

echo "[OK] Argo CD와 GitOps 애플리케이션 리소스를 제거했습니다."
echo "[INFO] AWS 인프라는 steam_insight_ci의 Terraform destroy로 별도 제거하세요."
