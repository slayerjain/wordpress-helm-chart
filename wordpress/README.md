# Wordpress

![Version: 0.9.1](https://img.shields.io/badge/Version-0.9.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.3.1-apache](https://img.shields.io/badge/AppVersion-6.3.1--apache-informational?style=flat-square)

## Changelog

see [RELEASENOTES.md](RELEASENOTES.md)

A Helm chart for Wordpress on Kubernetes

## Introduction

This chart uses the original [Wordpress from Docker](https://hub.docker.com/_/wordpress) to deploy Wordpress in Kubernetes.

It fully supports deployment of the multi-architecture docker image.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.x
- PV provisioner support in the underlying infrastructure


## Common parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | Fully override the deployment name |
| nameOverride | string | `""` | Partially override the deployment name |

## Deployment parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.registry | string | `"docker.io"` | Image registry |
| image.repository | string | `"wordpress"` | Image name |
| image.tag | string | `""` | Image tag |
| imagePullSecrets | list | `[]` | Image pull secrets |
| extraInitContainers | list | `[]` | Extra init containers |
| extaContainers | list | `[]` | Extra containers for usage as sidecars |
| strategy | object | `{}` | Pod deployment strategy |
| livenessProbe | object | `see values.yaml` | Liveness probe configuration |
| startupProbe | object | `see values.yaml` | Startup probe configuration |
| readinessProbe | object | `see values.yaml` | Readiness probe configuration |
| customLivenessProbe | object | `{}` | Custom liveness probe (overwrites default liveness probe configuration) |
| customStartupProbe | object | `{}` | Custom startup probe (overwrites default startup probe configuration) |
| customReadinessProbe | object | `{}` | Custom readiness probe (overwrites default readiness probe configuration) |
| resources | object | `{}` | Resource limits and requests |
| nodeSelector | object | `{}` | Deployment node selector |
| podAnnotations | object | `{}` | Additional pod annotations |
| podSecurityContext | object | `see values.yaml` | Pod security context |
| securityContext | object | `see values.yaml` | Container security context |
| env | list | `[]` | Additional container environmment variables |
| args | list | `[]` | Arguments for the container entrypoint process |
| serviceAccount.create | bool | `false` | Enable service account creation |
| serviceAccount.name | string | `""` | Optional name of the service account |
| serviceAccount.annotations | object | `{}` | Additional service account annotations |
| affinity | object | `{}` | Affinity for pod assignment |
| tolerations | list | `[]` | Tolerations for pod assignment |
| containerPort | int | `8000` | Internal http container port |
| replicaCount | int | `1` | Number of replicas |
| revisionHistoryLimit | int | `nil` | Maximum number of revisions maintained in revision history
| podDisruptionBudget | object | `{}` | Pod disruption budget |
| podDisruptionBudget.minAvailable | int | `nil` | Minimum number of pods that must be available after eviction |
| podDisruptionBudget.maxUnavailable | int | `nil` | Maximum number of pods that can be unavailable after eviction |

## Service paramters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.port | int | `80` | Wordpress HTTP service port |
| service.type | string | `"ClusterIP"` | Service type |
| service.nodePort | int | `nil` | The node port (only relevant for type LoadBalancer or NodePort) |
| service.clusterIP | string | `nil` | The cluster ip address (only relevant for type LoadBalancer or NodePort) |
| service.loadBalancerIP | string | `nil` | The load balancer ip address (only relevant for type LoadBalancer) |
| service.annotations | object | `{}` | Additional service annotations |

## Ingress parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.enabled | bool | `false` | Enable ingress for Wordpress service |
| ingress.annotations | string | `nil` | Additional annotations for ingress |
| ingress.hosts[0].host | string | `""` | Hostname for the ingress endpoint |
| ingress.hosts[0].host.paths[0].path | string | `"/"` | Default root path |
| ingress.hosts[0].host.paths[0].pathType | string | `ImplementationSpecific` | Ingress path type (ImplementationSpecific, Prefix, Exact) |
| ingress.tls | list | `[]` | Ingress TLS parameters |
| ingress.maxBodySize | string | `"64m"` | Maximum body size for post requests |

## Database settings

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| externalDatabase.host | string | `nil` | External database host |
| externalDatabase.name | string | `"wordpress"` | External database name |
| externalDatabase.user | string | `nil` | External database user name |
| externalDatabase.password | string | `nil` | External database user password |
| externalDatabase.port | int | `3306` | External database port |
| externalDatabase.ssl.enabled | bool | `false` | Enable SSL connection to database |
| externalDatabase.ssl.mode | string | `"REQUIRED"` | SSL mode (REQUIRED, VERIFY_CA, VERIFY_IDENTITY) |
| externalDatabase.ssl.useSystemCa | bool | `false` | Use system CA certificates (includes DigiCert, Let's Encrypt, etc.) |
| externalDatabase.ssl.caPath | string | `nil` | Custom CA certificate path (only if useSystemCa is false) |
| externalDatabase.ssl.caSecretName | string | `nil` | Name of secret containing custom CA certificate (key: ca.pem) |
| mariadb.enabled | bool | `false` | Enable MariaDB deployment (will disable external database settings) |
| mariadb.settings.rootPassword | string | `nil` | MariaDB root user password |
| mariadb.storage | string | `nil` | MariaDB storage settings |
| mariadb.userDatabase.name | string | `nil` | MariaDB wordpress database name |
| mariadb.userDatabase.password | string | `nil` | MariaDB wordpress database user |
| mariadb.userDatabase.user | string | `nil` | MariaDB wordpress database user password |

### Azure MySQL Flexible Server with SSL

For Azure MySQL Flexible Server with SSL enforced (MySQL 8.4), you have two options:

#### Option 1: Use System CA Bundle (Recommended)

The WordPress container already includes common public root CAs (DigiCert, Let's Encrypt, etc.). This is the simplest approach - no secret needed:

```yaml
externalDatabase:
  host: your-server.mysql.database.azure.com
  name: wordpress
  user: your-username
  password: your-password
  port: 3306
  ssl:
    enabled: true
    mode: REQUIRED
    useSystemCa: true
```

#### Option 2: Use Custom CA Certificate

If you need to use a specific CA certificate:

1. Download the DigiCert Global Root G2 certificate:
   ```bash
   curl -o DigiCertGlobalRootG2.crt.pem https://dl.cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem
   ```

2. Create a Kubernetes secret:
   ```bash
   kubectl create secret generic mysql-ssl-ca --from-file=ca.pem=DigiCertGlobalRootG2.crt.pem
   ```

3. Configure values.yaml:
   ```yaml
   externalDatabase:
     host: your-server.mysql.database.azure.com
     name: wordpress
     user: your-username
     password: your-password
     port: 3306
     ssl:
       enabled: true
       mode: REQUIRED
       caPath: /etc/ssl/certs/mysql-ca.pem
       caSecretName: mysql-ssl-ca
   ```

## Wordpress parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apacheDefaultSiteConfig | string | `""` | Overwrite default apache 000-default.conf |
| apachePortsConfig | string | `""` | Overwrite default apache ports.conf |
| customPhpConfig | string | `""` | Additional PHP custom.ini |
| settings.tablePrefix | string | `nil` | Database table name prefix |
| settings.maxFileUploadSize | string | `64M` | Maximum file upload size |
| settings.memoryLimit | string | `128M` | PHP memory limit |
| settings.configExtra | string | `nil` | Extra values embedded inside wp-config.php |
| extraEnvSecrets | list | `[]` | A list of existing secrets that will be mounted into the container as environment variables |
| extraEnvConfigs | list | `[]` | A list of existing configmaps that will be mounted into the container as environment variables |
| extraSecrets | list | `[]` | A list of additional existing secrets that will be mounted into the container |

## Storage parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| storage.accessModes[0] | string | `"ReadWriteOnce"` | Storage access mode |
| storage.persistentVolumeClaimName | string | `nil` | PVC name when existing storage volume should be used |
| storage.requestedSize | string | `nil` | Size for new PVC, when no existing PVC is used |
| storage.className | string | `nil` | Storage class name |
| storage.keepPvc | bool | `false` | Keep a created Persistent volume claim when uninstalling the helm chart |
