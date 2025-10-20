# CI Build and Test Scripts

This directory contains CI build scripts for all platforms to make it easy for engineers to compile and run unit tests.

## Quick Start

### Run All Platform Tests
```bash
./build-and-test-all.sh
```

### Run Individual Platform Tests

#### C# (.NET)
```bash
cd Dotnet
./build-and-test.sh
```

#### Java (Maven)
```bash
cd Java
./build-and-test.sh
```

#### Python
```bash
cd Python
./build-and-test.sh
```

#### TypeScript (Node.js)
```bash
cd TypeScript
./build-and-test.sh
```

## Prerequisites

### Required Software
- **Docker**: For PostgreSQL database
- **C#**: .NET SDK 8.0 or later
- **Java**: JDK 11 or later + Maven 3.6+
- **Python**: Python 3.8 or later
- **TypeScript**: Node.js 16+ and npm

### Database Setup
The scripts automatically start PostgreSQL using Docker Compose. Ensure Docker is running before executing the tests.

## What Each Script Does

### Individual Platform Scripts
Each `build-and-test.sh` script:

1. **Checks Prerequisites**: Verifies required tools are installed
2. **Installs Dependencies**: Downloads/installs required packages
3. **Compiles Code**: Builds the application
4. **Runs Tests**: Executes all unit tests
5. **Generates Reports**: Creates test reports and coverage data
6. **Database Cleanup**: Automatically cleans up test data

### Master Script (`build-and-test-all.sh`)
The master script:

1. **Checks Docker**: Ensures Docker is running
2. **Starts Database**: Launches PostgreSQL via Docker Compose
3. **Runs All Platforms**: Executes each platform's build-and-test.sh
4. **Provides Summary**: Shows results for all platforms

## Test Features

All platforms include:

- ✅ **Database Cleanup**: Automatic cleanup after each test
- ✅ **Constraint Testing**: NOT NULL and UNIQUE constraint validation
- ✅ **Foreign Key Testing**: Foreign key constraint validation
- ✅ **SOLID Principle Demonstrations**: Examples of principle violations
- ✅ **Comprehensive Coverage**: Tests for all major functionality

## Troubleshooting

### Common Issues

#### Database Connection Errors
```
Error: password authentication failed for user "postgres"
```
**Solution**: Ensure PostgreSQL is running and accessible on localhost:5432

#### Missing Dependencies
```
Error: [tool] is not installed
```
**Solution**: Install the required tool using the provided links in the error message

#### Port Conflicts
```
Error: Port 5432 is already in use
```
**Solution**: Stop any existing PostgreSQL instances or change the port in docker-compose.yml

### Manual Database Management
```bash
# Start database
docker-compose up -d

# Stop database
docker-compose down

# View database logs
docker-compose logs postgres
```

## Output Files

### Test Reports
- **C#**: Test results displayed in console
- **Java**: `target/site/surefire-report.html`
- **Python**: `htmlcov/index.html` (coverage report)
- **TypeScript**: Test results displayed in console

### Build Artifacts
- **C#**: Compiled binaries in `bin/` and `obj/` directories
- **Java**: Compiled classes in `target/classes/`
- **Python**: Virtual environment in `venv/`
- **TypeScript**: Compiled JavaScript in `dist/`

## CI/CD Integration

These scripts are designed to be easily integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run All Tests
  run: ./build-and-test-all.sh
```

```yaml
# Example Jenkins pipeline
stage('Test All Platforms') {
    steps {
        sh './build-and-test-all.sh'
    }
}
```

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the individual script outputs for specific error messages
3. Ensure all prerequisites are installed and working
4. Verify database connectivity and Docker status
