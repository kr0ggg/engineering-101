// Base Input Component - defines the contract
// Extended components should honor this contract (Liskov Substitution Principle)

import React from 'react';

export interface InputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
}

export const Input: React.FC<InputProps> = ({ value, onChange, placeholder, className }) => {
  return (
    <input
      type="text"
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      className={className}
    />
  );
};

