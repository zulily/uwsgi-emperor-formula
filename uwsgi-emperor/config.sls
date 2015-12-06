{% from "uwsgi-emperor/map.jinja" import uwsgi_emperor with context -%}



config_{{ uwsgi_emperor.package }}:
  service:
    - running
    - name: {{ uwsgi_emperor.service }}
    - enable: True


{{ uwsgi_emperor.conf_file }}:
  file.managed:
    - source: salt://uwsgi-emperor/files/emperor.ini
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      user: {{ salt['pillar.get']('uwsgi_emperor:user', uwsgi_emperor.user) }}
      group: {{ salt['pillar.get']('uwsgi_emperor:group', uwsgi_emperor.group) }}
      vassals_dir: {{ salt['pillar.get']('uwsgi_emperor:vassals_dir', uwsgi_emperor.vassals_dir) }}
      settings: {{ salt['pillar.get']('uwsgi_emperor:emperor', []) }}
    - makedirs: True
    - watch_in:
      - service: config_{{ uwsgi_emperor.package }}


{% for vassal in salt['pillar.get']('uwsgi_emperor:vassals', []) %}
{{ uwsgi_emperor.vassals_dir }}/{{ vassal.keys()[0] }}.ini:
  file.managed:
    - source: salt://uwsgi-emperor/files/vassal.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      settings: {{ vassal[vassal.keys()[0]] }}
    - watch_in:
      - service: config_{{ uwsgi_emperor.package }}
{% endfor %}
