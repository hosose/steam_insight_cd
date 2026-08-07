apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: steam-insight
  namespace: argocd
spec:
  description: Steam Insight EKS Auto Mode WEB/WAS project

  sourceRepos:
    - "__CD_REPO_URL__"

  destinations:
    - namespace: steam-insight
      server: https://kubernetes.default.svc

  clusterResourceWhitelist:
    - group: ""
      kind: Namespace
    - group: eks.amazonaws.com
      kind: IngressClassParams
    - group: networking.k8s.io
      kind: IngressClass

  namespaceResourceWhitelist:
    - group: "*"
      kind: "*"

  orphanedResources:
    warn: true
    ignore:
      - kind: Secret
        name: rds-secret
