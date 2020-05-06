#!/bin/bash

# Enables Third-Party Drupal 8 Modules via Drush
# SITE_ROOT defined in drupal/resources/drupal.env

# Simple function to provide some of the standard drush command boilerplate.
function d () {
    drush -y --root=$SITE_ROOT "$@"
}

d en bootstrap
d config-set system.theme default bootstrap
d config-set system.theme admin bootstrap
d en admin_toolbar
d en antibot
d en backup_migrate
d en config_filter
d en config_split
d en entity_browser
d en google_analytics
d en pathauto
d en redirect
d en s3fs
d en s3fs_cors
d en stage_file_proxy
d en twig_tweak
d en token
d en layout_builder
d en layout_discovery
d en media
d en media_library
d en paragraphs
d en responsive_image
d en syslog
d en field_layout
d en devel
d en datetime_range
d en telephone