1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/06-customer-module","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"06-customer-module\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T6288,<h1>Customer Module - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns">Modules and Separation of Concerns</a></p>
<p><strong>Navigation</strong>: <a href="./05-pricing-service.md">← Previous: Pricing Service</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Customer Module with Separation of Concerns
# File: 2-Domain-Driven-Design/code-samples/python/06-customer-module.py

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any
from dataclasses import dataclass, field
from datetime import datetime
import uuid

# ✅ GOOD: Customer Module - Well-Organized Domain Layer
class CustomerModule:
    &quot;&quot;&quot;Customer module containing all customer-related domain logic&quot;&quot;&quot;
    
    def __init__(self):
        self._customer_repository = CustomerRepository()
        self._email_service = EmailService()
        self._customer_service = CustomerService(
            self._customer_repository,
            self._email_service
        )
        self._customer_factory = CustomerFactory()
        self._customer_specification = CustomerSpecification()
    
    def register_customer(self, name: str, email: str) -&gt; &#39;Customer&#39;:
        &quot;&quot;&quot;Register a new customer&quot;&quot;&quot;
        return self._customer_service.register_customer(name, email)
    
    def activate_customer(self, customer_id: str) -&gt; None:
        &quot;&quot;&quot;Activate a customer&quot;&quot;&quot;
        customer = self._customer_repository.find_by_id(customer_id)
        if customer:
            customer.activate()
            self._customer_repository.save(customer)
    
    def deactivate_customer(self, customer_id: str) -&gt; None:
        &quot;&quot;&quot;Deactivate a customer&quot;&quot;&quot;
        customer = self._customer_repository.find_by_id(customer_id)
        if customer:
            customer.deactivate()
            self._customer_repository.save(customer)
    
    def get_customer_info(self, customer_id: str) -&gt; Optional[Dict[str, Any]]:
        &quot;&quot;&quot;Get customer information&quot;&quot;&quot;
        customer = self._customer_repository.find_by_id(customer_id)
        if customer:
            return {
                &#39;id&#39;: customer.id.value,
                &#39;name&#39;: customer.name,
                &#39;email&#39;: customer.email.value,
                &#39;status&#39;: customer.status.value,
                &#39;created_at&#39;: customer.created_at.isoformat(),
                &#39;is_active&#39;: customer.is_active()
            }
        return None

# ✅ GOOD: Customer Entity
class CustomerStatus(Enum):
    PENDING = &quot;Pending&quot;
    ACTIVE = &quot;Active&quot;
    SUSPENDED = &quot;Suspended&quot;
    INACTIVE = &quot;Inactive&quot;

@dataclass(frozen=True)
class CustomerId:
    &quot;&quot;&quot;Value object for Customer identity&quot;&quot;&quot;
    value: str
    
    @classmethod
    def generate(cls) -&gt; &#39;CustomerId&#39;:
        return cls(str(uuid.uuid4()))
    
    def __str__(self) -&gt; str:
        return self.value

@dataclass(frozen=True)
class EmailAddress:
    &quot;&quot;&quot;Value object for email address&quot;&quot;&quot;
    value: str
    
    def __post_init__(self):
        if not self._is_valid_email(self.value):
            raise ValueError(f&quot;Invalid email address: {self.value}&quot;)
    
    def _is_valid_email(self, email: str) -&gt; bool:
        import re
        pattern = r&#39;^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$&#39;
        return re.match(pattern, email) is not None
    
    def __str__(self) -&gt; str:
        return self.value

class Customer:
    &quot;&quot;&quot;Customer entity with rich behavior&quot;&quot;&quot;
    
    def __init__(
        self,
        customer_id: CustomerId,
        name: str,
        email: EmailAddress,
        created_at: Optional[datetime] = None
    ):
        self._id = customer_id
        self._name = name
        self._email = email
        self._created_at = created_at or datetime.utcnow()
        self._status = CustomerStatus.PENDING
        self._last_activity = None
        self._orders_count = 0
        self._total_spent = Money(0, &#39;USD&#39;)
    
    # Identity properties
    @property
    def id(self) -&gt; CustomerId:
        return self._id
    
    @property
    def name(self) -&gt; str:
        return self._name
    
    @property
    def email(self) -&gt; EmailAddress:
        return self._email
    
    @property
    def created_at(self) -&gt; datetime:
        return self._created_at
    
    @property
    def status(self) -&gt; CustomerStatus:
        return self._status
    
    @property
    def last_activity(self) -&gt; Optional[datetime]:
        return self._last_activity
    
    @property
    def orders_count(self) -&gt; int:
        return self._orders_count
    
    @property
    def total_spent(self) -&gt; Money:
        return self._total_spent
    
    # Business operations
    def activate(self) -&gt; None:
        &quot;&quot;&quot;Activate the customer&quot;&quot;&quot;
        if self._status == CustomerStatus.SUSPENDED:
            raise ValueError(&quot;Cannot activate suspended customer&quot;)
        self._status = CustomerStatus.ACTIVE
        self._last_activity = datetime.utcnow()
    
    def deactivate(self) -&gt; None:
        &quot;&quot;&quot;Deactivate the customer&quot;&quot;&quot;
        self._status = CustomerStatus.INACTIVE
        self._last_activity = datetime.utcnow()
    
    def suspend(self) -&gt; None:
        &quot;&quot;&quot;Suspend the customer&quot;&quot;&quot;
        self._status = CustomerStatus.SUSPENDED
        self._last_activity = datetime.utcnow()
    
    def update_email(self, new_email: EmailAddress) -&gt; None:
        &quot;&quot;&quot;Update customer email&quot;&quot;&quot;
        if self._status == CustomerStatus.SUSPENDED:
            raise ValueError(&quot;Cannot update email for suspended customer&quot;)
        self._email = new_email
        self._last_activity = datetime.utcnow()
    
    def update_name(self, new_name: str) -&gt; None:
        &quot;&quot;&quot;Update customer name&quot;&quot;&quot;
        if not new_name or not new_name.strip():
            raise ValueError(&quot;Name cannot be empty&quot;)
        self._name = new_name.strip()
        self._last_activity = datetime.utcnow()
    
    def record_order(self, order_amount: Money) -&gt; None:
        &quot;&quot;&quot;Record a new order&quot;&quot;&quot;
        if self._status != CustomerStatus.ACTIVE:
            raise ValueError(&quot;Only active customers can place orders&quot;)
        self._orders_count += 1
        self._total_spent = self._total_spent.add(order_amount)
        self._last_activity = datetime.utcnow()
    
    # Business rules
    def is_active(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer is active&quot;&quot;&quot;
        return self._status == CustomerStatus.ACTIVE
    
    def can_place_orders(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer can place orders&quot;&quot;&quot;
        return self._status == CustomerStatus.ACTIVE
    
    def is_vip(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer is VIP&quot;&quot;&quot;
        return self._total_spent.amount &gt;= 1000
    
    def is_premium(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer is premium&quot;&quot;&quot;
        return self._total_spent.amount &gt;= 500
    
    def get_customer_type(self) -&gt; str:
        &quot;&quot;&quot;Get customer type based on spending&quot;&quot;&quot;
        if self.is_vip():
            return &#39;VIP&#39;
        elif self.is_premium():
            return &#39;Premium&#39;
        else:
            return &#39;Standard&#39;
    
    def __str__(self) -&gt; str:
        return f&quot;Customer(id={self._id}, name={self._name}, email={self._email}, status={self._status.value})&quot;

# ✅ GOOD: Customer Repository Interface
class CustomerRepository(ABC):
    &quot;&quot;&quot;Abstract base class for customer repository&quot;&quot;&quot;
    
    @abstractmethod
    def find_by_id(self, customer_id: str) -&gt; Optional[Customer]:
        &quot;&quot;&quot;Find customer by ID&quot;&quot;&quot;
        pass
    
    @abstractmethod
    def find_by_email(self, email: str) -&gt; Optional[Customer]:
        &quot;&quot;&quot;Find customer by email&quot;&quot;&quot;
        pass
    
    @abstractmethod
    def save(self, customer: Customer) -&gt; None:
        &quot;&quot;&quot;Save customer&quot;&quot;&quot;
        pass
    
    @abstractmethod
    def delete(self, customer_id: str) -&gt; None:
        &quot;&quot;&quot;Delete customer&quot;&quot;&quot;
        pass
    
    @abstractmethod
    def find_all(self) -&gt; List[Customer]:
        &quot;&quot;&quot;Find all customers&quot;&quot;&quot;
        pass

# ✅ GOOD: In-Memory Customer Repository Implementation
class InMemoryCustomerRepository(CustomerRepository):
    &quot;&quot;&quot;In-memory implementation of customer repository&quot;&quot;&quot;
    
    def __init__(self):
        self._customers: Dict[str, Customer] = {}
    
    def find_by_id(self, customer_id: str) -&gt; Optional[Customer]:
        return self._customers.get(customer_id)
    
    def find_by_email(self, email: str) -&gt; Optional[Customer]:
        for customer in self._customers.values():
            if customer.email.value == email:
                return customer
        return None
    
    def save(self, customer: Customer) -&gt; None:
        self._customers[customer.id.value] = customer
    
    def delete(self, customer_id: str) -&gt; None:
        if customer_id in self._customers:
            del self._customers[customer_id]
    
    def find_all(self) -&gt; List[Customer]:
        return list(self._customers.values())

# ✅ GOOD: Customer Service
class CustomerService:
    &quot;&quot;&quot;Domain service for customer operations&quot;&quot;&quot;
    
    def __init__(self, repository: CustomerRepository, email_service: &#39;EmailService&#39;):
        self._repository = repository
        self._email_service = email_service
    
    def register_customer(self, name: str, email: str) -&gt; Customer:
        &quot;&quot;&quot;Register a new customer&quot;&quot;&quot;
        # Validate input
        if not name or not name.strip():
            raise ValueError(&quot;Name cannot be empty&quot;)
        
        # Check if customer already exists
        existing_customer = self._repository.find_by_email(email)
        if existing_customer:
            raise ValueError(&quot;Customer with this email already exists&quot;)
        
        # Create new customer
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name.strip(), email_address)
        
        # Activate customer
        customer.activate()
        
        # Save customer
        self._repository.save(customer)
        
        # Send welcome email
        self._email_service.send_welcome_email(customer)
        
        return customer
    
    def update_customer_email(self, customer_id: str, new_email: str) -&gt; None:
        &quot;&quot;&quot;Update customer email&quot;&quot;&quot;
        customer = self._repository.find_by_id(customer_id)
        if not customer:
            raise ValueError(&quot;Customer not found&quot;)
        
        # Check if new email already exists
        existing_customer = self._repository.find_by_email(new_email)
        if existing_customer and existing_customer.id != customer.id:
            raise ValueError(&quot;Email already in use&quot;)
        
        # Update email
        new_email_address = EmailAddress(new_email)
        customer.update_email(new_email_address)
        
        # Save changes
        self._repository.save(customer)
        
        # Send email change notification
        self._email_service.send_email_change_notification(customer)
    
    def suspend_customer(self, customer_id: str, reason: str) -&gt; None:
        &quot;&quot;&quot;Suspend a customer&quot;&quot;&quot;
        customer = self._repository.find_by_id(customer_id)
        if not customer:
            raise ValueError(&quot;Customer not found&quot;)
        
        customer.suspend()
        self._repository.save(customer)
        
        # Send suspension notification
        self._email_service.send_suspension_notification(customer, reason)

# ✅ GOOD: Email Service Interface
class EmailService(ABC):
    &quot;&quot;&quot;Abstract base class for email service&quot;&quot;&quot;
    
    @abstractmethod
    def send_welcome_email(self, customer: Customer) -&gt; None:
        &quot;&quot;&quot;Send welcome email to customer&quot;&quot;&quot;
        pass
    
    @abstractmethod
    def send_email_change_notification(self, customer: Customer) -&gt; None:
        &quot;&quot;&quot;Send email change notification&quot;&quot;&quot;
        pass
    
    @abstractmethod
    def send_suspension_notification(self, customer: Customer, reason: str) -&gt; None:
        &quot;&quot;&quot;Send suspension notification&quot;&quot;&quot;
        pass

# ✅ GOOD: Mock Email Service Implementation
class MockEmailService(EmailService):
    &quot;&quot;&quot;Mock implementation of email service for testing&quot;&quot;&quot;
    
    def __init__(self):
        self._sent_emails = []
    
    def send_welcome_email(self, customer: Customer) -&gt; None:
        self._sent_emails.append({
            &#39;type&#39;: &#39;welcome&#39;,
            &#39;customer_id&#39;: customer.id.value,
            &#39;email&#39;: customer.email.value,
            &#39;timestamp&#39;: datetime.utcnow()
        })
    
    def send_email_change_notification(self, customer: Customer) -&gt; None:
        self._sent_emails.append({
            &#39;type&#39;: &#39;email_change&#39;,
            &#39;customer_id&#39;: customer.id.value,
            &#39;email&#39;: customer.email.value,
            &#39;timestamp&#39;: datetime.utcnow()
        })
    
    def send_suspension_notification(self, customer: Customer, reason: str) -&gt; None:
        self._sent_emails.append({
            &#39;type&#39;: &#39;suspension&#39;,
            &#39;customer_id&#39;: customer.id.value,
            &#39;email&#39;: customer.email.value,
            &#39;reason&#39;: reason,
            &#39;timestamp&#39;: datetime.utcnow()
        })
    
    def get_sent_emails(self) -&gt; List[Dict[str, Any]]:
        return self._sent_emails.copy()

# ✅ GOOD: Customer Factory
class CustomerFactory:
    &quot;&quot;&quot;Factory for creating customers with different strategies&quot;&quot;&quot;
    
    @staticmethod
    def create_standard_customer(name: str, email: str) -&gt; Customer:
        &quot;&quot;&quot;Create a standard customer&quot;&quot;&quot;
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name, email_address)
        customer.activate()
        return customer
    
    @staticmethod
    def create_vip_customer(name: str, email: str) -&gt; Customer:
        &quot;&quot;&quot;Create a VIP customer&quot;&quot;&quot;
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name, email_address)
        customer.activate()
        # VIP customers start with some benefits
        customer._total_spent = Money(1000, &#39;USD&#39;)  # Start as VIP
        return customer
    
    @staticmethod
    def create_customer_from_data(data: Dict[str, Any]) -&gt; Customer:
        &quot;&quot;&quot;Create customer from data dictionary&quot;&quot;&quot;
        customer_id = CustomerId(data[&#39;id&#39;])
        email_address = EmailAddress(data[&#39;email&#39;])
        customer = Customer(customer_id, data[&#39;name&#39;], email_address)
        
        # Set status
        if data.get(&#39;status&#39;) == &#39;Active&#39;:
            customer.activate()
        elif data.get(&#39;status&#39;) == &#39;Suspended&#39;:
            customer.suspend()
        elif data.get(&#39;status&#39;) == &#39;Inactive&#39;:
            customer.deactivate()
        
        return customer

# ✅ GOOD: Customer Specification
class CustomerSpecification:
    &quot;&quot;&quot;Specification for customer-related business rules&quot;&quot;&quot;
    
    def is_eligible_for_vip(self, customer: Customer) -&gt; bool:
        &quot;&quot;&quot;Check if customer is eligible for VIP status&quot;&quot;&quot;
        return (customer.is_active() and
                customer.total_spent.amount &gt;= 1000 and
                customer.orders_count &gt;= 10)
    
    def is_eligible_for_premium(self, customer: Customer) -&gt; bool:
        &quot;&quot;&quot;Check if customer is eligible for premium status&quot;&quot;&quot;
        return (customer.is_active() and
                customer.total_spent.amount &gt;= 500 and
                customer.orders_count &gt;= 5)
    
    def can_be_suspended(self, customer: Customer) -&gt; bool:
        &quot;&quot;&quot;Check if customer can be suspended&quot;&quot;&quot;
        return customer.status in [CustomerStatus.ACTIVE, CustomerStatus.PENDING]
    
    def is_inactive_for_too_long(self, customer: Customer, days: int = 365) -&gt; bool:
        &quot;&quot;&quot;Check if customer has been inactive for too long&quot;&quot;&quot;
        if not customer.last_activity:
            return True
        
        days_since_activity = (datetime.utcnow() - customer.last_activity).days
        return days_since_activity &gt; days
    
    def meets_minimum_requirements(self, customer: Customer) -&gt; bool:
        &quot;&quot;&quot;Check if customer meets minimum requirements&quot;&quot;&quot;
        return (customer.name and
                customer.email and
                customer.status != CustomerStatus.SUSPENDED)

# ✅ GOOD: Customer Module Configuration
class CustomerModuleConfig:
    &quot;&quot;&quot;Configuration for customer module&quot;&quot;&quot;
    
    def __init__(self):
        self.vip_threshold = 1000.0
        self.premium_threshold = 500.0
        self.inactive_threshold_days = 365
        self.max_orders_per_day = 10
        self.auto_suspend_threshold = 5  # failed login attempts
    
    def get_customer_type_thresholds(self) -&gt; Dict[str, float]:
        &quot;&quot;&quot;Get customer type thresholds&quot;&quot;&quot;
        return {
            &#39;VIP&#39;: self.vip_threshold,
            &#39;Premium&#39;: self.premium_threshold,
            &#39;Standard&#39;: 0.0
        }

# ❌ BAD: Anemic Customer Module
class BadCustomerModule:
    &quot;&quot;&quot;Example of anemic customer module - only data, no behavior&quot;&quot;&quot;
    
    def __init__(self):
        self.customers = []
        self.email_service = None
        self.repository = None
    
    def add_customer(self, name: str, email: str):
        # ❌ Business logic scattered, no domain concepts
        customer = {
            &#39;id&#39;: str(uuid.uuid4()),
            &#39;name&#39;: name,
            &#39;email&#39;: email,
            &#39;status&#39;: &#39;Pending&#39;
        }
        self.customers.append(customer)
        return customer

# ❌ BAD: Module with External Dependencies
class BadCustomerModuleWithDependencies:
    &quot;&quot;&quot;Example of module with external dependencies&quot;&quot;&quot;
    
    def __init__(self, database, cache, logger):
        self.database = database  # ❌ External dependency
        self.cache = cache        # ❌ External dependency
        self.logger = logger      # ❌ External dependency
    
    def create_customer(self, data):
        # ❌ Business logic mixed with infrastructure concerns
        self.logger.info(&quot;Creating customer&quot;)
        result = self.database.insert(data)
        self.cache.set(f&quot;customer:{data[&#39;id&#39;]}&quot;, data)
        return result

# Example usage
if __name__ == &quot;__main__&quot;:
    # Create customer module
    customer_module = CustomerModule()
    
    try:
        # Register a new customer
        customer = customer_module.register_customer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;)
        print(f&quot;Customer registered: {customer}&quot;)
        
        # Get customer info
        customer_info = customer_module.get_customer_info(customer.id.value)
        print(f&quot;Customer info: {customer_info}&quot;)
        
        # Activate customer
        customer_module.activate_customer(customer.id.value)
        print(f&quot;Customer activated: {customer.is_active()}&quot;)
        
        # Update customer email
        customer_service = customer_module._customer_service
        customer_service.update_customer_email(customer.id.value, &quot;john.doe.new@example.com&quot;)
        print(f&quot;Email updated: {customer.email}&quot;)
        
    except ValueError as e:
        print(f&quot;Error: {e}&quot;)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Modules and Separation of Concerns</h3>
<h4>1. <strong>Module Organization</strong></h4>
<ul>
<li>✅ Customer module contains all customer-related domain logic</li>
<li>✅ Clear separation of concerns within the module</li>
<li>✅ Module has a single responsibility</li>
</ul>
<h4>2. <strong>Domain Layer Structure</strong></h4>
<ul>
<li>✅ Entities, value objects, and services are organized</li>
<li>✅ Repository interfaces define data access contracts</li>
<li>✅ Domain services handle complex business logic</li>
</ul>
<h4>3. <strong>Dependency Management</strong></h4>
<ul>
<li>✅ Module depends on abstractions, not concrete implementations</li>
<li>✅ Dependencies are injected through constructor</li>
<li>✅ Easy to test and maintain</li>
</ul>
<h4>4. <strong>Module Interface</strong></h4>
<ul>
<li>✅ Module provides a clean interface to the outside world</li>
<li>✅ Complex operations are encapsulated</li>
<li>✅ Module hides internal complexity</li>
</ul>
<h3>Customer Module Design Principles</h3>
<h4><strong>Single Responsibility</strong></h4>
<ul>
<li>✅ Customer module only handles customer-related operations</li>
<li>✅ Each class within the module has a single responsibility</li>
<li>✅ Clear separation of concerns</li>
</ul>
<h4><strong>Dependency Inversion</strong></h4>
<ul>
<li>✅ Module depends on abstractions, not concrete implementations</li>
<li>✅ Repository and service interfaces define contracts</li>
<li>✅ Easy to swap implementations</li>
</ul>
<h4><strong>Domain-Driven Design</strong></h4>
<ul>
<li>✅ Module is organized around domain concepts</li>
<li>✅ Business logic is encapsulated in domain objects</li>
<li>✅ Domain services handle complex operations</li>
</ul>
<h4><strong>Testability</strong></h4>
<ul>
<li>✅ Module can be easily tested in isolation</li>
<li>✅ Dependencies can be mocked</li>
<li>✅ Pure domain logic is testable</li>
</ul>
<h3>Python Benefits for Module Organization</h3>
<ul>
<li><strong>Packages</strong>: Clean module organization with <code>__init__.py</code></li>
<li><strong>Abstract Base Classes</strong>: Clear interfaces for dependencies</li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Dataclasses</strong>: Clean, concise class definitions</li>
<li><strong>Properties</strong>: Clean access to encapsulated data</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Anemic Module</strong></h4>
<ul>
<li>❌ Module contains only data, no behavior</li>
<li>❌ Business logic scattered across multiple classes</li>
<li>❌ No encapsulation of business rules</li>
</ul>
<h4><strong>Module with External Dependencies</strong></h4>
<ul>
<li>❌ Module depends on external frameworks</li>
<li>❌ Business logic mixed with infrastructure concerns</li>
<li>❌ Hard to test and maintain</li>
</ul>
<h4><strong>God Module</strong></h4>
<ul>
<li>❌ Single module with too many responsibilities</li>
<li>❌ Hard to understand and maintain</li>
<li>❌ Violates Single Responsibility Principle</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Basic entity design</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity with business logic</li>
<li><a href="./05-pricing-service.md">Pricing Service</a> - Domain service example</li>
<li><a href="../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns">Modules and Separation of Concerns</a> - Module concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 05-pricing-service.md</li>
<li>Next: 07-order-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns">Modules and Separation of Concerns</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/06-customer-module","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"06-customer-module"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"06-customer-module\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/06-customer-module","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
