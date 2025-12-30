// Main App component that uses all the violating components
// This demonstrates the violations in a working application

import React from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { ProductDashboard } from './components/ProductDashboard';
import { UserProfile } from './components/UserProfile';
import { Button } from './components/Button';
import { ProductList } from './components/ProductList';
import { Input, EmailInput, NumberInput } from './components/Input';
import type { AdminAction } from './types';

// Mock data for demonstration
const mockUser = {
  id: 1,
  name: 'John Doe',
  email: 'john.doe@example.com',
  avatar: 'https://via.placeholder.com/150',
  isAdmin: true,
};

const mockAdminActions: AdminAction[] = [
  { id: '1', label: 'Manage Products', action: 'manage_products' },
  { id: '2', label: 'View Reports', action: 'view_reports' },
  { id: '3', label: 'User Management', action: 'user_management' },
];

const mockProducts = [
  { id: 1, name: 'Laptop', price: 999.99, description: 'High-performance laptop', sku: 'LAP001', stockQuantity: 10 },
  { id: 2, name: 'Mouse', price: 29.99, description: 'Wireless mouse', sku: 'MOU001', stockQuantity: 50 },
  { id: 3, name: 'Keyboard', price: 79.99, description: 'Mechanical keyboard', sku: 'KEY001', stockQuantity: 30 },
];

function App() {
  const [inputValue, setInputValue] = React.useState('');
  const [emailValue, setEmailValue] = React.useState('');
  const [numberValue, setNumberValue] = React.useState('');

  const handleEditName = (name: string) => {
    console.log('Name edited:', name);
  };

  const handleEditEmail = (email: string) => {
    console.log('Email edited:', email);
  };

  const handleAdminAction = (action: AdminAction) => {
    console.log('Admin action:', action);
  };

  const trackView = () => {
    console.log('User profile viewed');
  };

  const trackInteraction = (event: string) => {
    console.log('Interaction tracked:', event);
  };

  return (
    <BrowserRouter>
      <div className="app">
        <nav className="navigation">
          <Link to="/">Home</Link>
          <Link to="/products">Products</Link>
          <Link to="/profile">Profile</Link>
          <Link to="/components">Components Demo</Link>
        </nav>

        <Routes>
          <Route path="/" element={
            <div className="home">
              <h1>SOLID Principles - React Reference Application</h1>
              <p>This application intentionally violates SOLID principles for learning purposes.</p>
              <p>Navigate to different sections to see violations in action.</p>
            </div>
          } />
          
          <Route path="/products" element={<ProductDashboard />} />
          
          <Route path="/profile" element={
            <div className="profile-page">
              <UserProfile
                name={mockUser.name}
                email={mockUser.email}
                avatar={mockUser.avatar}
                onEditName={handleEditName}
                onEditEmail={handleEditEmail}
                isAdmin={mockUser.isAdmin}
                adminActions={mockAdminActions}
                onAdminAction={handleAdminAction}
                trackView={trackView}
                trackInteraction={trackInteraction}
              />
            </div>
          } />
          
          <Route path="/components" element={
            <div className="components-demo">
              <h2>Component Demonstrations</h2>
              
              <section>
                <h3>Button Component (Violates OCP)</h3>
                <Button text="Click Me" />
                <p>This button is hard-coded and cannot be extended without modification.</p>
              </section>

              <section>
                <h3>ProductList Component (Violates OCP)</h3>
                <ProductList products={mockProducts} />
                <p>This list has hard-coded layout and cannot be extended.</p>
              </section>

              <section>
                <h3>Input Components (LSP Violations)</h3>
                <div>
                  <label>Base Input:</label>
                  <Input
                    value={inputValue}
                    onChange={setInputValue}
                    placeholder="Type anything"
                  />
                  <p>Value: {inputValue}</p>
                </div>
                
                <div>
                  <label>Email Input (Violates LSP):</label>
                  <EmailInput
                    value={emailValue}
                    onChange={setEmailValue}
                    placeholder="Enter email"
                  />
                  <p>Value: {emailValue}</p>
                  <p className="warning">⚠️ This component doesn't always call onChange - breaks contract!</p>
                </div>
                
                <div>
                  <label>Number Input (Violates LSP):</label>
                  <NumberInput
                    value={numberValue}
                    onChange={setNumberValue}
                    placeholder="Enter number"
                  />
                  <p>Value: {numberValue}</p>
                  <p className="warning">⚠️ This component doesn't always call onChange - breaks contract!</p>
                </div>
              </section>
            </div>
          } />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;

