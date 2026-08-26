# homelab-config

Argo CD GitOps config for the homelab Talos Kubernetes cluster.

This repo currently defines the internal-only observability baseline:

- metrics-server `3.14.0`
- kube-prometheus-stack `88.5.4`
  - Prometheus Operator / CRDs
  - Prometheus
  - Grafana
  - Alertmanager
  - node-exporter
  - kube-state-metrics

The live cluster was bootstrapped manually first. These manifests are the desired GitOps handoff shape for Argo CD.

## Layout

```text
apps/
  observability/
    metrics-server/             # Helm wrapper chart + values
    kube-prometheus-stack/      # Helm wrapper chart + values
clusters/
  homelab/
    apps/                       # Argo CD AppProject, namespace, Applications
    bootstrap/                  # root app template/instructions
```

## Bootstrap

Argo CD `Application` manifests need the final git remote URL. After this repo is pushed, replace:

```text
https://github.com/REPLACE_ME/homelab-config.git
```

with the actual remote URL in:

- `clusters/homelab/bootstrap/root-application.yaml`
- `clusters/homelab/apps/observability-metrics-server.yaml`
- `clusters/homelab/apps/observability-kube-prometheus-stack.yaml`

Then apply the root application:

```fish
kubectl apply -f clusters/homelab/bootstrap/root-application.yaml
```

Initial sync policy is conservative: automated sync is not enabled. Sync from the Argo CD UI/CLI once the repo URL and access are correct.

## Access

Grafana stays internal-only:

```fish
kubectl -n observability port-forward svc/observability-grafana 3000:80
```

Prometheus stays internal-only:

```fish
kubectl -n observability port-forward svc/observability-kube-prometh-prometheus 9090:9090
```
