@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul

kubectl delete application steam-insight ^
  -n argocd ^
  --ignore-not-found ^
  --wait=true ^
  --timeout=15m
if errorlevel 1 exit /b 1

kubectl delete appproject steam-insight -n argocd --ignore-not-found
if errorlevel 1 exit /b 1

kubectl delete namespace argocd ^
  --ignore-not-found ^
  --wait=true ^
  --timeout=15m
if errorlevel 1 exit /b 1

echo [OK] Argo CD와 GitOps 애플리케이션 리소스를 제거했습니다.
echo [INFO] AWS 인프라는 steam_insight_ci의 Terraform destroy로 별도 제거하세요.
exit /b 0
