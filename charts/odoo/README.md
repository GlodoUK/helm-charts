# odoo

An opinionated "Bring Your Own Image" Doodba (Odoo) Helm chart for Kubernetes

![Version: 1.0.20220621](https://img.shields.io/badge/Version-1.0.20220621-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Opinionated odoo Bring Your Own Image chart designed for running [Doodba](https://github.com/Tecnativa/doodba) based Odoo deployments with Glodo defaults.

Includes support for:
  * Custom config, through both file and env var
  * Multi deployment and replica (i.e. web, cron, and OCA/queue may be all run as separate deployments)
  * [external-dns CRD](https://github.com/kubernetes-sigs/external-dns) support
  * Traefik IngressRoute (standard Ingress is currently not available)
  * Automatic running of [click-odoo-update](https://github.com/acsone/click-odoo-contrib#click-odoo-update-stable)

Future plans include:
  * Optionally automatically scaling down before click-odoo-update, and then back up
  * Standard Ingress support

## Installing the Chart

To install the chart with the release name `my-release`:

```console

$ helm repo add glodo https://glodouk.github.io/helm-charts/
$ helm install my-release glodo/odoo -f ./helm-values.yaml
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.adminPassword | string | `""` | sets odoo configuration admin_password |
| config.dbFilter | string | `".*"` | sets odoo configuration db_filter |
| config.listDB | string | `"true"` | sets odoo configuration list_db |
| config.postgresql.database | string | `""` | sets both odoo configuration PGDATABASE, if you are setting this, you probably waant to also set config.dbFilter |
| config.postgresql.host | string | `""` | sets both odoo configuration db_host and environment variable PGHOST |
| config.postgresql.password | string | `""` | sets both odoo configuration db_password and environment variable PGPASSWORD |
| config.postgresql.port | int | `5432` | sets both odoo configuration db_port and environment variable PGPORT |
| config.postgresql.user | string | `""` | sets both odoo configuration db_username and environment variable PGUSER |
| config.proxyMode | string | `"true"` | sets odoo configuration proxy_mode |
| config.smtp.host | string | `"false"` | sets odoo configuration smtp_server |
| config.smtp.password | string | `"false"` | sets odoo configuration smtp_password |
| config.smtp.port | string | `"false"` | sets odoo configuration smtp_port |
| config.smtp.ssl | string | `"false"` | sets odoo configuration smtp_ssl |
| config.smtp.user | string | `"false"` | sets odoo configuration smtp_user |
| config.withoutDemo | string | `"true"` | sets odoo configuration without_demo |
| extraManifests | string | `""` | Use extraManifests (string) to add. This is run through the templating system, and may be useful to create custom additional deployments, statefulsets, etc. that need a "rollme" annotation changed to force redeployment after changes are made. |
| image.pullPolicy | string | `"Always"` | container pullPolicy |
| image.repository | string | `"glodouk/CHANGEME"` | container image |
| image.tag | string | `""` | container tag |
| imagePullSecrets | list | `[]` | imagePullSecrets will be propagated to all containers, if set |
| nameOverride | string | `""` | overrides the name of the chart, ignoring what is used at deployment |
| persistence.accessMode | string | `"ReadWriteMany"` | when running deployment with replicas > 1 ReadWriteMany is a requirement, if you are in an environment without ReadWriteMany available then you will need to find an alternative solution i.e. https://github.com/camptocamp/odoo-cloud-platform/tree/14.0/base_attachment_object_storage |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` | enable /var/lib/odoo persistence, without persistence it will be temporary - and that's a bad thing! |
| persistence.existingClaim | string | `""` |  |
| persistence.name | string | `"storage"` |  |
| persistence.size | string | `"100Gi"` |  |
| persistence.storageClassName | string | `"nfs-client"` |  |
| queue.affinity | object | `{}` |  |
| queue.config | string | `"[options]\nserver_wide_modules = queue_job\nworkers = 2\nmax_cron_threads = 1\nlimit_memory_soft = 3758096384\nlimit_memory_hard = 4294967296\nlimit_time_cpu = 14400\nlimit_time_real = 14400\nlimit_time_real_cron = 14400\n"` |  |
| queue.enabled | bool | `false` | enable a second deployment, specifically running oca/queue_job |
| queue.extraEnv | list | `[]` | optional extra environment variables |
| queue.name | string | `"queue"` |  |
| queue.nodeSelector | object | `{}` |  |
| queue.podAnnotations | object | `{}` |  |
| queue.podSecurityContext | object | `{}` |  |
| queue.replicaCount | int | `1` |  |
| queue.resources | object | `{}` |  |
| queue.securityContext | object | `{}` |  |
| queue.tolerations | list | `[]` |  |
| upgrade.enabled | bool | `true` | enable click-odoo-update on helm chart upgrade |
| upgrade.name | string | `"upgrade"` |  |
| velero.defaultVolumesToRestic | bool | `true` | see https://velero.io/docs/v1.9/customize-installation/#default-pod-volume-backup-to-restic |
| velero.enabled | bool | `false` | enable creation of velero schedule |
| velero.extraHooks | list | `[]` | additional hooks |
| velero.includeClusterResources | bool | `false` | see https://velero.io/docs/v1.9/resource-filtering/#--include-cluster-resources |
| velero.name | string | `"backup"` | the schedule will be named `namespace-of-deployment-chart-name-name` |
| velero.pgDumpHook | bool | `true` | automatically take a pg_dump (custom format) of $PGDATABASE to /var/lib/odoo/$PGDATABASE.dump |
| velero.schedule | string | `"5 6,12,18 * * *"` | schedule to run on |
| velero.ttl | string | `"336h0m00s"` | backup retention period |
| velero.veleroNamespace | string | `"velero"` | - backup schedules must exist in the velero namespace, or Velero will not detect the schedule |
| web.affinity | object | `{}` |  |
| web.certificate.dnsNames | list | `[]` |  |
| web.certificate.enabled | bool | `false` | enables cert-manager Certificate creation |
| web.certificate.issuerRef.kind | string | `"ClusterIssuer"` |  |
| web.certificate.issuerRef.name | string | `"letsencrypt"` |  |
| web.certificate.secretName | string | `"odoo-web-certificate"` |  |
| web.config | string | `"[options]\nlimit_memory_soft = 3758096384\nlimit_memory_hard = 4294967296\nlimit_time_cpu = 360\nlimit_time_real = 360\nlimit_time_real_cron = 360\nmax_cron_threads = 1\nworkers = 5\nlongpolling_port = 8072\n"` | through environment variables |
| web.dns.enabled | bool | `false` | enables external-dns CRD (DNSEndpoint) creation |
| web.dns.endPoints | list | `[]` | must be DNSEndpoint compatible As of time of writing only A, CNAME, TXT and SRV records are supported See: https://github.com/ytsarev/external-dns/blob/master/endpoint/endpoint.go#L27-L36 ```yaml - dnsName: "something.domain"   recordTTL: 60   recordType: A   targets:     - xx.xx.xx.xx ``` |
| web.enabled | bool | `true` | enable Odoo web worker |
| web.extraEnv | list | `[]` | optional extra environment variables |
| web.ingress.annotations | object | `{}` |  |
| web.ingress.enabled | bool | `true` | enable Traefik IngressRoute creation |
| web.ingress.entryPoints[0] | string | `"websecure"` |  |
| web.ingress.match | string | `"Host(`chart-example.local`)"` |  |
| web.ingress.middlewares | list | `[]` |  |
| web.ingress.tls.certResolver | string | `"letsencrypt"` |  |
| web.ingress.tls.secretName | string | `""` |  |
| web.name | string | `"web"` |  |
| web.nodeSelector | object | `{}` |  |
| web.podAnnotations | object | `{}` |  |
| web.podSecurityContext | object | `{}` |  |
| web.replicaCount | int | `1` |  |
| web.resources | object | `{}` |  |
| web.securityContext | object | `{}` |  |
| web.service.type | string | `"ClusterIP"` |  |
| web.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.10.0](https://github.com/norwoodj/helm-docs/releases/v1.10.0)
