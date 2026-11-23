# PHP 8.3.36 base: fixes CVE-2026-109618 / CVE-2026-109619 (unauthenticated RCE,
# highest risk under mod_php, which this apache image uses). Pinned by digest
# because exact tags like 6.9.0-apache stop being rebuilt and silently keep a
# vulnerable PHP; bump tag + digest together to pick up future PHP patches.
FROM wordpress:7.1.5-php8.3-apache@sha256:2e5145737f46b8fd53f333a05eb3a4f21321c90e20475b7827082dd5f75b62b0

# Run commands as root
USER root

# Enable required Apache modules
RUN a2enmod headers rewrite

# Switch back to the www-data user
USER www-data
