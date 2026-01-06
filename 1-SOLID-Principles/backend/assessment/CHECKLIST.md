# Backend SOLID Principles Assessment Checklist

## Overview

This checklist helps you assess whether your backend code follows SOLID principles. Use it to validate your work before submitting for review or moving to the next exercise.

**Supported Languages**: C#, Java, Python, TypeScript

## How to Use This Checklist

1. **Select your language** - Focus on language-specific criteria
2. **Complete one principle at a time** - Don't try to assess everything at once
3. **Be honest** - This is for your learning
4. **Review with a peer** - Get feedback from another developer
5. **Iterate** - If you answer "No" to critical items, refactor and reassess

## Scoring Guide

- ✅ **Yes** - Fully implemented
- ⚠️ **Partial** - Partially implemented, needs improvement
- ❌ **No** - Not implemented or incorrect
- N/A - Not applicable to this exercise

**Target Score**: 80% or higher "Yes" responses for critical items

---

## 1. Single Responsibility Principle (SRP)

### Critical Items (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.1 | Each class has a single, well-defined responsibility | ☐ | |
| 1.2 | Each class has only one reason to change | ☐ | |
| 1.3 | Business logic is separated from data access | ☐ | |
| 1.4 | Validation logic is separated from business logic | ☐ | |
| 1.5 | Each method does one thing and does it well | ☐ | |
| 1.6 | Classes are small and focused (< 200 lines) | ☐ | |
| 1.7 | Methods are short and focused (< 20 lines) | ☐ | |

### Repository Pattern (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.8 | Repositories only handle data access | ☐ | |
| 1.9 | No business logic in repositories | ☐ | |
| 1.10 | Repository methods are focused on CRUD operations | ☐ | |

### Service Layer (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.11 | Services only handle business logic | ☐ | |
| 1.12 | Services orchestrate but don't implement details | ☐ | |
| 1.13 | No data access code in services | ☐ | |

### C#-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.14 | Controllers only handle HTTP concerns | ☐ | |
| 1.15 | No business logic in controllers | ☐ | |
| 1.16 | Proper use of async/await for I/O operations | ☐ | |

### Java-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.17 | Controllers/Resources only handle HTTP concerns | ☐ | |
| 1.18 | Proper use of Spring annotations (if using Spring) | ☐ | |
| 1.19 | No business logic in REST controllers | ☐ | |

### Python-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.20 | Routes/views only handle HTTP concerns | ☐ | |
| 1.21 | Proper use of decorators for cross-cutting concerns | ☐ | |
| 1.22 | No business logic in Flask/FastAPI routes | ☐ | |

### TypeScript-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.23 | Controllers/routes only handle HTTP concerns | ☐ | |
| 1.24 | Proper use of TypeScript types and interfaces | ☐ | |
| 1.25 | No business logic in Express routes | ☐ | |

### Testing

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.26 | Each responsibility has its own test suite | ☐ | |
| 1.27 | Tests are focused and test one thing | ☐ | |
| 1.28 | All existing tests still pass | ☐ | |
| 1.29 | New tests added for extracted classes | ☐ | |
| 1.30 | Test coverage > 80% | ☐ | |

### Code Quality

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 1.31 | Class names clearly describe responsibility | ☐ | |
| 1.32 | No "Manager", "Handler", or "Util" classes | ☐ | |
| 1.33 | Dependencies are minimal and focused | ☐ | |
| 1.34 | Code is easier to understand than before | ☐ | |

**SRP Score**: ___/34 (___%)

---

## 2. Open/Closed Principle (OCP)

### Critical Items (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.1 | Can add new features without modifying existing code | ☐ | |
| 2.2 | Uses interfaces/abstractions for extensibility | ☐ | |
| 2.3 | Hard-coded values replaced with configuration | ☐ | |
| 2.4 | Switch statements replaced with polymorphism | ☐ | |
| 2.5 | New behavior added through composition | ☐ | |

### Design Patterns (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.6 | Strategy pattern used for varying algorithms | ☐ | |
| 2.7 | Template method pattern for common workflows | ☐ | |
| 2.8 | Factory pattern for object creation | ☐ | |
| 2.9 | Plugin architecture for extensibility | ☐ | |

### C#-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.10 | Proper use of interfaces and abstract classes | ☐ | |
| 2.11 | Extension methods used appropriately | ☐ | |
| 2.12 | Dependency injection configured correctly | ☐ | |

### Java-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.13 | Proper use of interfaces and abstract classes | ☐ | |
| 2.14 | Annotations used for extensibility | ☐ | |
| 2.15 | Dependency injection configured (Spring/CDI) | ☐ | |

### Python-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.16 | Proper use of abstract base classes (ABC) | ☐ | |
| 2.17 | Protocol classes used for duck typing | ☐ | |
| 2.18 | Decorators used for extensibility | ☐ | |

### TypeScript-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.19 | Proper use of interfaces and abstract classes | ☐ | |
| 2.20 | Type guards used appropriately | ☐ | |
| 2.21 | Generics used for reusability | ☐ | |

### Testing

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 2.22 | Base behavior tests unchanged | ☐ | |
| 2.23 | New extensions tested independently | ☐ | |
| 2.24 | Polymorphic behavior verified | ☐ | |
| 2.25 | All existing tests still pass | ☐ | |

**OCP Score**: ___/25 (___%)

---

## 3. Liskov Substitution Principle (LSP)

### Critical Items (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.1 | Derived classes can substitute base classes | ☐ | |
| 3.2 | Preconditions not strengthened in derived classes | ☐ | |
| 3.3 | Postconditions not weakened in derived classes | ☐ | |
| 3.4 | Invariants maintained in derived classes | ☐ | |
| 3.5 | No unexpected exceptions in derived classes | ☐ | |

### Implementation (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.6 | All implementations honor interface contracts | ☐ | |
| 3.7 | Return types consistent across implementations | ☐ | |
| 3.8 | Error handling consistent across implementations | ☐ | |
| 3.9 | Side effects documented and consistent | ☐ | |

### C#-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.10 | Proper use of virtual/override keywords | ☐ | |
| 3.11 | Covariance/contravariance used correctly | ☐ | |
| 3.12 | Base class contracts documented with XML comments | ☐ | |

### Java-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.13 | Proper use of @Override annotation | ☐ | |
| 3.14 | Contracts documented with Javadoc | ☐ | |
| 3.15 | Generics used correctly for type safety | ☐ | |

### Python-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.16 | Proper use of ABC and abstractmethod | ☐ | |
| 3.17 | Type hints used for contracts | ☐ | |
| 3.18 | Docstrings document contracts | ☐ | |

### TypeScript-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.19 | Proper use of implements keyword | ☐ | |
| 3.20 | Type definitions document contracts | ☐ | |
| 3.21 | JSDoc comments for complex contracts | ☐ | |

### Testing

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 3.22 | Contract tests run against all implementations | ☐ | |
| 3.23 | Base test suite passes for all derived classes | ☐ | |
| 3.24 | Behavioral compatibility verified | ☐ | |
| 3.25 | All existing tests still pass | ☐ | |

**LSP Score**: ___/25 (___%)

---

## 4. Interface Segregation Principle (ISP)

### Critical Items (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.1 | Interfaces are small and focused | ☐ | |
| 4.2 | Clients only depend on methods they use | ☐ | |
| 4.3 | No fat interfaces with many methods | ☐ | |
| 4.4 | Interfaces grouped by client needs | ☐ | |
| 4.5 | No forced implementation of unused methods | ☐ | |

### Repository Interfaces (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.6 | Repository interfaces segregated by operation type | ☐ | |
| 4.7 | Read/write interfaces separated when appropriate | ☐ | |
| 4.8 | Query interfaces separate from command interfaces | ☐ | |

### Service Interfaces (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.9 | Service interfaces focused on single client | ☐ | |
| 4.10 | No "god interfaces" with 10+ methods | ☐ | |
| 4.11 | Interface names clearly describe purpose | ☐ | |

### C#-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.12 | Proper use of interface inheritance | ☐ | |
| 4.13 | No marker interfaces (empty interfaces) | ☐ | |
| 4.14 | Explicit interface implementation when needed | ☐ | |

### Java-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.15 | Proper use of interface inheritance | ☐ | |
| 4.16 | Default methods used appropriately | ☐ | |
| 4.17 | Functional interfaces for single methods | ☐ | |

### Python-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.18 | Protocol classes for structural subtyping | ☐ | |
| 4.19 | ABC used for explicit contracts | ☐ | |
| 4.20 | Type hints document interface requirements | ☐ | |

### TypeScript-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.21 | Interface composition used effectively | ☐ | |
| 4.22 | Utility types used to create focused interfaces | ☐ | |
| 4.23 | Type aliases for complex types | ☐ | |

### Testing

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 4.24 | Each interface tested independently | ☐ | |
| 4.25 | Test doubles are minimal and focused | ☐ | |
| 4.26 | No fat mock objects | ☐ | |
| 4.27 | All existing tests still pass | ☐ | |

**ISP Score**: ___/27 (___%)

---

## 5. Dependency Inversion Principle (DIP)

### Critical Items (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.1 | High-level modules don't depend on low-level modules | ☐ | |
| 5.2 | Both depend on abstractions | ☐ | |
| 5.3 | Abstractions don't depend on details | ☐ | |
| 5.4 | Details depend on abstractions | ☐ | |
| 5.5 | Dependencies injected, not instantiated | ☐ | |

### Dependency Injection (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.6 | Constructor injection used consistently | ☐ | |
| 5.7 | Dependencies explicit in constructor | ☐ | |
| 5.8 | No service locator anti-pattern | ☐ | |
| 5.9 | IoC container configured correctly | ☐ | |

### Repository Pattern (All Languages)

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.10 | Repository pattern used for data access | ☐ | |
| 5.11 | Services depend on repository interfaces | ☐ | |
| 5.12 | Repository implementations in infrastructure layer | ☐ | |

### C#-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.13 | Proper use of Microsoft.Extensions.DependencyInjection | ☐ | |
| 5.14 | Service lifetimes configured correctly | ☐ | |
| 5.15 | Options pattern used for configuration | ☐ | |

### Java-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.16 | Proper use of Spring DI or CDI | ☐ | |
| 5.17 | Component scanning configured correctly | ☐ | |
| 5.18 | @Autowired or @Inject used appropriately | ☐ | |

### Python-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.19 | Dependency injection framework used (if applicable) | ☐ | |
| 5.20 | Dependencies passed as constructor arguments | ☐ | |
| 5.21 | No global state or singletons | ☐ | |

### TypeScript-Specific

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.22 | Dependency injection framework used (if applicable) | ☐ | |
| 5.23 | Dependencies typed with interfaces | ☐ | |
| 5.24 | No direct imports of implementations | ☐ | |

### Testing

| # | Criteria | Score | Notes |
|---|----------|-------|-------|
| 5.25 | Easy to test with mock implementations | ☐ | |
| 5.26 | Tests use dependency injection | ☐ | |
| 5.27 | Multiple implementations tested | ☐ | |
| 5.28 | All existing tests still pass | ☐ | |

**DIP Score**: ___/28 (___%)

---

## Overall Assessment

### Summary Scores

| Principle | Score | Percentage | Status |
|-----------|-------|------------|--------|
| SRP | ___/34 | ___% | ☐ Pass ☐ Fail |
| OCP | ___/25 | ___% | ☐ Pass ☐ Fail |
| LSP | ___/25 | ___% | ☐ Pass ☐ Fail |
| ISP | ___/27 | ___% | ☐ Pass ☐ Fail |
| DIP | ___/28 | ___% | ☐ Pass ☐ Fail |
| **Total** | **___/139** | **___%** | ☐ Pass ☐ Fail |

**Passing Grade**: 80% or higher

### Language-Specific Metrics

**Your Language**: _________________ (C# / Java / Python / TypeScript)

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Average class size (lines) | ___ | ___ | ___% |
| Average method size (lines) | ___ | ___ | ___% |
| Cyclomatic complexity (average) | ___ | ___ | ___% |
| Number of dependencies per class | ___ | ___ | ___% |
| Test coverage | ___% | ___% | ___% |
| Number of test files | ___ | ___ | ___% |

### Code Quality Indicators

#### C# (.NET)
- [ ] No compiler warnings
- [ ] StyleCop/Roslyn analyzers pass
- [ ] Code Analysis rules satisfied
- [ ] XML documentation complete

#### Java
- [ ] No compiler warnings
- [ ] Checkstyle rules pass
- [ ] PMD analysis clean
- [ ] Javadoc complete

#### Python
- [ ] No linter warnings (pylint/flake8)
- [ ] Type hints present (mypy passes)
- [ ] PEP 8 compliant
- [ ] Docstrings complete

#### TypeScript
- [ ] No TypeScript errors
- [ ] ESLint rules pass
- [ ] No `any` types (or minimal)
- [ ] JSDoc comments present

### Qualitative Assessment

#### What Improved?
- [ ] Code is easier to understand
- [ ] Code is easier to test
- [ ] Code is easier to modify
- [ ] Code is easier to extend
- [ ] Code is more maintainable
- [ ] Tests are more focused
- [ ] Dependencies are clearer

#### What Still Needs Work?
_List areas that need improvement:_

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

#### Key Learnings
_What did you learn from this exercise?_

1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

---

## Red Flags 🚩

If you answer "Yes" to any of these, you need to refactor:

### Anti-Patterns (All Languages)

- [ ] **God Class** - One class does everything (500+ lines)
- [ ] **Feature Envy** - Methods use more data from other classes
- [ ] **Shotgun Surgery** - One change requires modifications everywhere
- [ ] **Refused Bequest** - Derived class doesn't use inherited methods
- [ ] **Primitive Obsession** - Using primitives instead of domain objects
- [ ] **Long Parameter List** - Methods with 5+ parameters
- [ ] **Switch Statements** - Multiple switch/if-else on type codes
- [ ] **Lazy Class** - Class doesn't do enough to justify existence
- [ ] **Data Class** - Class with only getters/setters, no behavior

### Testing Issues

- [ ] **No Tests** - Refactored code has no tests
- [ ] **Failing Tests** - Some tests are failing
- [ ] **Brittle Tests** - Tests break with minor changes
- [ ] **Slow Tests** - Test suite takes > 5 minutes
- [ ] **Flaky Tests** - Tests pass/fail randomly
- [ ] **Test Doubles Everywhere** - Everything is mocked
- [ ] **Testing Implementation** - Tests check internal state

### Design Issues

- [ ] **Circular Dependencies** - A depends on B, B depends on A
- [ ] **Tight Coupling** - Classes know too much about each other
- [ ] **Hidden Dependencies** - Dependencies not visible in constructor
- [ ] **Static Cling** - Overuse of static methods/classes
- [ ] **Service Locator** - Using service locator anti-pattern
- [ ] **Singleton Abuse** - Everything is a singleton

---

## Action Items

Based on your assessment, create action items:

### High Priority (Must Fix)
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

### Medium Priority (Should Fix)
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

### Low Priority (Nice to Have)
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

---

## Peer Review

Have a peer review your code using this checklist:

**Reviewer Name**: _______________________
**Review Date**: _______________________
**Language**: _________________ (C# / Java / Python / TypeScript)

### Reviewer Comments

**Strengths**:
_______________________________________________
_______________________________________________
_______________________________________________

**Areas for Improvement**:
_______________________________________________
_______________________________________________
_______________________________________________

**Overall Assessment**: ☐ Excellent ☐ Good ☐ Needs Work ☐ Redo

**Reviewer Signature**: _______________________

---

## Instructor Review

**Instructor Name**: _______________________
**Review Date**: _______________________
**Language**: _________________ (C# / Java / Python / TypeScript)

### Instructor Feedback

**Technical Correctness**: ☐ Excellent ☐ Good ☐ Adequate ☐ Poor

**SOLID Principles Application**: ☐ Excellent ☐ Good ☐ Adequate ☐ Poor

**Code Quality**: ☐ Excellent ☐ Good ☐ Adequate ☐ Poor

**Testing**: ☐ Excellent ☐ Good ☐ Adequate ☐ Poor

**Language-Specific Best Practices**: ☐ Excellent ☐ Good ☐ Adequate ☐ Poor

**Comments**:
_______________________________________________
_______________________________________________
_______________________________________________

**Grade**: ☐ Pass ☐ Conditional Pass ☐ Fail

**Instructor Signature**: _______________________

---

## Next Steps

After completing this assessment:

1. **If you passed (80%+)**:
   - Move to the next SOLID principle
   - Apply learnings to your own projects
   - Help others who are struggling

2. **If you need improvement (60-79%)**:
   - Review the principle documentation
   - Refactor the areas that need work
   - Reassess using this checklist
   - Seek peer or instructor feedback

3. **If you failed (<60%)**:
   - Review the principle from scratch
   - Study the examples more carefully
   - Start over with the exercise
   - Get help from instructor or peers

---

## Resources

- [Backend Testing Workshop](../testing-workshop/README.md)
- [Language-Specific Testing Guides](../testing-workshop/)
- [Code Review Guidelines](./CODE-REVIEW-GUIDELINES.md)
- [Backend SOLID Principles](../README.md)

---

**Remember**: This is a learning tool, not a grade. Be honest with yourself, iterate, and improve!
