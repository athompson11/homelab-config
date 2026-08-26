#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
HELM_BIN="${HELM:-helm}"
"$HELM_BIN" dependency build apps/observability/metrics-server >/dev/null
"$HELM_BIN" dependency build apps/observability/kube-prometheus-stack >/dev/null
"$HELM_BIN" template metrics-server apps/observability/metrics-server --namespace observability
"$HELM_BIN" template observability apps/observability/kube-prometheus-stack --namespace observability --include-crds
