# Reusables

This repository contains reusable resources like Docker configurations and prompts.

## Directory Structure
- `docker/`: Contains the Docker Compose file and a management script for easily spinning up databases, MinIO, and other services.
- `prompts/`: Contains useful prompts and architectural context documents.

## Usage: Docker & Local Services

We have a centralized `docker-compose.yml` that provides a shared network and several services out of the box:
- **PostgreSQL** (Port `5432`)
- **pgAdmin** (Port `5050`)
- **MinIO** (Ports `9000` API, `9001` Console)

To easily manage these, use the provided `docker/manage.sh` script.

### 1. Start all containers
```bash
./docker/manage.sh
```

### 2. Start specific containers only
```bash
# Start just postgres and minio
./docker/manage.sh -c "postgres minio"
```

### 3. Provision a PostgreSQL Database on Startup
You can automatically create a database once the containers start.
```bash
# Start containers and create 'my_db' database
./docker/manage.sh -d my_db
```

To drop and recreate an existing database, use the `-D` flag:
```bash
./docker/manage.sh -D my_db
```

### 4. Provision a MinIO Bucket on Startup
You can automatically create a MinIO bucket once the containers start.
```bash
# Start containers and create 'my-bucket'
./docker/manage.sh -m my-bucket
```

### 5. Create both a Database and a MinIO Bucket
You can combine these flags:
```bash
./docker/manage.sh -d my_db -m my-bucket
```

### Default Credentials
- **PostgreSQL**: `postgres` / `postgres`
- **pgAdmin**: `admin@admin.com` / `admin`
- **MinIO**: `admin` / `admin123`
