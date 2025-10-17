# Customer Module - C# Example

**Section**: [Modules and Separation of Concerns](../introduction-to-the-domain.md#module-implementation-example)

**Navigation**: [← Previous: Pricing Service](./05-pricing-service.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Order Tests →](./07-order-tests.cs)

---

```csharp
// C# Example - Customer Module
namespace EcommerceApp.Domain.Customer
{
    // Customer Entity
    public class Customer
    {
        public CustomerId Id { get; private set; }
        public string Name { get; private set; }
        public EmailAddress Email { get; private set; }
        public Address Address { get; private set; }
        public CustomerStatus Status { get; private set; }
        public DateTime CreatedAt { get; private set; }
        
        public Customer(CustomerId id, string name, EmailAddress email, Address address)
        {
            Id = id ?? throw new ArgumentNullException(nameof(id));
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Email = email ?? throw new ArgumentNullException(nameof(email));
            Address = address ?? throw new ArgumentNullException(nameof(address));
            Status = CustomerStatus.Active;
            CreatedAt = DateTime.UtcNow;
        }
        
        public void UpdateProfile(string name, EmailAddress email, Address address)
        {
            if (Status != CustomerStatus.Active)
                throw new InvalidOperationException("Cannot update inactive customer");
                
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Email = email ?? throw new ArgumentNullException(nameof(email));
            Address = address ?? throw new ArgumentNullException(nameof(address));
        }
        
        public void Deactivate()
        {
            Status = CustomerStatus.Inactive;
        }
        
        public bool CanPlaceOrder()
        {
            return Status == CustomerStatus.Active;
        }
    }
    
    // Customer Service
    public class CustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly IEmailService _emailService;
        
        public CustomerService(ICustomerRepository customerRepository, IEmailService emailService)
        {
            _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
            _emailService = emailService ?? throw new ArgumentNullException(nameof(emailService));
        }
        
        public async Task<Customer> RegisterCustomer(string name, EmailAddress email, Address address)
        {
            // Check if customer already exists
            var existingCustomer = await _customerRepository.FindByEmail(email);
            if (existingCustomer != null)
            {
                throw new CustomerAlreadyExistsException($"Customer with email {email} already exists");
            }
            
            // Create new customer
            var customerId = CustomerId.Generate();
            var customer = new Customer(customerId, name, email, address);
            
            // Save customer
            await _customerRepository.Save(customer);
            
            // Send welcome email
            await _emailService.SendWelcomeEmail(customer.Email, customer.Name);
            
            return customer;
        }
        
        public async Task<Customer> GetCustomer(CustomerId customerId)
        {
            var customer = await _customerRepository.FindById(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($"Customer with ID {customerId} not found");
            }
            
            return customer;
        }
        
        public async Task UpdateCustomerProfile(CustomerId customerId, string name, EmailAddress email, Address address)
        {
            var customer = await GetCustomer(customerId);
            customer.UpdateProfile(name, email, address);
            await _customerRepository.Save(customer);
        }
    }
}
```

## Key Concepts Demonstrated

- **Module Organization**: Related concepts grouped in namespace
- **High Cohesion**: Customer-related classes grouped together
- **Low Coupling**: Clear interfaces with other modules
- **Domain Service**: CustomerService orchestrates customer operations
- **Repository Pattern**: ICustomerRepository interface for persistence
- **Dependency Injection**: Services injected through constructor

## Module Structure

```
Customer/
├── Customer.cs (Entity)
├── CustomerId.cs (Value Object)
├── CustomerStatus.cs (Enum)
├── CustomerService.cs (Domain Service)
└── ICustomerRepository.cs (Interface)
```

## Module Benefits

1. **Organization**: Related concepts grouped together
2. **Maintainability**: Changes to customer logic are localized
3. **Testability**: Module can be tested independently
4. **Reusability**: Module can be used by other parts of the system
5. **Clarity**: Clear boundaries and responsibilities

## Business Operations

- **Customer Registration**: Creates new customers with validation
- **Profile Updates**: Updates customer information with business rules
- **Customer Retrieval**: Gets customer by ID with error handling
- **Status Management**: Handles customer activation/deactivation

## Related Concepts

- [Customer Entity](./01-customer-entity.cs) - Basic customer entity
- [EmailAddress Value Object](./04-email-address-value-object.cs) - Used in customer
- [Unit Testing](../introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing customer operations
