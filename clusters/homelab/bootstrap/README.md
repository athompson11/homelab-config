# Bootstrap homelab-config

1. Push this repo to a remote git URL.
2. Replace the placeholder repo URL in the Application manifests:

   ```text
   https://github.com/REPLACE_ME/homelab-config.git
   ```

3. Apply the root app:

   ```fish
   kubectl apply -f clusters/homelab/bootstrap/root-application.yaml
   ```

4. In Argo CD, sync `homelab-config`, then sync the two observability child apps.

Automated sync is intentionally off for first adoption of the manually bootstrapped observability stack.
