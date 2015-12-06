=============
uwsgi-emperor
=============

The uwsgi-emperor salt formula manages the installation of uwsgi and its configuration files, including an arbitrary number of vassal ini (webapp configurations) files, running uwsgi in "emperor" mode.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``uwsgi-emperor``
-----------------
The main entry point, install uwsgi-emperor, plugins, and bring up any configured vassals.
uwsgi-emperor vassal files define one or more webapps.  It is expected that these webapps
are already in place, including any python virtual environments, prior to installing uwsgi-emperor.
The formula has no concept of a 'first run / initial install' check built-in, any changes to pillar will cause a
uwsgi restart which may not be desirable!

``uwsgi-emperor.config``
------------------------
Manages the emperor.ini file and more importantly, individual vassal ini files that instruct uwsgi on how to interface with webapps, as well as the locations for python virtual enviroments.

``uwsgi-emperor.server``
------------------------
Installs the uwsgi-emperor package, plugins (e.g. the python plugin), configures the log directory and pushes the uwsgi_params file that nginx is dependent on.

``uwsgi-emperor.app_logrotate``
-------------------------------
Configures log rotation for all vassals.  Logrotation for emperor is already included in the debian package


(warning) init.sls for the uwsgi_emperor formula includes config.sls, which performs a restart if the emperor.ini or any of the vassal ini files change.  Running these states should only be performed on new or out-of-rotation servers.
Pillar Data


Other Notes
===========
+ For all vassals, nginx must be made aware of vassal sockets and uwsgi apps through the nginx configuration, specifically "upstream" and "location" stanzas, for example:

::

  upstream api {
    server 127.0.0.1:8000;
  }

  ...

  location / {
    uwsgi_pass api;
    include /etc/uwsgi-emperor/uwsgi_params;
  }

ToDo / Known Issues
===================
+ Add support for non-Debian-based distributions


