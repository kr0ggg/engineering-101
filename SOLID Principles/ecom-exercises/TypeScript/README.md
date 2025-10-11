# E-commerce SOLID Principles Exercise

This TypeScript application demonstrates SOLID principle violations in an e-commerce system.

## Requirements

- Node.js 16+
- PostgreSQL database
- pg package

## Installation

1. Install Node.js 16 or higher
2. Install dependencies:
```bash
npm install
```

3. Start the PostgreSQL database using Docker Compose:
```bash
docker-compose up -d
```

4. Run the application:
```bash
npm run dev
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
  - Notification management
  - Analytics

### Open/Closed Principle (OCP)
- Hard-coded payment methods, shipping calculations, discount codes, and notification types
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
