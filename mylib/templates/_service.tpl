{{- define "mylib.service" -}}
apiVersion: v1
kind: Service
metadata:
  # Мы добавляем суффикс -service, чтобы имя было уникальным
  name: {{ .Release.Name }}-service
  labels:
    app: {{ .Release.Name }}
spec:
  type: {{ .Values.service.type | default "ClusterIP" }}
  ports:
    - port: {{ .Values.service.port | default 80 }}
      targetPort: {{ .Values.service.targetPort | default 8080 }}
      protocol: TCP
      name: http
  selector:
    app: {{ .Release.Name }}
{{- end -}}
