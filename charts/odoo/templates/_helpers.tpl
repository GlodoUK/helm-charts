{{/*
Expand the name of the chart.
*/}}
{{- define "odoo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "odoo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "odoo.common.labels" -}}
helm.sh/chart: {{ include "odoo.chart" . }}
{{ include "odoo.common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "odoo.common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odoo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Common envars
*/}}
{{- define "odoo.common.env" -}}
{{- range list "PGHOST" "PGPORT" "PGUSER" "PGDATABASE" "PROXY_MODE" "WITHOUT_DEMO" "SMTP_SERVER" "SMTP_PORT" "SMTP_USER" "SMTP_SSL" "LIST_DB" }}
- name: {{ . }}
  valueFrom:
    configMapKeyRef:
      name: {{ include "odoo.config.fullname" $ }}
      key: {{ . }}
{{- end }}
{{- range list "PGPASSWORD" "ADMIN_PASSWORD" "SMTP_PASSWORD" }}
- name: {{ . }}
  valueFrom:
    secretKeyRef:
      name: {{ include "odoo.secret.fullname" $ }}
      key: {{ . }}
{{- end }}
{{- if .Values.config.dbFilter }}
- name: DB_FILTER
  valueFrom:
    configMapKeyRef:
      name: {{ include "odoo.config.fullname" $ }}
      key: DB_FILTER
{{- end }}
{{- end }}

{{/*
Persistence fullname
*/}}
{{- define "odoo.persistence.fullname" -}}
{{- if .Values.persistence.fullnameOverride }}
{{- .Values.persistence.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" $name .Values.persistence.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
Persistence labels
*/}}
{{- define "odoo.persistence.labels" -}}
{{ include "odoo.common.labels" . }}
{{- end }}

{{/*
Web fullname
*/}}
{{- define "odoo.web.fullname" -}}
{{- if .Values.web.fullnameOverride }}
{{- .Values.web.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" $name .Values.web.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
Web labels
*/}}
{{- define "odoo.web.labels" -}}
component: {{ .Values.web.name | quote }}
{{ include "odoo.common.labels" . }}
{{- end }}

{{/*
Web Selector labels
*/}}
{{- define "odoo.web.selectorLabels" -}}
component: {{ .Values.web.name | quote }}
{{ include "odoo.common.selectorLabels" . }}
{{- end }}

{{/*
Traefik Middlewares as Annotation
*/}}
{{- define "odoo.web.traefikMiddlewaresAsAnnotation" -}}
{{- $list := list }}
{{- range .Values.web.ingress.middlewares }}
{{- $list = append $list (printf "%s-%s@kubernetescrd" .namespace .name) }}
{{- end }}
{{- if .Values.web.ingress.compress }}
{{- $fullname := include "odoo.web.fullname" .}}
{{- $list = append $list (printf "%s-%s-compress@kubernetescrd" .Release.Namespace $fullname ) }}
{{- end }}
{{- join ", " $list }}
{{- end }}

{{/*
Queue fullname
*/}}
{{- define "odoo.queue.fullname" -}}
{{- if .Values.queue.fullnameOverride }}
{{- .Values.queue.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" $name .Values.queue.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
Queue labels
*/}}
{{- define "odoo.queue.labels" -}}
component: {{ .Values.queue.name | quote }}
{{ include "odoo.common.labels" . }}
rollme: {{ randAlphaNum 5 | quote }}
{{- end }}

{{/*
Queue Selector labels
*/}}
{{- define "odoo.queue.selectorLabels" -}}
component: {{ .Values.queue.name | quote }}
{{ include "odoo.common.selectorLabels" . }}
{{- end }}

{{/*
Config fullname
*/}}
{{- define "odoo.config.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-config" $name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Secret fullname
*/}}
{{- define "odoo.secret.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-secret" $name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
upgrade fullname
*/}}
{{- define "odoo.upgrade.fullname" -}}
{{- if .Values.upgrade.fullnameOverride }}
{{- .Values.upgrade.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" $name .Values.upgrade.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
Velero fullname
*/}}
{{- define "odoo.velero.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s-%s" .Release.Namespace $name .Values.velero.name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
longpolling fullname
*/}}
{{- define "odoo.longpolling.fullname" -}}
{{- if .Values.longpolling.fullnameOverride }}
{{- .Values.longpolling.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" $name .Values.longpolling.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{/*
longpolling labels
*/}}
{{- define "odoo.longpolling.labels" -}}
component: {{ .Values.longpolling.name | quote }}
{{ include "odoo.common.labels" . }}
{{- end }}

{{/*
longpolling Selector labels
*/}}
{{- define "odoo.longpolling.selectorLabels" -}}
component: {{ .Values.longpolling.name | quote }}
{{ include "odoo.common.selectorLabels" . }}
{{- end }}

{{/*
install fullname
*/}}
{{- define "odoo.install.fullname" -}}
{{- if .Values.install.fullnameOverride }}
{{- .Values.install.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" $name .Values.install.name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}
