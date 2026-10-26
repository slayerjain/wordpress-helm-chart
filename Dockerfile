# PHP 8.3.36 base: fixes CVE-2026-109618 / CVE-2026-109619 (unauthenticated RCE,
# highest risk under mod_php, which this apache image uses). Pinned by digest
# because exact tags like 6.9.0-apache stop being rebuilt and silently keep a
# vulnerable PHP; bump tag + digest together to pick up future PHP patches.
FROM wordpress:7.1.3-php8.3-apache@sha256:d42f63cb89ad0eab272c4b393164e63830d0df270009907919f7dcce52b1a20b

# Run commands as root
USER root

# Enable required Apache modules
RUN a2enmod headers rewrite

# Switch back to the www-data user
USER www-data
