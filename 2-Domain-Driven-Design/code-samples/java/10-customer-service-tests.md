# Customer Service Tests - Java Example

**Section**: [Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection)

**Navigation**: [← Previous: Pricing Service Tests](./09-pricing-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Customer Service Tests (JUnit 5) - Domain Service Testing with Dependency Injection
// File: 2-Domain-Driven-Design/code-samples/java/10-customer-service-tests.java

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

// ✅ GOOD: Comprehensive Customer Service Tests with Dependency Injection
@DisplayName("Customer Service Tests")
class CustomerServiceTest {
    
    private CustomerService customerService;
    private CustomerRepository mockCustomerRepository;
    private EmailService mockEmailService;
    
    @BeforeEach
    void setUp() {
        mockCustomerRepository = mock(CustomerRepository.class);
        mockEmailService = mock(EmailService.class);
        
        customerService = new CustomerService(mockCustomerRepository, mockEmailService);
    }
    
    @Nested
    @DisplayName("Register Customer Tests")
    class RegisterCustomerTests {
        
        @Test
        @DisplayName("Should register customer successfully")
        void shouldRegisterCustomerSuccessfully() {
            // Arrange
            String name = "John Doe";
            String email = "john.doe@example.com";
            
            // Mock repository to return empty for email check
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            // Act
            Customer customer = customerService.registerCustomer(name, email);
            
            // Assert
            assertThat(customer).isNotNull();
            assertThat(customer.getName()).isEqualTo(name);
            assertThat(customer.getEmail().getValue()).isEqualTo(email);
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.PENDING);
            
            // Verify repository was called
            verify(mockCustomerRepository).findByEmail(any(EmailAddress.class));
            verify(mockCustomerRepository).save(customer);
            
            // Verify email service was called
            verify(mockEmailService).sendWelcomeEmail(customer);
        }
        
        @Test
        @DisplayName("Should throw exception when name is empty")
        void shouldThrowExceptionWhenNameIsEmpty() {
            // Arrange
            String name = "";
            String email = "john.doe@example.com";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.registerCustomer(name, email);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when name is null")
        void shouldThrowExceptionWhenNameIsNull() {
            // Arrange
            String name = null;
            String email = "john.doe@example.com";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.registerCustomer(name, email);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when email is invalid")
        void shouldThrowExceptionWhenEmailIsInvalid() {
            // Arrange
            String name = "John Doe";
            String email = "invalid-email";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.registerCustomer(name, email);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when email already exists")
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            // Arrange
            String name = "John Doe";
            String email = "john.doe@example.com";
            
            // Mock repository to return existing customer
            Customer existingCustomer = new Customer(
                CustomerId.generate(), 
                "Jane Doe", 
                EmailAddress.of(email)
            );
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.of(existingCustomer));
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.registerCustomer(name, email);
            });
            
            // Verify repository was called but save was not
            verify(mockCustomerRepository).findByEmail(any(EmailAddress.class));
            verify(mockCustomerRepository, never()).save(any(Customer.class));
        }
        
        @Test
        @DisplayName("Should trim whitespace from name")
        void shouldTrimWhitespaceFromName() {
            // Arrange
            String name = "  John Doe  ";
            String email = "john.doe@example.com";
            
            // Mock repository to return empty for email check
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            // Act
            Customer customer = customerService.registerCustomer(name, email);
            
            // Assert
            assertThat(customer.getName()).isEqualTo("John Doe");
        }
        
        @Test
        @DisplayName("Should normalize email to lowercase")
        void shouldNormalizeEmailToLowercase() {
            // Arrange
            String name = "John Doe";
            String email = "JOHN.DOE@EXAMPLE.COM";
            
            // Mock repository to return empty for email check
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            // Act
            Customer customer = customerService.registerCustomer(name, email);
            
            // Assert
            assertThat(customer.getEmail().getValue()).isEqualTo("john.doe@example.com");
        }
    }
    
    @Nested
    @DisplayName("Update Customer Email Tests")
    class UpdateCustomerEmailTests {
        
        @Test
        @DisplayName("Should update customer email successfully")
        void shouldUpdateCustomerEmailSuccessfully() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String newEmail = "john.doe.new@example.com";
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository to return empty for new email check
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendEmailChangeNotification(any(Customer.class));
            
            // Act
            customerService.updateCustomerEmail(customerId.getValue(), newEmail);
            
            // Assert
            assertThat(customer.getEmail().getValue()).isEqualTo(newEmail);
            
            // Verify repository was called
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository).findByEmail(any(EmailAddress.class));
            verify(mockCustomerRepository).save(customer);
            
            // Verify email service was called
            verify(mockEmailService).sendEmailChangeNotification(customer);
        }
        
        @Test
        @DisplayName("Should throw exception when customer not found")
        void shouldThrowExceptionWhenCustomerNotFound() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String newEmail = "john.doe.new@example.com";
            
            // Mock repository to return empty
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.empty());
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.updateCustomerEmail(customerId.getValue(), newEmail);
            });
            
            // Verify repository was called but save was not
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository, never()).save(any(Customer.class));
        }
        
        @Test
        @DisplayName("Should throw exception when new email already exists")
        void shouldThrowExceptionWhenNewEmailAlreadyExists() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String newEmail = "john.doe.new@example.com";
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            Customer existingCustomer = new Customer(
                CustomerId.generate(), 
                "Jane Doe", 
                EmailAddress.of(newEmail)
            );
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository to return existing customer for new email
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.of(existingCustomer));
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.updateCustomerEmail(customerId.getValue(), newEmail);
            });
            
            // Verify repository was called but save was not
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository).findByEmail(any(EmailAddress.class));
            verify(mockCustomerRepository, never()).save(any(Customer.class));
        }
        
        @Test
        @DisplayName("Should throw exception when new email is invalid")
        void shouldThrowExceptionWhenNewEmailIsInvalid() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String newEmail = "invalid-email";
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.updateCustomerEmail(customerId.getValue(), newEmail);
            });
        }
        
        @Test
        @DisplayName("Should update email for suspended customer")
        void shouldUpdateEmailForSuspendedCustomer() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String newEmail = "john.doe.new@example.com";
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.suspend();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository to return empty for new email check
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendEmailChangeNotification(any(Customer.class));
            
            // Act
            customerService.updateCustomerEmail(customerId.getValue(), newEmail);
            
            // Assert
            assertThat(customer.getEmail().getValue()).isEqualTo(newEmail);
        }
    }
    
    @Nested
    @DisplayName("Suspend Customer Tests")
    class SuspendCustomerTests {
        
        @Test
        @DisplayName("Should suspend customer successfully")
        void shouldSuspendCustomerSuccessfully() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String reason = "Policy violation";
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendSuspensionNotification(any(Customer.class), anyString());
            
            // Act
            customerService.suspendCustomer(customerId.getValue(), reason);
            
            // Assert
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.SUSPENDED);
            
            // Verify repository was called
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository).save(customer);
            
            // Verify email service was called
            verify(mockEmailService).sendSuspensionNotification(customer, reason);
        }
        
        @Test
        @DisplayName("Should throw exception when customer not found")
        void shouldThrowExceptionWhenCustomerNotFound() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String reason = "Policy violation";
            
            // Mock repository to return empty
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.empty());
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.suspendCustomer(customerId.getValue(), reason);
            });
            
            // Verify repository was called but save was not
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository, never()).save(any(Customer.class));
        }
        
        @Test
        @DisplayName("Should suspend customer with empty reason")
        void shouldSuspendCustomerWithEmptyReason() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            String reason = "";
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendSuspensionNotification(any(Customer.class), anyString());
            
            // Act
            customerService.suspendCustomer(customerId.getValue(), reason);
            
            // Assert
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.SUSPENDED);
        }
    }
    
    @Nested
    @DisplayName("Activate Customer Tests")
    class ActivateCustomerTests {
        
        @Test
        @DisplayName("Should activate customer successfully")
        void shouldActivateCustomerSuccessfully() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.deactivate();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendActivationNotification(any(Customer.class));
            
            // Act
            customerService.activateCustomer(customerId.getValue());
            
            // Assert
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.ACTIVE);
            
            // Verify repository was called
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository).save(customer);
            
            // Verify email service was called
            verify(mockEmailService).sendActivationNotification(customer);
        }
        
        @Test
        @DisplayName("Should throw exception when customer not found")
        void shouldThrowExceptionWhenCustomerNotFound() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            
            // Mock repository to return empty
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.empty());
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.activateCustomer(customerId.getValue());
            });
            
            // Verify repository was called but save was not
            verify(mockCustomerRepository).findById(customerId);
            verify(mockCustomerRepository, never()).save(any(Customer.class));
        }
        
        @Test
        @DisplayName("Should activate suspended customer")
        void shouldActivateSuspendedCustomer() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.suspend();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendActivationNotification(any(Customer.class));
            
            // Act
            customerService.activateCustomer(customerId.getValue());
            
            // Assert
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.ACTIVE);
        }
    }
    
    @Nested
    @DisplayName("Get Customer Tests")
    class GetCustomerTests {
        
        @Test
        @DisplayName("Should get customer successfully")
        void shouldGetCustomerSuccessfully() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Mock repository to return customer
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Act
            Customer result = customerService.getCustomer(customerId.getValue());
            
            // Assert
            assertThat(result).isNotNull();
            assertThat(result.getId()).isEqualTo(customerId);
            assertThat(result.getName()).isEqualTo("John Doe");
            assertThat(result.getEmail().getValue()).isEqualTo("john.doe@example.com");
            assertThat(result.getStatus()).isEqualTo(CustomerStatus.ACTIVE);
            
            // Verify repository was called
            verify(mockCustomerRepository).findById(customerId);
        }
        
        @Test
        @DisplayName("Should throw exception when customer not found")
        void shouldThrowExceptionWhenCustomerNotFound() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            
            // Mock repository to return empty
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.empty());
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.getCustomer(customerId.getValue());
            });
            
            // Verify repository was called
            verify(mockCustomerRepository).findById(customerId);
        }
    }
    
    @Nested
    @DisplayName("Get Active Customers Tests")
    class GetActiveCustomersTests {
        
        @Test
        @DisplayName("Should get active customers successfully")
        void shouldGetActiveCustomersSuccessfully() {
            // Arrange
            Customer customer1 = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
            customer1.activate();
            
            Customer customer2 = new Customer(CustomerId.generate(), "Jane Doe", EmailAddress.of("jane.doe@example.com"));
            customer2.activate();
            
            List<Customer> activeCustomers = List.of(customer1, customer2);
            
            // Mock repository to return active customers
            when(mockCustomerRepository.findByStatus(CustomerStatus.ACTIVE))
                .thenReturn(activeCustomers);
            
            // Act
            List<Customer> result = customerService.getActiveCustomers();
            
            // Assert
            assertThat(result).isNotNull();
            assertThat(result).hasSize(2);
            assertThat(result).containsExactlyInAnyOrder(customer1, customer2);
            
            // Verify repository was called
            verify(mockCustomerRepository).findByStatus(CustomerStatus.ACTIVE);
        }
        
        @Test
        @DisplayName("Should return empty list when no active customers")
        void shouldReturnEmptyListWhenNoActiveCustomers() {
            // Arrange
            List<Customer> emptyList = List.of();
            
            // Mock repository to return empty list
            when(mockCustomerRepository.findByStatus(CustomerStatus.ACTIVE))
                .thenReturn(emptyList);
            
            // Act
            List<Customer> result = customerService.getActiveCustomers();
            
            // Assert
            assertThat(result).isNotNull();
            assertThat(result).isEmpty();
            
            // Verify repository was called
            verify(mockCustomerRepository).findByStatus(CustomerStatus.ACTIVE);
        }
    }
    
    @Nested
    @DisplayName("Get VIP Customers Tests")
    class GetVipCustomersTests {
        
        @Test
        @DisplayName("Should get VIP customers successfully")
        void shouldGetVipCustomersSuccessfully() {
            // Arrange
            Customer customer1 = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
            customer1.activate();
            customer1.recordOrder(Money.of(1000, "USD")); // Make VIP
            
            Customer customer2 = new Customer(CustomerId.generate(), "Jane Doe", EmailAddress.of("jane.doe@example.com"));
            customer2.activate();
            customer2.recordOrder(Money.of(1500, "USD")); // Make VIP
            
            List<Customer> vipCustomers = List.of(customer1, customer2);
            
            // Mock repository to return VIP customers
            when(mockCustomerRepository.findVipCustomers())
                .thenReturn(vipCustomers);
            
            // Act
            List<Customer> result = customerService.getVipCustomers();
            
            // Assert
            assertThat(result).isNotNull();
            assertThat(result).hasSize(2);
            assertThat(result).containsExactlyInAnyOrder(customer1, customer2);
            
            // Verify repository was called
            verify(mockCustomerRepository).findVipCustomers();
        }
        
        @Test
        @DisplayName("Should return empty list when no VIP customers")
        void shouldReturnEmptyListWhenNoVipCustomers() {
            // Arrange
            List<Customer> emptyList = List.of();
            
            // Mock repository to return empty list
            when(mockCustomerRepository.findVipCustomers())
                .thenReturn(emptyList);
            
            // Act
            List<Customer> result = customerService.getVipCustomers();
            
            // Assert
            assertThat(result).isNotNull();
            assertThat(result).isEmpty();
            
            // Verify repository was called
            verify(mockCustomerRepository).findVipCustomers();
        }
    }
    
    @Nested
    @DisplayName("Customer Service Integration Tests")
    class CustomerServiceIntegrationTests {
        
        @Test
        @DisplayName("Should handle complete customer lifecycle")
        void shouldHandleCompleteCustomerLifecycle() {
            // Arrange
            String name = "John Doe";
            String email = "john.doe@example.com";
            
            // Mock repository for registration
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            // Act - Register customer
            Customer customer = customerService.registerCustomer(name, email);
            
            // Assert - Customer is registered
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.PENDING);
            
            // Mock repository for activation
            when(mockCustomerRepository.findById(customer.getId()))
                .thenReturn(Optional.of(customer));
            doNothing().when(mockEmailService).sendActivationNotification(any(Customer.class));
            
            // Act - Activate customer
            customerService.activateCustomer(customer.getId().getValue());
            
            // Assert - Customer is activated
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.ACTIVE);
            
            // Mock repository for email update
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockEmailService).sendEmailChangeNotification(any(Customer.class));
            
            // Act - Update email
            String newEmail = "john.doe.new@example.com";
            customerService.updateCustomerEmail(customer.getId().getValue(), newEmail);
            
            // Assert - Email is updated
            assertThat(customer.getEmail().getValue()).isEqualTo(newEmail);
            
            // Mock repository for suspension
            doNothing().when(mockEmailService).sendSuspensionNotification(any(Customer.class), anyString());
            
            // Act - Suspend customer
            customerService.suspendCustomer(customer.getId().getValue(), "Policy violation");
            
            // Assert - Customer is suspended
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.SUSPENDED);
        }
        
        @Test
        @DisplayName("Should handle customer with multiple orders")
        void shouldHandleCustomerWithMultipleOrders() {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            customer.activate();
            
            // Mock repository
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Act - Record multiple orders
            customer.recordOrder(Money.of(100, "USD"));
            customer.recordOrder(Money.of(200, "USD"));
            customer.recordOrder(Money.of(300, "USD"));
            
            // Assert - Customer is VIP
            assertThat(customer.isVip()).isTrue();
            assertThat(customer.getCustomerType()).isEqualTo("VIP");
            assertThat(customer.getOrdersCount()).isEqualTo(3);
            assertThat(customer.getTotalSpent()).isEqualTo(Money.of(600, "USD"));
        }
    }
    
    @Nested
    @DisplayName("Customer Service Parameterized Tests")
    class CustomerServiceParameterizedTests {
        
        @ParameterizedTest
        @ValueSource(strings = {"", "   ", "a", "John", "John Doe", "John Michael Doe"})
        @DisplayName("Should register customer with different names")
        void shouldRegisterCustomerWithDifferentNames(String name) {
            // Arrange
            String email = "john.doe@example.com";
            
            // Mock repository to return empty for email check
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            
            // Mock repository save method
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            // Act & Assert
            if (name.trim().isEmpty()) {
                assertThrows(IllegalArgumentException.class, () -> {
                    customerService.registerCustomer(name, email);
                });
            } else {
                Customer customer = customerService.registerCustomer(name, email);
                assertThat(customer.getName()).isEqualTo(name.trim());
            }
        }
        
        @ParameterizedTest
        @CsvSource({
            "john.doe@example.com, true",
            "JOHN.DOE@EXAMPLE.COM, true",
            "invalid-email, false",
            "john@, false",
            "@example.com, false",
            "john.doe@, false"
        })
        @DisplayName("Should validate email addresses")
        void shouldValidateEmailAddresses(String email, boolean isValid) {
            // Arrange
            String name = "John Doe";
            
            if (isValid) {
                // Mock repository to return empty for email check
                when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                    .thenReturn(Optional.empty());
                
                // Mock repository save method
                doNothing().when(mockCustomerRepository).save(any(Customer.class));
                
                // Mock email service
                doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            }
            
            // Act & Assert
            if (isValid) {
                Customer customer = customerService.registerCustomer(name, email);
                assertThat(customer.getEmail().getValue()).isEqualTo(email.toLowerCase());
            } else {
                assertThrows(IllegalArgumentException.class, () -> {
                    customerService.registerCustomer(name, email);
                });
            }
        }
        
        @ParameterizedTest
        @CsvSource({
            "PENDING, false",
            "ACTIVE, true",
            "INACTIVE, false",
            "SUSPENDED, false"
        })
        @DisplayName("Should handle different customer statuses")
        void shouldHandleDifferentCustomerStatuses(String status, boolean canPlaceOrders) {
            // Arrange
            CustomerId customerId = CustomerId.generate();
            Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
            
            // Set status
            switch (status) {
                case "PENDING":
                    // Default status
                    break;
                case "ACTIVE":
                    customer.activate();
                    break;
                case "INACTIVE":
                    customer.deactivate();
                    break;
                case "SUSPENDED":
                    customer.suspend();
                    break;
            }
            
            // Mock repository
            when(mockCustomerRepository.findById(customerId))
                .thenReturn(Optional.of(customer));
            
            // Act
            Customer result = customerService.getCustomer(customerId.getValue());
            
            // Assert
            assertThat(result.getStatus().toString()).isEqualTo(status);
            assertThat(result.canPlaceOrders()).isEqualTo(canPlaceOrders);
        }
    }
    
    @Nested
    @DisplayName("Customer Service Error Handling Tests")
    class CustomerServiceErrorHandlingTests {
        
        @Test
        @DisplayName("Should handle repository errors gracefully")
        void shouldHandleRepositoryErrorsGracefully() {
            // Arrange
            String name = "John Doe";
            String email = "john.doe@example.com";
            
            // Mock repository to throw exception
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenThrow(new RuntimeException("Database connection failed"));
            
            // Act & Assert
            assertThrows(RuntimeException.class, () -> {
                customerService.registerCustomer(name, email);
            });
        }
        
        @Test
        @DisplayName("Should handle email service errors gracefully")
        void shouldHandleEmailServiceErrorsGracefully() {
            // Arrange
            String name = "John Doe";
            String email = "john.doe@example.com";
            
            // Mock repository
            when(mockCustomerRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockCustomerRepository).save(any(Customer.class));
            
            // Mock email service to throw exception
            doThrow(new RuntimeException("Email service unavailable"))
                .when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            // Act & Assert
            assertThrows(RuntimeException.class, () -> {
                customerService.registerCustomer(name, email);
            });
        }
        
        @Test
        @DisplayName("Should handle invalid customer ID format")
        void shouldHandleInvalidCustomerIdFormat() {
            // Arrange
            String invalidCustomerId = "invalid-id";
            String newEmail = "john.doe.new@example.com";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                customerService.updateCustomerEmail(invalidCustomerId, newEmail);
            });
        }
    }
}

// Example usage
public class CustomerServiceTestExample {
    public static void main(String[] args) {
        // Create customer service
        CustomerRepository customerRepository = new InMemoryCustomerRepository();
        EmailService emailService = new ConsoleEmailService();
        CustomerService customerService = new CustomerService(customerRepository, emailService);
        
        // Register customer
        Customer customer = customerService.registerCustomer("John Doe", "john.doe@example.com");
        System.out.println("Customer registered: " + customer);
        
        // Activate customer
        customerService.activateCustomer(customer.getId().getValue());
        System.out.println("Customer activated: " + customer);
        
        // Update email
        customerService.updateCustomerEmail(customer.getId().getValue(), "john.doe.new@example.com");
        System.out.println("Email updated: " + customer);
        
        // Get customer
        Customer retrievedCustomer = customerService.getCustomer(customer.getId().getValue());
        System.out.println("Retrieved customer: " + retrievedCustomer);
        
        // Get active customers
        List<Customer> activeCustomers = customerService.getActiveCustomers();
        System.out.println("Active customers: " + activeCustomers.size());
        
        // Get VIP customers
        List<Customer> vipCustomers = customerService.getVipCustomers();
        System.out.println("VIP customers: " + vipCustomers.size());
    }
}
```

## Key Concepts Demonstrated

### Isolated Testing with Dependency Injection

#### 1. **Dependency Injection Testing**
- ✅ Dependencies are injected through constructor
- ✅ Mock objects are used for external dependencies
- ✅ Tests focus on business logic, not infrastructure

#### 2. **Service Behavior Testing**
- ✅ Customer service operations are tested in isolation
- ✅ Business rules are verified through test cases
- ✅ Service interactions are properly mocked

#### 3. **Repository Pattern Testing**
- ✅ Repository interface is mocked for testing
- ✅ Data persistence is abstracted away
- ✅ Tests verify service behavior, not data storage

#### 4. **Email Service Testing**
- ✅ Email notifications are mocked
- ✅ Service behavior is tested without sending emails
- ✅ Integration points are properly isolated

### Customer Service Testing Principles

#### **Dependency Injection**
- ✅ Dependencies are injected through constructor
- ✅ Mock objects are used for external dependencies
- ✅ Tests focus on business logic, not infrastructure

#### **Service Behavior Testing**
- ✅ Customer service operations are tested in isolation
- ✅ Business rules are verified through test cases
- ✅ Service interactions are properly mocked

#### **Repository Pattern Testing**
- ✅ Repository interface is mocked for testing
- ✅ Data persistence is abstracted away
- ✅ Tests verify service behavior, not data storage

#### **Email Service Testing**
- ✅ Email notifications are mocked
- ✅ Service behavior is tested without sending emails
- ✅ Integration points are properly isolated

### Java Testing Benefits
- **JUnit 5**: Modern testing framework with annotations
- **Mockito**: Powerful mocking framework
- **AssertJ**: Fluent assertions for better readability
- **Parameterized Tests**: Test multiple scenarios efficiently
- **Nested Tests**: Organize tests by functionality
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Testing Implementation Details**
- ❌ Tests that verify internal implementation
- ❌ Tests that break when implementation changes
- ❌ Tests that don't verify business behavior

#### **Over-Mocking**
- ❌ Mocking everything instead of testing real behavior
- ❌ Tests that don't verify actual business logic
- ❌ Tests that are hard to maintain

#### **Incomplete Test Coverage**
- ❌ Tests that don't cover all business rules
- ❌ Tests that miss edge cases
- ❌ Tests that don't verify error conditions

## Related Concepts

- [Customer Module](./06-customer-module.md) - Module being tested
- [Order Tests](./07-order-tests.md) - Tests that use Customer Service
- [Pricing Service Tests](./09-pricing-service-tests.md) - Tests for Pricing Service
- [Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection) - Testing concepts

/*
 * Navigation:
 * Previous: 09-pricing-service-tests.md
 * Next: 11-testing-anti-patterns.md
 *
 * Back to: [Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection)
 */
