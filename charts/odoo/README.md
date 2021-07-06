# Odoo chart

## Usage

1. Create postgresql username and db
2. Create kube namespace (`kubectl create ns CHANGEME_NAMESPACE`) and copy docker-hub pull secret if necessary
3. Create custom values file, for example;

```yaml
image:
  repository: "glodouk/odoo"
  tag: "13.0e"

config:
  adminPassword: "CHANGEME"
  postgresql:
    host: "CHANGEME"
    user: "CHANGEME"
    password: "CHANGEME"
    database: "CHANGEME"

web:
  enabled: true

  ingress:
    enabled: true
    match: Host(`CHANGEME.glodo.cloud`)

queue:
  enabled: false

upgrade:
  enabled: true
```

4. Run `helm install CHANGEME_PROJECTNAME -f myvals.yaml odoo -n CHANGEME_NAMESPACE`
5. Keep `myvals.yaml` you will need this for future upgrades

To inspect:

`helm ls -n CHANGEME_NAMESPACE`
`helm del CHANGEME_PROJECTNAME -n CHANGEME_NAMESPACE`

To Upgrade:

1. `helm upgrade --install CHANGEME_PROJECTNAME -f myvals.yaml odoo -n CHANGEME_NAMESPACE`
