# youareanidiot.abbie.dev

Static site from reviewed source commit `d0a3b49964aefa023e87b1d7f632551364251273`. The four files in `site/` are extracted directly from that commit; hashes are in `asset-sha256.json`.

One unprivileged Alpine Nginx replica serves an immutable ConfigMap on port 8080. Reuses the existing default namespace, Traefik ingress class, Cloudflare wildcard forwarding and ready `letsencrypt-production-abbie-cloudflare` ClusterIssuer. No PVC, database, runtime downloads, SSH publishing, new DNS forwarding, or changes to shared controllers. The site-specific Certificate preserves verified origin HTTPS using the established issuer. Nginx image digest is the digest already running for the existing static site.

Owner authorization: BIT-37 comment `fb7aebcf-44b0-46e8-9279-edaf0aec93f5` directs this Kubernetes workload; answer `e8dc08f0-c6c8-459a-b745-a5a6fd5d3e05` confirms existing `*.abbie.dev` forwarding. This replaces the legacy SSH route. Independent focused security approval remains required before applying.

Deploy after focused review:

```sh
kubectl apply -f apps/youareanidiot/workload.yaml
kubectl -n default rollout status deployment/youareanidiot --timeout=120s
kubectl -n default wait certificate/youareanidiot --for=condition=Ready --timeout=180s
curl --fail https://youareanidiot.abbie.dev/
```

Initial-release rollback, without deleting resources or data:

```sh
kubectl -n default patch ingress youareanidiot --type=merge -p '{"spec":{"ingressClassName":"disabled"}}'
kubectl -n default scale deployment/youareanidiot --replicas=0
curl -sS -o /dev/null -w '%{http_code}\n' https://youareanidiot.abbie.dev/
```

Expected baseline is HTTP 404. Verify the dedicated router disappears and no other hostname changes. Recovery: reapply the same reviewed workload.yaml and repeat rollout, certificate, HTTPS and asset checks. Future content updates retain the previous immutable ConfigMap and Deployment revision; restore the previous workload.yaml commit or use `kubectl rollout undo deployment/youareanidiot -n default`, then verify file hashes. This site has no persistent user data; deployment rollback does not restore unrelated services or data. No deletion/pruning is included.

The repository workload.yaml is rendered from the local Kustomize candidate using `kubectl kustomize`; it contains the exact ConfigMap contents, including base64 audio. It is the declarative source of truth for this manually applied workload. No Argo CD application or shared sync configuration is added.
