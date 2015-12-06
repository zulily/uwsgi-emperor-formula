{% for vassal_settings in salt['pillar.get']('uwsgi_emperor:vassals', {}) %}
  {% for vassal in vassal_settings.keys() %}

/etc/logrotate.d/{{ vassal }}:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://uwsgi-emperor/files/uwsgi_app_logrotate.jinja
    - context:
      app_log_file: /var/log/uwsgi/{{ vassal }}.log

  {% endfor %}
{% endfor %}
