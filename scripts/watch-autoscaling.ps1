# Windows PowerShell에서 HPA, Pod, Node 상태를 2초 간격으로 함께 표시한다.
$ErrorActionPreference = "Continue"

while ($true) {
    Clear-Host

    Write-Host "========== HPA =========="
    kubectl get hpa -n steam-insight

    Write-Host "`n========== POD =========="
    kubectl get pods -n steam-insight -o wide

    Write-Host "`n========== POD METRICS =========="
    kubectl top pods -n steam-insight

    Write-Host "`n========== NODE =========="
    kubectl get nodes

    Start-Sleep -Seconds 2
}
