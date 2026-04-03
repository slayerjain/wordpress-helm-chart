FROM wordpress:6.9.0-apache

# Run commands as root
USER root

# Enable required Apache modules
RUN a2enmod headers rewrite

# Switch back to the www-data user
USER www-data
