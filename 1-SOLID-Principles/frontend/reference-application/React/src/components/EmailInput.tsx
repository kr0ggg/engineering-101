// VIOLATION: Liskov Substitution Principle (LSP)
// This component violates LSP by changing the expected behavior of the base Input component
// It doesn't honor the contract - violates LSP

import React from 'react';
import type { InputProps } from './Input';

export const EmailInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  // VIOLATION: Changes expected behavior
  // VIOLATION: Doesn't always call onChange (breaks contract)
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value.toLowerCase();
    
    // VIOLATION: Doesn't call onChange for invalid input
    // This breaks the contract - base Input always calls onChange
    if (!newValue.includes('@') && newValue.length > 0) {
      // Silently ignores invalid input - violates LSP
      return;
    }
    
    // VIOLATION: Only calls onChange conditionally
    onChange(newValue);
  };

  return (
    <input
      type="email"
      value={value}
      onChange={handleChange}
      placeholder={placeholder || 'Enter email'}
    />
  );
};

// VIOLATION: Cannot be substituted for Input without breaking functionality
// VIOLATION: Changes the contract - doesn't always call onChange
// VIOLATION: Modifies input value (lowercase) without always notifying parent

