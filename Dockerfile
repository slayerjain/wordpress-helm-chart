# PHP 8.3.36 base: fixes CVE-2026-109618 / CVE-2026-109619 (unauthenticated RCE,
# highest risk under mod_php, which this apache image uses). Pinned by digest
# because exact tags like 6.9.0-apache stop being rebuilt and silently keep a
# vulnerable PHP; bump tag + digest together to pick up future PHP patches.
FROM wordpress:7.1.4-php8.3-apache@sha256:12ec50e21cb81a5ea964669d434578b7da4a101a45aef83f5f1c2227bcd1b058

# Run commands as root
USER root

# Enable required Apache modules
RUN a2enmod headers rewrite

# Switch back to the www-data user
USER www-data
