import { render, screen } from '@testing-library/react';
import { UserProfile } from '../UserProfile';

describe('UserProfile', () => {
  const mockAdminActions = [
    { id: '1', label: 'Manage Products', action: 'manage_products' },
  ];

  it('renders user information', () => {
    render(
      <UserProfile
        name="John Doe"
        email="john@example.com"
        avatar="https://example.com/avatar.jpg"
      />
    );

    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('renders edit section when edit props are provided', () => {
    const handleEditName = jest.fn();
    const handleEditEmail = jest.fn();

    render(
      <UserProfile
        name="John Doe"
        email="john@example.com"
        onEditName={handleEditName}
        onEditEmail={handleEditEmail}
      />
    );

    expect(screen.getByText('Edit Profile')).toBeInTheDocument();
  });

  it('renders admin panel when user is admin', () => {
    render(
      <UserProfile
        name="John Doe"
        email="john@example.com"
        isAdmin={true}
        adminActions={mockAdminActions}
        onAdminAction={jest.fn()}
      />
    );

    expect(screen.getByText('Admin Actions')).toBeInTheDocument();
    expect(screen.getByText('Manage Products')).toBeInTheDocument();
  });

  it('calls trackView on mount', () => {
    const trackView = jest.fn();
    
    render(
      <UserProfile
        name="John Doe"
        email="john@example.com"
        trackView={trackView}
      />
    );

    expect(trackView).toHaveBeenCalled();
  });
});

