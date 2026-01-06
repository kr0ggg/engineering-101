# Liskov Substitution Principle (LSP) Testing Workshop

## Objective

Learn to identify LSP violations, write contract tests, and ensure derived classes can substitute base classes without breaking functionality.

## Prerequisites

- Complete [OCP Workshop](./02-OCP-WORKSHOP.md)
- Understand inheritance and polymorphism

## The Problem

The `ReadOnlyRepository` violates LSP by throwing exceptions for methods inherited from `Repository`, breaking the contract.

## Workshop Steps

### Step 1: Identify LSP Violation (15 minutes)

**Current Implementation**:
```java
public class Repository<T> {
    public void save(T entity) { /* implementation */ }
    public void delete(int id) { /* implementation */ }
    public T findById(int id) { /* implementation */ }
}

public class ReadOnlyRepository<T> extends Repository<T> {
    @Override
    public void save(T entity) {
        throw new UnsupportedOperationException("Read-only repository");
    }
    
    @Override
    public void delete(int id) {
        throw new UnsupportedOperationException("Read-only repository");
    }
}
```

**Problem**: Clients expecting `Repository` behavior get exceptions.

### Step 2: Write Contract Tests (30 minutes)

Define tests that all repositories must pass:

```java
public abstract class RepositoryContractTest<T, ID> {
    protected abstract Repository<T, ID> createRepository();
    protected abstract T createEntity(ID id);
    protected abstract ID createId();
    protected abstract ID getEntityId(T entity);
    
    @Test
    void save_shouldPersistEntity() {
        Repository<T, ID> repository = createRepository();
        T entity = createEntity(createId());
        
        assertDoesNotThrow(() -> repository.save(entity));
        
        T retrieved = repository.findById(getEntityId(entity));
        assertNotNull(retrieved);
    }
    
    @Test
    void findById_shouldReturnNullWhenNotExists() {
        Repository<T, ID> repository = createRepository();
        ID nonExistentId = createId();
        
        T result = repository.findById(nonExistentId);
        
        assertNull(result);
    }
    
    @Test
    void delete_shouldRemoveEntity() {
        Repository<T, ID> repository = createRepository();
        T entity = createEntity(createId());
        repository.save(entity);
        
        assertDoesNotThrow(() -> repository.delete(getEntityId(entity)));
        
        T retrieved = repository.findById(getEntityId(entity));
        assertNull(retrieved);
    }
}
```

### Step 3: Test Reveals Violation (10 minutes)

```java
class ReadOnlyRepositoryTest extends RepositoryContractTest<Customer, Integer> {
    @Override
    protected Repository<Customer, Integer> createRepository() {
        return new ReadOnlyRepository<>();
    }
    
    // Tests FAIL - save() and delete() throw exceptions!
}
```

### Step 4: Refactor to Fix LSP (45 minutes)

**Solution: Interface Segregation**

```java
public interface IReadRepository<T, ID> {
    T findById(ID id);
    List<T> findAll();
}

public interface IWriteRepository<T, ID> {
    void save(T entity);
    void delete(ID id);
}

public interface IRepository<T, ID> extends IReadRepository<T, ID>, IWriteRepository<T, ID> {
}
```

**Implementations**:
```java
public class CustomerRepository implements IRepository<Customer, Integer> {
    @Override
    public void save(Customer entity) { /* implementation */ }
    
    @Override
    public void delete(Integer id) { /* implementation */ }
    
    @Override
    public Customer findById(Integer id) { /* implementation */ }
    
    @Override
    public List<Customer> findAll() { /* implementation */ }
}

public class ReadOnlyCustomerRepository implements IReadRepository<Customer, Integer> {
    @Override
    public Customer findById(Integer id) { /* implementation */ }
    
    @Override
    public List<Customer> findAll() { /* implementation */ }
}
```

### Step 5: Write New Contract Tests (30 minutes)

**Read Repository Contract**:
```java
public abstract class ReadRepositoryContractTest<T, ID> {
    protected abstract IReadRepository<T, ID> createRepository();
    protected abstract T createEntity(ID id);
    protected abstract ID createId();
    
    @Test
    void findById_shouldReturnEntityWhenExists() {
        IReadRepository<T, ID> repository = createRepository();
        // Assuming entity exists in test data
        T entity = repository.findById(createId());
        assertNotNull(entity);
    }
    
    @Test
    void findById_shouldReturnNullWhenNotExists() {
        IReadRepository<T, ID> repository = createRepository();
        T entity = repository.findById(createId());
        assertNull(entity);
    }
    
    @Test
    void findAll_shouldReturnList() {
        IReadRepository<T, ID> repository = createRepository();
        List<T> entities = repository.findAll();
        assertNotNull(entities);
    }
}
```

**Write Repository Contract**:
```java
public abstract class WriteRepositoryContractTest<T, ID> {
    protected abstract IWriteRepository<T, ID> createRepository();
    protected abstract T createEntity(ID id);
    
    @Test
    void save_shouldNotThrowException() {
        IWriteRepository<T, ID> repository = createRepository();
        T entity = createEntity(null);
        
        assertDoesNotThrow(() -> repository.save(entity));
    }
    
    @Test
    void delete_shouldNotThrowException() {
        IWriteRepository<T, ID> repository = createRepository();
        
        assertDoesNotThrow(() -> repository.delete(createId()));
    }
}
```

### Step 6: Verify All Implementations (20 minutes)

**CustomerRepository Tests**:
```java
class CustomerRepositoryTest extends ReadRepositoryContractTest<Customer, Integer> {
    @Override
    protected IReadRepository<Customer, Integer> createRepository() {
        return new CustomerRepository(mockConnection);
    }
    
    // All contract tests pass
}

class CustomerRepositoryWriteTest extends WriteRepositoryContractTest<Customer, Integer> {
    @Override
    protected IWriteRepository<Customer, Integer> createRepository() {
        return new CustomerRepository(mockConnection);
    }
    
    // All contract tests pass
}
```

**ReadOnlyRepository Tests**:
```java
class ReadOnlyCustomerRepositoryTest extends ReadRepositoryContractTest<Customer, Integer> {
    @Override
    protected IReadRepository<Customer, Integer> createRepository() {
        return new ReadOnlyCustomerRepository(mockConnection);
    }
    
    // All contract tests pass - no write methods to fail!
}
```

### Step 7: Update Client Code (15 minutes)

**Before**:
```java
public class CustomerService {
    private final Repository<Customer, Integer> repository;
    
    public CustomerService(Repository<Customer, Integer> repository) {
        this.repository = repository;
    }
    
    public void displayCustomer(int id) {
        Customer customer = repository.findById(id);
        // Display logic
    }
}
```

**After**:
```java
public class CustomerDisplayService {
    private final IReadRepository<Customer, Integer> repository;
    
    public CustomerDisplayService(IReadRepository<Customer, Integer> repository) {
        this.repository = repository;
    }
    
    public void displayCustomer(int id) {
        Customer customer = repository.findById(id);
        // Display logic - can use ReadOnlyRepository!
    }
}
```

## Comparison

### Before LSP
- ReadOnlyRepository throws exceptions
- Violates base class contract
- Clients must check type before using
- Tests fail for derived classes

### After LSP
- Separate interfaces for read/write
- Each implementation honors its contract
- Clients depend on what they need
- All contract tests pass

## Benefits

- ✅ Derived classes can substitute base classes
- ✅ No unexpected exceptions
- ✅ Clear contracts
- ✅ Easier to test
- ✅ More flexible design

## Assessment Checklist

- [ ] Contract tests defined for each interface
- [ ] All implementations pass contract tests
- [ ] No unexpected exceptions in derived classes
- [ ] Clients use appropriate interfaces
- [ ] Preconditions not strengthened
- [ ] Postconditions not weakened
- [ ] All tests pass

## Next Steps

1. Apply LSP to other inheritance hierarchies
2. Move to [ISP Workshop](./04-ISP-WORKSHOP.md)

---

**Key Takeaway**: LSP ensures derived classes can replace base classes without breaking functionality. Use interface segregation to avoid forcing implementations to violate contracts.
