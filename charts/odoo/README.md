# odoo

An opinionated "Bring Your Own Image" Doodba (Odoo) Helm chart for Kubernetes

![Version: 1.0.20230303](https://img.shields.io/badge/Version-1.0.20230303-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Opinionated odoo Bring Your Own Image chart designed for running [Doodba](https://github.com/Tecnativa/doodba) based Odoo deployments with Glodo defaults.

Includes support for:
  * Custom config, through both file and env var
  * Multi deployment and replica (i.e. web, cron, and OCA/queue may be all run as separate deployments)
  * [external-dns CRD](https://github.com/kubernetes-sigs/external-dns) support
  * [cert-manager](https://cert-manager.io/) CRD support
  * Both Traefik IngressRoute and Ingress
  * Automatic running of [click-odoo-update](https://github.com/acsone/click-odoo-contrib#click-odoo-update-stable)
  * Optional support for scaling down the installation before click-odoo-update runs

## Installing the Chart

To install the chart with the release name `my-release`:

```console

$ helm repo add glodo https://glodouk.github.io/helm-charts/
$ helm install my-release glodo/odoo -f ./helm-values.yaml
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.adminPassword | string | `""` | sets odoo configuration admin_password, it is not recommend to use this key |
| config.dbFilter | string | `".*"` | sets odoo configuration db_filter |
| config.listDB | string | `"true"` | sets odoo configuration list_db |
| config.postgresql.database | string | `""` | sets both odoo configuration PGDATABASE, if you are setting this, you probably waant to also set config.dbFilter |
| config.postgresql.host | string | `""` | sets both odoo configuration db_host and environment variable PGHOST |
| config.postgresql.password | string | `""` | sets both odoo configuration db_password and environment variable PGPASSWORD |
| config.postgresql.port | int | `5432` | sets both odoo configuration db_port and environment variable PGPORT |
| config.postgresql.secretRef.keys | object | `{"password":"password","user":"username"}` | format 'helm value: secret key name' |
| config.postgresql.secretRef.name | string | `""` | if set this secret's keys will be used preferentially |
| config.postgresql.user | string | `""` | sets both odoo configuration db_username and environment variable PGUSER |
| config.proxyMode | string | `"true"` | sets odoo configuration proxy_mode |
| config.secretRef.keys.adminPassword | string | `"password"` |  |
| config.secretRef.name | string | `""` | if set this secret's keys will be used preferentially |
| config.smtp.host | string | `"false"` | sets odoo configuration smtp_server |
| config.smtp.password | string | `"false"` | sets odoo configuration smtp_password |
| config.smtp.port | string | `"false"` | sets odoo configuration smtp_port |
| config.smtp.secretRef.keys | object | `{"password":"password","user":"username"}` | key presents one of the above values (user, password), value represents secret key |
| config.smtp.secretRef.name | string | `""` | if set this secret's keys will be used preferentially |
| config.smtp.ssl | string | `"false"` | sets odoo configuration smtp_ssl |
| config.smtp.user | string | `"false"` | sets odoo configuration smtp_user |
| config.withoutDemo | string | `"true"` | sets odoo configuration without_demo |
| extraManifests | string | `""` | Use extraManifests (string) to add. This is run through the templating system, and may be useful to create custom additional deployments, statefulsets, etc. that need a "rollme" annotation changed to force redeployment after changes are made. |
| image.pullPolicy | string | `"IfNotPresent"` | container pullPolicy |
| image.repository | string | `"glodouk/CHANGEME"` | container image |
| image.tag | string | `""` | container tag |
| imagePullSecrets | list | `[]` | imagePullSecrets will be propagated to all containers, if set |
| install.enabled | bool | `false` | enable the pre-install hook to init the db |
| install.name | string | `"install"` |  |
| longpolling.affinity | object | `{}` |  |
| longpolling.config | string | `"[options]\nlimit_time_cpu = 360\nlimit_time_real = 360\nlimit_time_real_cron = 360\nmax_cron_threads = 0\nworkers = 4\nlongpolling_port = 8072\n"` | through environment variables |
| longpolling.enabled | bool | `false` | enable a separate longpolling / or websocket instance, both web and longpolling/websocket must be enabled |
| longpolling.extraContainers | list | `[]` | optional extra containers |
| longpolling.extraEnv | list | `[]` | optional extra environment variables |
| longpolling.extraVolumeMounts | list | `[]` | optional extra volume mounts |
| longpolling.extraVolumes | list | `[]` | optional extra volumes |
| longpolling.livenessProbe.enabled | bool | `false` | enable livenessProbe |
| longpolling.livenessProbe.values | object | `{"initialDelaySeconds":60,"periodSeconds":60,"tcpSocket":{"port":"longpolling"},"timeoutSeconds":60}` | livenessProbe configuration, note that /web/health did not until mid-way through the 15.0 release, therefore we suggest tcpSocket |
| longpolling.name | string | `"longpolling"` |  |
| longpolling.nodeSelector | object | `{}` |  |
| longpolling.podAnnotations | object | `{}` |  |
| longpolling.podSecurityContext | object | `{}` |  |
| longpolling.readinessProbe.enabled | bool | `false` | enable readinessProbe |
| longpolling.readinessProbe.values | object | `{"initialDelaySeconds":60,"periodSeconds":60,"tcpSocket":{"port":"longpolling"},"timeoutSeconds":60}` | readinessProbe configuration, note that /web/health did not until mid-way through the 15.0 release, therefore we suggest tcpSocket |
| longpolling.replicaCount | int | `1` |  |
| longpolling.resources | object | `{}` |  |
| longpolling.securityContext | object | `{}` |  |
| longpolling.service.type | string | `"ClusterIP"` |  |
| longpolling.strategy | object | `{"type":"RollingUpdate"}` | kubernetes Deployment strategy, note: queue is always set to Recreate, |
| longpolling.tolerations | list | `[]` |  |
| nameOverride | string | `""` | overrides the name of the chart, ignoring what is used at deployment |
| persistence.accessMode | string | `"ReadWriteMany"` | when running deployment with replicas > 1 ReadWriteMany is a requirement, if you are in an environment without ReadWriteMany available then you will need to find an alternative solution i.e. https://github.com/camptocamp/odoo-cloud-platform/tree/14.0/base_attachment_object_storage |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` | enable /var/lib/odoo persistence, without persistence it will be temporary - and that's a bad thing! |
| persistence.existingClaim | string | `""` |  |
| persistence.name | string | `"storage"` |  |
| persistence.size | string | `"100Gi"` |  |
| persistence.storageClassName | string | `"nfs-client"` |  |
| queue.affinity | object | `{}` |  |
| queue.config | string | `"[options]\nserver_wide_modules = queue_job,web\nworkers = 2\nmax_cron_threads = 1\nlimit_time_cpu = 14400\nlimit_time_real = 14400\nlimit_time_real_cron = 14400\n"` |  |
| queue.enabled | bool | `false` | enable a second deployment, specifically running oca/queue_job |
| queue.extraContainers | list | `[]` | optional extra containers |
| queue.extraEnv | list | `[]` | optional extra environment variables |
| queue.extraVolumeMounts | list | `[]` | optional extra volume mounts |
| queue.extraVolumes | list | `[]` | optional extra volumes |
| queue.name | string | `"queue"` |  |
| queue.nodeSelector | object | `{}` |  |
| queue.podAnnotations | object | `{}` |  |
| queue.podSecurityContext | object | `{}` |  |
| queue.replicaCount | int | `1` |  |
| queue.resources | object | `{}` |  |
| queue.securityContext | object | `{}` |  |
| queue.tolerations | list | `[]` |  |
| rollme | bool | `false` | - if true, a "rollme" annotation will be written to deployment manifests, that always changes every upgrade. If you do not tag your images this will be required to swap the container image |
| upgrade.clickArgs | string | `"--ignore-core-addons"` | customisable arguments for click-odoo-update |
| upgrade.enabled | bool | `true` | enable click-odoo-update on helm chart upgrade |
| upgrade.name | string | `"upgrade"` |  |
| upgrade.scale.enabled | bool | `false` | automatically scale down/up the existing deployments before/after upgrade |
| upgrade.scale.image.pullPolicy | string | `"Always"` | container pullPolicy |
| upgrade.scale.image.repository | string | `"bitnami/kubectl"` | container image |
| upgrade.scale.image.tag | string | `"latest"` | container tag |
| upgrade.scale.longpollingCount | int | `0` |  |
| upgrade.scale.queueCount | int | `0` |  |
| upgrade.scale.serviceAccount.annotations | object | `{}` | service account annotations |
| upgrade.scale.serviceAccount.create | bool | `true` | automatically create the service account |
| upgrade.scale.serviceAccount.name | string | `""` | if not set and create is true, upgrade.name is used |
| upgrade.scale.webCount | int | `0` |  |
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
| web.certificate.enabled | bool | `false` | enables cert-manager Certificate CRD creation |
| web.certificate.issuerRef.kind | string | `"ClusterIssuer"` |  |
| web.certificate.issuerRef.name | string | `"letsencrypt"` |  |
| web.certificate.secretName | string | `"odoo-web"` |  |
| web.config | string | `"[options]\nlimit_time_cpu = 360\nlimit_time_real = 360\nlimit_time_real_cron = 360\nmax_cron_threads = 1\nworkers = 4\n"` | through environment variables |
| web.dns.enabled | bool | `false` | enables external-dns CRD (DNSEndpoint) creation |
| web.dns.endPoints | list | `[]` | must be DNSEndpoint compatible As of time of writing only A, CNAME, TXT and SRV records are supported See: https://github.com/ytsarev/external-dns/blob/master/endpoint/endpoint.go#L27-L36 ```yaml - dnsName: "something.domain"   recordTTL: 60   recordType: A   targets:     - xx.xx.xx.xx ``` |
| web.enabled | bool | `true` | enable Odoo web worker |
| web.extraContainers | list | `[]` | optional extra containers |
| web.extraEnv | list | `[]` | optional extra environment variables |
| web.extraVolumeMounts | list | `[]` | optional extra volume mounts |
| web.extraVolumes | list | `[]` | optional extra volumes |
| web.ingress.annotations | object | `{}` | extra annotations passed to Ingress or IngressRoute, if type is IngressRoute |
| web.ingress.compress | bool | `false` | Automatically create a Traefik compress middleware |
| web.ingress.enabled | bool | `true` | enable Ingress or Traefik IngressRoute creation |
| web.ingress.entryPoints | list | `["websecure"]` | if type is IngressRoute then the IngressRoute entryPoint, if type is Ingress then it will automatically set the entrypoint annotation |
| web.ingress.geventPath | string | `"/longpolling/"` | "longpolling" path. Under 16.0 this should be changed for /websocket |
| web.ingress.hosts | list | `["chart-example.local"]` | if type is Ingress then a list of host names to match, if not using certificate CRD then also used for tls host names |
| web.ingress.match | string | `"Host(`chart-example.local`)"` | if type is IngressRoute then a string of IngressRoute compatible matches |
| web.ingress.middlewares | list | `[]` | if type is IngressRoute then Traefik Middlewares, if type is Ingress then it will automatically set Ingress annotations |
| web.ingress.tls | object | `{"certResolver":"letsencrypt","secretName":""}` | tls options |
| web.ingress.type | string | `"IngressRoute"` | IngressRoute or Ingress, when set to IngressRoute will render an Traefik IngressRoute |
| web.livenessProbe.enabled | bool | `false` | enable livenessProbe |
| web.livenessProbe.values | object | `{"initialDelaySeconds":60,"periodSeconds":60,"tcpSocket":{"port":"http"},"timeoutSeconds":60}` | livenessProbe configuration, note that /web/health did not until mid-way through the 15.0 release, therefore we suggest tcpSocket |
| web.name | string | `"web"` |  |
| web.nodeSelector | object | `{}` |  |
| web.podAnnotations | object | `{}` |  |
| web.podSecurityContext | object | `{}` |  |
| web.readinessProbe.enabled | bool | `false` | enable readinessProbe |
| web.readinessProbe.values | object | `{"initialDelaySeconds":60,"periodSeconds":60,"tcpSocket":{"port":"http"},"timeoutSeconds":60}` | readinessProbe configuration, note that /web/health did not until mid-way through the 15.0 release, therefore we suggest tcpSocket |
| web.replicaCount | int | `1` |  |
| web.resources | object | `{}` |  |
| web.securityContext | object | `{}` |  |
| web.service.type | string | `"ClusterIP"` |  |
| web.strategy | object | `{"type":"RollingUpdate"}` | kubernetes Deployment strategy, note: queue is always set to Recreate, |
| web.tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
