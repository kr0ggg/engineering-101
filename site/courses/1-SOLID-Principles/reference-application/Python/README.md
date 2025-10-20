# E-commerce SOLID Principles Exercise

This Python application demonstrates SOLID principle violations in an e-commerce system.

## Requirements

- Python 3.8+
- PostgreSQL database
- psycopg2-binary

## Installation

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Start the PostgreSQL database using Docker Compose:
```bash
docker-compose up -d
```

3. Run the application:
```bash
python app.py
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
  - Payment processing
  - Shipping management
  - Discount calculation

### Open/Closed Principle (OCP)
- Hard-coded payment methods, shipping calculations, and discount codes
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
