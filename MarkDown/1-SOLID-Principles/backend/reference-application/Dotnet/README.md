# E-commerce SOLID Principles Exercise

This C# application demonstrates SOLID principle violations in an e-commerce system.

## Requirements

- .NET 8.0 SDK
- PostgreSQL database
- Npgsql package

## Installation

1. Install .NET 8.0 SDK
2. Restore packages:
```bash
dotnet restore
```

3. Start the PostgreSQL database using Docker Compose:
```bash
docker-compose up -d
```

4. Run the application:
```bash
dotnet run
```

## SOLID Violations to Refactor

This code intentionally violates all SOLID principles:

### Single Responsibility Principle (SRP)
- `EcommerceManager` class handles multiple responsibilities:
  - Product management
  - Cart management
  - Order processing
  - Invoice generation
  - Email sending
  - Logging
  - Customer management
  - Inventory management
  - Reporting

### Open/Closed Principle (OCP)
- Hard-coded tax rates, shipping amounts, and business rules
- Cannot be extended without modifying existing code

### Liskov Substitution Principle (LSP)
- No inheritance hierarchy, but if there were, subclasses would likely violate contracts

### Interface Segregation Principle (ISP)
- No interfaces defined, but if there were, they would be fat interfaces

### Dependency Inversion Principle (DIP)
- Direct dependency on PostgreSQL database
- No abstractions for external dependencies

## Exercise Instructions

1. Identify all SOLID principle violations
2. Refactor the code to follow SOLID principles
3. Create proper abstractions and interfaces
4. Separate concerns into focused classes
5. Implement dependency injection
6. Make the system extensible without modification

## Database Schema

The application uses the following tables:
- `customers` - Customer information
- `products` - Product catalog
- `orders` - Order records
- `order_items` - Order line items
- `invoices` - Invoice records
