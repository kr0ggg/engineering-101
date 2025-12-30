# E-commerce SOLID Principles Exercise

This repository contains intentionally poorly designed e-commerce applications that violate all SOLID principles. The purpose is to provide hands-on practice for engineers to refactor code and apply SOLID principles.

## Languages Included

- **C#** - .NET 8.0 application
- **Java** - Java 11+ application  
- **Python** - Python 3.8+ application
- **TypeScript** - Node.js application

## Database Setup

All applications use PostgreSQL. Start the database with:

```bash
docker-compose up -d
```

This will start:
- PostgreSQL database on port 5432
- Adminer web interface on port 8080

## SOLID Violations Present

Each application intentionally violates all SOLID principles:

### Single Responsibility Principle (SRP)
- **Violation**: `EcommerceManager` class handles multiple responsibilities
- **Responsibilities**: Product management, cart management, order processing, invoice generation, email sending, logging, customer management, inventory management, reporting, payment processing, shipping management, discount calculation, notification management, analytics

### Open/Closed Principle (OCP)
- **Violation**: Hard-coded business rules and logic
- **Examples**: Tax rates, shipping amounts, payment methods, discount codes, notification types
- **Problem**: Cannot extend functionality without modifying existing code

### Liskov Substitution Principle (LSP)
- **Violation**: No proper inheritance hierarchy
- **Problem**: If subclasses existed, they would likely violate base class contracts

### Interface Segregation Principle (ISP)
- **Violation**: No interfaces defined
- **Problem**: If interfaces existed, they would be fat interfaces forcing clients to depend on unused methods

### Dependency Inversion Principle (DIP)
- **Violation**: Direct dependency on concrete implementations
- **Problem**: High-level modules depend on low-level modules (PostgreSQL database)

## Exercise Instructions

1. **Analyze** the code and identify all SOLID principle violations
2. **Refactor** the code to follow SOLID principles:
   - Apply Single Responsibility Principle
   - Make classes open for extension, closed for modification
   - Ensure proper inheritance relationships
   - Create focused, cohesive interfaces
   - Implement dependency inversion
3. **Test** your refactored code to ensure it still works
4. **Compare** your solution with the SOLID principles documentation

## Getting Started

1. Choose your preferred language
2. Navigate to that language's directory
3. Follow the README instructions for that language
4. Start refactoring!

## Learning Objectives

After completing this exercise, you should be able to:
- Identify SOLID principle violations in code
- Apply each SOLID principle correctly
- Design maintainable and extensible software
- Understand the benefits of following SOLID principles
- Recognize code smells and refactoring opportunities

## Database Schema

The applications use these tables:
- `customers` - Customer information
- `products` - Product catalog  
- `orders` - Order records
- `order_items` - Order line items
- `invoices` - Invoice records

Sample data is automatically loaded when the database starts.
