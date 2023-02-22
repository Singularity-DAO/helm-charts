{{/*
Expand the name of the chart.
*/}}
{{- define "msd-fastapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "msd-fastapi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "msd-fastapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "msd-fastapi.labels" -}}
helm.sh/chart: {{ include "msd-fastapi.chart" . }}
{{ include "msd-fastapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "msd-fastapi.selectorLabels" -}}
app: {{ include "msd-fastapi.name" . }}
app.kubernetes.io/name: {{ include "msd-fastapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "msd-fastapi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "msd-fastapi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "secret.ssh_key.fullname" -}}
{{- default .Values.configuration.ssh.secretName "ssh-key-bastion" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "secret.ssh_key.key_name" -}}
{{- default .Values.configuration.ssh.secretPath "ssh-key-mysql-test" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "secret.snowflake_privatekey.fullname" -}}
{{- default .Values.configuration.snowflake.secretName "privatekey-secret" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "secret.snowflake.key_name" -}}
{{- default .Values.configuration.snowflake.secretPath "id_rsa_snowflake" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "configmap.fullname" -}}
{{- default .Values.configuration.ssh.secretName "ssh-key-bastion" | trunc 63 | trimSuffix "-" }}
{{- end }}