// VIOLATION: Liskov Substitution Principle (LSP)
// This component violates LSP by changing the expected behavior of the base Input component
// It doesn't honor the contract - violates LSP

import React from 'react';
import { Input, type InputProps } from './Input';

export const NumberInput: React.FC<InputProps> = ({ value, onChange, placeholder }) => {
  // VIOLATION: Changes expected behavior
  // VIOLATION: Doesn't always call onChange (breaks contract)
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const inputValue = e.target.value;
    
    // VIOLATION: Doesn't call onChange for non-numeric input
    // This breaks the contract - base Input always calls onChange
    if (inputValue !== '' && !/^\d*\.?\d*$/.test(inputValue)) {
      // Silently ignores invalid input - violates LSP
      return;
    }
    
    // VIOLATION: Only calls onChange conditionally
    onChange(inputValue);
  };

  return (
    <input
      type="text"
      inputMode="numeric"
      value={value}
      onChange={handleChange}
      placeholder={placeholder || 'Enter number'}
    />
  );
};

// VIOLATION: Cannot be substituted for Input without breaking functionality
// VIOLATION: Changes the contract - doesn't always call onChange
// VIOLATION: Filters input without always notifying parent

