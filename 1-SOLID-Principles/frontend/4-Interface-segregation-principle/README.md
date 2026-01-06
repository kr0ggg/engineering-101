# Interface Segregation Principle (ISP) - React Edition

## Name
**Interface Segregation Principle** - The "I" in SOLID

## Goal of the Principle

In React, the Interface Segregation Principle means: **Components should not be forced to depend on props they don't use**. Props interfaces should be focused and cohesive, containing only the props that are relevant to the component's specific purpose.

## React-Specific Application

### What It Means in React

In React development, ISP applies to:

- **Props Interfaces**: Components should not be forced to accept props they don't use
- **Minimal Props**: Props interfaces should contain only what's needed
- **Component Specialization**: Create specialized components for specific use cases
- **Optional Props**: Use optional props for non-essential features

### React Props Interface Design

A React component's props interface should:
- **Be minimal**: Only include props the component actually uses
- **Be focused**: All props should serve the component's single purpose
- **Avoid forcing**: Don't force components to accept unused props
- **Support composition**: Allow composing components instead of fat interfaces

**The Problem**: When components have fat props interfaces:
- Components must accept props they don't need
- Props become confusing (which ones are actually used?)
- Changes to unused props affect components unnecessarily
- Testing becomes complex (must provide all props)

## Theoretical Foundation

### Dependency Minimization Theory

ISP is based on minimizing dependencies. In React:
- **Every prop is a dependency**: Components depend on their props
- **Unused props are unnecessary dependencies**: Create coupling without benefit
- **Focused interfaces reduce coupling**: Components only depend on what they use

### Interface Design Principles

ISP formalizes interface design concepts:
- **Cohesion**: Props should be related and work toward a common purpose
- **Minimal Interface**: Interfaces should contain only essential props
- **Client-Specific Design**: Interfaces should be designed from the component's perspective

### Coupling Theory

ISP addresses coupling by ensuring:
- Components are only coupled to props they actually use
- Changes to unused props don't affect components
- System components remain loosely coupled

## Consequences of Violating ISP in React

### React-Specific Issues

**Interface Pollution**
- Components must accept props they don't use
- Confusion about which props are actually needed
- Props interfaces become bloated and unclear
- Reduced code clarity and maintainability

**Unnecessary Dependencies**
- Changes to unused props affect components unnecessarily
- Components become coupled to implementation details they don't need
- System becomes more fragile and harder to maintain

**Testing Complexity**
- Must provide all props even if unused
- Mock objects become bloated
- Test setup becomes more complex
- Cannot easily test components in isolation

**Reduced Reusability**
- Components can't be reused in contexts where they don't need all props
- Forces creation of wrapper components
- Duplication of similar components

## React-Specific Examples

### ❌ Violating ISP - Fat Props Interface

The `UserProfile` component in our reference application violates ISP:

**Location**: `frontend/reference-application/React/src/components/UserProfile.tsx`

```typescript
// UserProfile.tsx - VIOLATES ISP
// Component forced to accept props it doesn't use
interface UserProfileProps {
  // Display props
  name: string;
  email: string;
  avatar?: string;
  
  // Edit props (not always needed)
  onEditName?: (name: string) => void;
  onEditEmail?: (email: string) => void;
  onEditAvatar?: (avatar: string) => void;
  
  // Admin props (rarely needed)
  isAdmin?: boolean;
  adminActions?: AdminAction[];
  onAdminAction?: (action: AdminAction) => void;
  
  // Analytics props (not always needed)
  trackView?: () => void;
  trackInteraction?: (event: string) => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({
  name,
  email,
  avatar,
  onEditName,
  onEditEmail,
  onEditAvatar,
  isAdmin,
  adminActions,
  onAdminAction,
  trackView,
  trackInteraction,
}) => {
  // VIOLATION: Forced to use analytics even if not needed
  useEffect(() => {
    if (trackView) {
      trackView();
    }
  }, [trackView]);

  const handleInteraction = (event: string) => {
    if (trackInteraction) {
      trackInteraction(event);
    }
  };

  return (
    <div className="user-profile">
      <div className="user-display">
        {avatar && <img src={avatar} alt={name} />}
        <h2>{name}</h2>
        <p>{email}</p>
      </div>

      {/* Edit section - only needed sometimes */}
      {(onEditName || onEditEmail || onEditAvatar) && (
        <div className="user-edit">
          {/* ... edit UI ... */}
        </div>
      )}

      {/* Admin section - only needed for admins */}
      {isAdmin && adminActions && onAdminAction && (
        <div className="admin-panel">
          {/* ... admin UI ... */}
        </div>
      )}
    </div>
  );
};
```

**Problems:**
- ❌ Display-only components must accept edit props
- ❌ Non-admin components must accept admin props
- ❌ Components without analytics must accept analytics props
- ❌ Confusing which props are actually needed

### ✅ Refactored - Applying ISP

Here's how to segregate the fat interface into focused components:

#### 1. Segregated Interfaces

```typescript
// Focused interfaces for each responsibility
interface UserDisplayProps {
  name: string;
  email: string;
  avatar?: string;
}

interface UserEditProps {
  name: string;
  email: string;
  avatar?: string;
  onEditName: (name: string) => void;
  onEditEmail: (email: string) => void;
  onEditAvatar: (avatar: string) => void;
}

interface AdminPanelProps {
  isAdmin: boolean;
  adminActions: AdminAction[];
  onAdminAction: (action: AdminAction) => void;
}

interface AnalyticsProps {
  trackView: () => void;
  trackInteraction: (event: string) => void;
}
```

#### 2. Focused Components

```typescript
// UserDisplay.tsx - Single responsibility: Display user info
export const UserDisplay: React.FC<UserDisplayProps> = ({ name, email, avatar }) => {
  // Only depends on display props
  return (
    <div className="user-display">
      {avatar && <img src={avatar} alt={name} className="avatar" />}
      <h2>{name}</h2>
      <p>{email}</p>
    </div>
  );
};

// UserEdit.tsx - Single responsibility: Edit user info
export const UserEdit: React.FC<UserEditProps> = ({
  name,
  email,
  avatar,
  onEditName,
  onEditEmail,
  onEditAvatar,
}) => {
  // Only depends on edit props
  return (
    <div className="user-edit">
      <h3>Edit Profile</h3>
      <UserDisplay name={name} email={email} avatar={avatar} />
      <div>
        <label>Name:</label>
        <input
          type="text"
          value={name}
          onChange={(e) => onEditName(e.target.value)}
        />
      </div>
      <div>
        <label>Email:</label>
        <input
          type="email"
          value={email}
          onChange={(e) => onEditEmail(e.target.value)}
        />
      </div>
      <div>
        <label>Avatar URL:</label>
        <input
          type="text"
          value={avatar || ''}
          onChange={(e) => onEditAvatar(e.target.value)}
        />
      </div>
    </div>
  );
};

// AdminPanel.tsx - Single responsibility: Admin actions
export const AdminPanel: React.FC<AdminPanelProps> = ({
  isAdmin,
  adminActions,
  onAdminAction,
}) => {
  // Only depends on admin props
  if (!isAdmin) return null;
  
  return (
    <div className="admin-panel">
      <h3>Admin Actions</h3>
      {adminActions.map(action => (
        <button
          key={action.id}
          onClick={() => onAdminAction(action)}
          className="admin-action-btn"
        >
          {action.label}
        </button>
      ))}
    </div>
  );
};

// AnalyticsWrapper.tsx - Single responsibility: Analytics tracking
export const AnalyticsWrapper: React.FC<{
  children: React.ReactNode;
} & AnalyticsProps> = ({ children, trackView, trackInteraction }) => {
  // Only depends on analytics props
  useEffect(() => {
    trackView();
  }, [trackView]);

  const handleInteraction = (event: string) => {
    trackInteraction(event);
  };

  return (
    <div onInteraction={handleInteraction}>
      {children}
    </div>
  );
};
```

#### 3. Composition for Complex Cases

```typescript
// UserProfile.tsx - Composes focused components
// Only includes props that are actually needed for composition
export const UserProfile: React.FC<
  UserDisplayProps &
  Partial<UserEditProps> &
  Partial<AdminPanelProps> &
  Partial<AnalyticsProps>
> = (props) => {
  return (
    <div className="user-profile">
      <UserDisplay name={props.name} email={props.email} avatar={props.avatar} />
      
      {/* Only render edit if edit props are provided */}
      {props.onEditName && (
        <UserEdit {...props as UserEditProps} />
      )}
      
      {/* Only render admin if admin props are provided */}
      {props.isAdmin && props.adminActions && props.onAdminAction && (
        <AdminPanel {...props as AdminPanelProps} />
      )}
    </div>
  );
};

// Or use AnalyticsWrapper for analytics
export const UserProfileWithAnalytics: React.FC<
  UserDisplayProps &
  Partial<UserEditProps> &
  Partial<AdminPanelProps> &
  AnalyticsProps
> = (props) => {
  const { trackView, trackInteraction, ...profileProps } = props;
  
  return (
    <AnalyticsWrapper trackView={trackView} trackInteraction={trackInteraction}>
      <UserProfile {...profileProps} />
    </AnalyticsWrapper>
  );
};
```

**Benefits:**
- ✅ Components only depend on props they use
- ✅ Clear which props are needed for each component
- ✅ Easy to test components in isolation
- ✅ Easy to reuse components in different contexts

## How to Apply ISP in React

### 1. Identify Prop Groups

**What it means**: Analyze props to identify distinct groups of related props.

**How to do it**:
- Group props by functionality (display, edit, admin, analytics)
- Identify props that are always used together
- Find props that are rarely used together

**Example**:
```typescript
// Fat interface
interface UserProfileProps {
  // Display group
  name, email, avatar,
  // Edit group
  onEditName, onEditEmail,
  // Admin group
  isAdmin, adminActions,
  // Analytics group
  trackView, trackInteraction
}

// Segregated groups
interface DisplayProps { name, email, avatar }
interface EditProps { onEditName, onEditEmail }
interface AdminProps { isAdmin, adminActions }
interface AnalyticsProps { trackView, trackInteraction }
```

### 2. Create Focused Components

**What it means**: Create separate components for each prop group.

**How to do it**:
- One component per responsibility
- Each component only accepts props it needs
- Components can be composed together

**Example**:
```typescript
// Focused components
<UserDisplay name={name} email={email} />
<UserEdit onEditName={setName} onEditEmail={setEmail} />
<AdminPanel isAdmin={true} adminActions={actions} />
```

### 3. Use Optional Props Wisely

**What it means**: Make props optional only when they're truly optional.

**How to do it**:
- Required props for essential functionality
- Optional props for non-essential features
- Don't make props optional just to avoid ISP violations

**Example**:
```typescript
// Good: Optional for truly optional feature
interface ButtonProps {
  onClick: () => void; // Required
  disabled?: boolean; // Optional - truly optional
}

// Bad: Optional to avoid ISP violation
interface UserProfileProps {
  name: string;
  onEditName?: (name: string) => void; // Should be separate component
}
```

### 4. Compose Components

**What it means**: Build complex features by composing simple components.

**How to do it**:
- Create small, focused components
- Compose them for complex features
- Avoid fat interfaces

**Example**:
```typescript
// Composition instead of fat interface
<div>
  <UserDisplay name={name} email={email} />
  {canEdit && <UserEdit onEditName={setName} />}
  {isAdmin && <AdminPanel adminActions={actions} />}
</div>
```

## React Props Best Practices

### Minimal Props

- **Only include what's needed**: Don't add props "just in case"
- **Remove unused props**: Regularly audit and remove unused props
- **Question every prop**: Ask "Does this component really need this prop?"

### Optional Props

- **Use for non-essential features**: Optional props for truly optional functionality
- **Don't use to avoid ISP**: Creating separate components is better
- **Document optional behavior**: Clearly document when optional props are used

### Composition

- **Compose over fat interfaces**: Build complex features from simple components
- **Use children prop**: Allow composition via children
- **Create specialized components**: Don't try to make one component do everything

### Specialization

- **Create specialized components**: Different components for different use cases
- **Avoid "one size fits all"**: Don't try to handle all cases in one component
- **Favor composition**: Compose specialized components

## Exercise: Segregate Fat Props Interfaces

### Objective

Refactor components with fat prop interfaces into focused, minimal interfaces.

### Task

1. **Identify Fat Interfaces**:
   - Open `frontend/reference-application/React/src/components/UserProfile.tsx`
   - Identify all the different prop groups (display, edit, admin, analytics)
   - Document which props are used together

2. **Create Focused Components**:
   - Create `UserDisplay` component (display props only)
   - Create `UserEdit` component (edit props only)
   - Create `AdminPanel` component (admin props only)
   - Create `AnalyticsWrapper` component (analytics props only)

3. **Refactor UserProfile**:
   - Update `UserProfile` to compose the focused components
   - Use optional props only for composition
   - Ensure backward compatibility if needed

4. **Update Tests**:
   - Update tests to work with new component structure
   - Test each focused component in isolation
   - Test composition scenarios
   - Ensure all tests pass

### Deliverables

- Segregated component interfaces
- Focused component implementations
- Composed UserProfile component
- Updated tests
- Brief explanation of improvements

### Success Criteria

- ✅ Each component only depends on props it uses
- ✅ Components can be used independently
- ✅ Easy to test components in isolation
- ✅ Clear which props are needed for each component

### Getting Started

1. Navigate to the reference application:
   ```bash
   cd frontend/reference-application/React
   ```

2. Analyze UserProfile props interface

3. Create focused components

4. Refactor UserProfile to use composition

5. Update and run tests

---

**Previous**: [Liskov Substitution Principle](../3-Liskov-substitution-principle/README.md)  
**Next**: [Dependency Inversion Principle](../5-Dependency-segregation-principle/README.md)
