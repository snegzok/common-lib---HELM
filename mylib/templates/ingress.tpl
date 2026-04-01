{{- define "mylib.ingress" -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ .Release.Name }}-ingress
  annotations:
    cert-manager.io/cluster-issuer: {{ .Values.ingress.issuer | default "letsencrypt-prod" }}
    traefik.ingress.kubernetes.io/router.middlewares: default-redirect-https@kubernetescrd
    {{- with .Values.ingress.annotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  ingressClassName: {{ .Values.ingress.className | default "traefik" }}
  tls:
  - hosts:
    - {{ .Values.ingress.host }}
    secretName: {{ .Release.Name }}-tls
  rules:
  - host: {{ .Values.ingress.host }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{ .Values.ingress.serviceName | default (include "mylib.fullname" .) }}
            port:
              number: {{ .Values.ingress.servicePort | default 80 }}
{{- end -}}
