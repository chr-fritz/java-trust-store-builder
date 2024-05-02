# java-trust-store-builder Docker Image

This is a very small docker image that can be used in kubernetes deployments as init container to build a customized
java trust store.
It reads all files with the extensions `.crt`, `*.cer`, or `*.pem` and imports them into the java trust store.

Source directory and target truststore can be customized by environment variables:

| Environment Variable | Description                                                   | Default Value                |
|----------------------|---------------------------------------------------------------|------------------------------|
| `SOURCE_DIR`         | The directory from which to read the additional certificates. | `/ca-certs`                  |
| `TARGET`             | The path where the truststore should be stored.               | `/truststore/truststore.jks` |

## How to use it in Kubernetes

The following snippet shows how to configure it as init container and inject the kubernetes-root certificate into the
trust store.

```yaml
spec:
  initContainers:
    - name: truststore-creator
      image: ghcr.io/chr-fritz/java-trust-store-builder:latest
      imagePullPolicy: Always
      # Only necessary if you don't want to use the default values 
      # env:
      #   - name: SOURCE_DIR
      #     value: /ca-certs
      #   - name: TARGET
      #     value: /truststore/truststore.jks
      volumeMounts:
        - name: truststore
          mountPath: /truststore
          readOnly: false
        - name: ca-certificates
          mountPath: /ca-certs
          readOnly: true
  # [...]
  volumes:
    - name: truststore
      emptyDir: { }
    - name: ca-certificates
      projected:
        sources:
          - configMap:
              name: kube-root-ca.crt
              items:
                - key: ca.crt
                  path: k8s-ca.crt
```

## License

The java-trust-store-builder Docker Image is released under the Apache 2.0 license. See [LICENSE](LICENSE)