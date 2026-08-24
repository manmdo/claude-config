# Start Local Development Environment

Start the Docker-based local development environment with all necessary services.

## Instructions

1. Check if Docker is running
2. Check current status of containers
3. Start the development environment using docker compose
4. Wait for services to be healthy
5. Display access URLs and useful commands

## Execution

```bash
# Check Docker daemon
docker info > /dev/null 2>&1 || echo "ERROR: Docker is not running. Please start Docker Desktop."

# Check current container status
echo "Current container status:"
docker compose ps

# Start services
echo "Starting development environment..."
docker compose up --build -d

# Wait for database to be healthy
echo "Waiting for PostgreSQL to be ready..."
docker compose exec -T db pg_isready -U postgres -d globalsolar

# Show running services
echo ""
echo "Services started successfully!"
docker compose ps

echo ""
echo "Access URLs:"
echo "  - Application: http://localhost:3000"
echo "  - Database: postgresql://postgres:postgres@localhost:5432/globalsolar"
echo ""
echo "Useful commands:"
echo "  - View logs: docker compose logs -f"
echo "  - Stop: docker compose down"
echo "  - Reset DB: docker compose down -v && docker compose up --build -d"
echo "  - Prisma Studio: docker compose --profile tools up prisma-studio -d"
```

## Notes

- First run will take longer as it builds the Docker image
- Database data persists in a Docker volume
- Use `docker compose down -v` to reset the database completely
