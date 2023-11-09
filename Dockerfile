FROM wordpress:6.3.1-apache

# Run commands as root
USER root

# Enable the headers module
RUN a2enmod headers

# Switch back to the www-data user
USER www-data
