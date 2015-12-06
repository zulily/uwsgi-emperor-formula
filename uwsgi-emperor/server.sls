{% from "uwsgi-emperor/map.jinja" import uwsgi_emperor with context -%}


{{ uwsgi_emperor.package }}:
  pkg:
    - installed
  service:
    - running
    - name: {{ uwsgi_emperor.service }}
    - enable: True


{% for plugin in salt['pillar.get']('uwsgi_emperor:plugins', []) %}

{{ plugin }}:
  pkg:
    - installed
    - require_in:
      - service: {{ uwsgi_emperor.service }}

{% endfor %}


{{ uwsgi_emperor.log_dir }}:
  file.directory:
    - mode: 755
    - user: {{ uwsgi_emperor.user }}
    - group: {{ uwsgi_emperor.group }}
    - require:
      - pkg: {{ uwsgi_emperor.package }}


{{ uwsgi_emperor.conf_dir }}/uwsgi_params:
  file.managed:
    - source: salt://uwsgi-emperor/files/uwsgi_params
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: {{ uwsgi_emperor.package }}
