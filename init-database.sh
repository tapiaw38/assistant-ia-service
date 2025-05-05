#!/bin/bash
set -e

PG_DB_USER=${PG_DB_USER:-postgres}
PG_DB_PASSWORD=${PG_DB_PASSWORD:-password}
PG_DB_NAME=${PG_DB_NAME:-auth-api-db}

echo "Creating database user '$DB_USER' and database '$DB_NAME'..."
DB_EXISTS=$(psql -U "$POSTGRES_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
if [ ! -z "$DB_EXISTS" ]; then
  echo "Database '$DB_NAME' already exists, skipping creation..."
else
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    CREATE DATABASE $DB_NAME;
    GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOSQL
fi

echo "Database initialization finished successfully!"