# Use the official MySQL image from Docker Hub
FROM mysql:8.0

# Set environment variables (these will be used by MySQL on startup)
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# Copy initialization scripts (if any) to the container's init directory
# You can include .sql files or .sh files to initialize the database
COPY ../init-db.sql /docker-entrypoint-initdb.d/

# Expose the MySQL port
EXPOSE 3306