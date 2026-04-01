{{- define "mylib.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount | default 1 }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      # --- БЕЗОПАСНОСТЬ ПОДА ---
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 2000
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          
          # --- ЖЕСТКАЯ ЗАЩИТА КОНТЕЙНЕРА ---
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true  # Файловая система только для чтения
            capabilities:
              drop:
                - ALL

          # --- МОНТИРУЕМ ВРЕМЕННУЮ ПАПКУ ---
          volumeMounts:
            - name: tmp-volume
              mountPath: /tmp  # Теперь Python может писать сюда логи и временные данные
            - name: cache-volume
              mountPath: /app/__pycache__ # Для ускорения работы Python

          ports:
            - containerPort: {{ .Values.service.targetPort | default 8080 }}

          # --- ЛИМИТЫ РЕСУРСОВ ---
          resources:
            requests:
              cpu: "100m"
              memory: "128Mi"
            limits:
              cpu: "500m"
              memory: "256Mi"

      # --- ОПИСАНИЕ ВРЕМЕННЫХ ДИСКОВ ---
      volumes:
        - name: tmp-volume
          emptyDir: {}  # Создает пустую папку в оперативной памяти или на диске узла
        - name: cache-volume
          emptyDir: {}
{{- end -}}
