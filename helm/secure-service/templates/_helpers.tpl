{{- define "secure-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "secure-service.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "secure-service.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "secure-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "secure-service.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
