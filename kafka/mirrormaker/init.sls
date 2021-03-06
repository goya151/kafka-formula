{% from "kafka/map.jinja" import kafka with context %}

{% if 'mirrormaker' in kafka %}
kafka_mirrormaker-consumer-config:
  file.managed:
    - name: /etc/kafka/mirrormaker/consumer.properties
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://kafka/mirrormaker/_templates/config.properties.jinja
    - template: jinja
    - context: 
        mirrormaker_nodes: {{ kafka['mirrormaker']['consumer']['nodes']|yaml }} 
        mirrormaker_port: {{ kafka['mirrormaker']['consumer']['port'] }}
        mirrormaker_options: {{ kafka['mirrormaker']['consumer']['options']|yaml }}

kafka_mirrormaker-producer-config:
  file.managed:
    - name: /etc/kafka/mirrormaker/producer.properties
    - makedirs: true
    - user: root
    - group: root
    - mode: 644
    - source: salt://kafka/mirrormaker/_templates/config.properties.jinja
    - template: jinja
    - context:
        mirrormaker_nodes: {{ kafka['mirrormaker']['producer']['nodes']|yaml }}
        mirrormaker_port: {{ kafka['mirrormaker']['producer']['port'] }}
        mirrormaker_options: {{ kafka['mirrormaker']['producer']['options']|yaml }}

kafka_mirrormaker-service:
  service.running:
    - name: mirror_maker
    - enable: true
    - watch:
      - file: kafka_mirrormaker-consumer-config
      - file: kafka_mirrormaker-producer-config
      
{% endif %}
