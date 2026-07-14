#!/bin/bash

# Absolute path to the compose file so it can be run from anywhere
COMPOSE_FILE="/mnt/thorne/CODEINE/reusables/docker/docker-compose.yml"
CONTAINERS=""
DB_NAME=""
MINIO_BUCKET=""
DELETE_EXISTING=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -c|--containers) CONTAINERS="$2"; shift ;;
        -d|--db) DB_NAME="$2"; shift ;;
        -m|--minio) MINIO_BUCKET="$2"; shift ;;
        -D|--delete-db) DB_NAME="$2"; DELETE_EXISTING=true; shift ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  -c, --containers <names>   Specific containers to start (e.g., 'postgres', 'minio', or 'postgres pgadmin minio'). Starts all if omitted."
            echo "  -d, --db <name>            Database name to create after containers start."
            echo "  -m, --minio <name>         MinIO bucket name to create after containers start."
            echo "  -D, --delete-db <name>     Database name to recreate after containers start (deletes first if it exists)."
            echo "  -h, --help                 Show this help message."
            exit 0
            ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "🚀 Starting Docker containers..."
if [ -z "$CONTAINERS" ]; then
    docker compose -f "$COMPOSE_FILE" up -d
else
    # Word splitting handles multiple containers passed in quotes
    docker compose -f "$COMPOSE_FILE" up -d $CONTAINERS
fi

if [ -n "$DB_NAME" ]; then
    # Ensure postgres container is among those started if we are trying to create a DB
    echo "⏳ Waiting for PostgreSQL to be ready..."
    until docker exec reusable-postgres pg_isready -U postgres > /dev/null 2>&1; do
        sleep 1
    done

    if [ "$DELETE_EXISTING" = true ]; then
        echo "🗑️ Deleting existing database: $DB_NAME..."
        docker exec reusable-postgres dropdb -U postgres --if-exists --force "$DB_NAME" 2>/dev/null
    fi

    echo "🗄️ Creating database: $DB_NAME..."
    # Try to create the database; hide error if it already exists
    docker exec reusable-postgres createdb -U postgres "$DB_NAME" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Database '$DB_NAME' created successfully."
    else
        echo "ℹ️ Database '$DB_NAME' might already exist or there was an issue creating it."
    fi

    echo ""
    echo "=========================================================="
    echo "🔗 Connection Strings for '$DB_NAME':"
    echo "=========================================================="
    echo "📍 Local Development (e.g., bun dev / npm run dev):"
    echo "   DATABASE_URL=\"postgresql://postgres:postgres@localhost:5432/$DB_NAME\""
    echo ""
    echo "🐳 Docker-to-Docker (Apps on 'shared-network'):"
    echo "   DATABASE_URL=\"postgresql://postgres:postgres@reusable-postgres:5432/$DB_NAME\""
    echo "=========================================================="
fi

if [ -n "$MINIO_BUCKET" ]; then
    echo "⏳ Waiting for MinIO to be ready..."
    # Wait until minio is reachable
    until docker exec reusable-minio curl -s http://localhost:9000/minio/health/live > /dev/null 2>&1; do
        sleep 1
    done

    echo "📦 Creating MinIO bucket: $MINIO_BUCKET..."
    # configure mc alias inside the container
    docker exec reusable-minio mc alias set myminio http://localhost:9000 admin admin123 >/dev/null 2>&1
    docker exec reusable-minio mc mb myminio/"$MINIO_BUCKET" 2>/dev/null
    
    # Set bucket policy to public so images are browser-accessible
    docker exec reusable-minio mc anonymous set public myminio/"$MINIO_BUCKET" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "✅ MinIO bucket '$MINIO_BUCKET' created successfully."
    else
        echo "ℹ️ MinIO bucket '$MINIO_BUCKET' might already exist or there was an issue creating it."
    fi

    echo ""
    echo "=========================================================="
    echo "🔗 Connection Details for MinIO Bucket '$MINIO_BUCKET':"
    echo "=========================================================="
    echo "📍 S3 Endpoint (Local): http://localhost:9000"
    echo "📍 S3 Endpoint (Docker): http://reusable-minio:9000"
    echo "📍 Console UI: http://localhost:9001 (admin / admin123)"
    echo "📍 Bucket Name: $MINIO_BUCKET"
    echo "=========================================================="
fi
