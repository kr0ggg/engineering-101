// VIOLATION: Open/Closed Principle (OCP)
// This component is hard-coded and cannot be extended without modification
// Must modify component to add new variants or behaviors - violates OCP

import React from 'react';

interface ButtonProps {
  text: string;
}

export const Button: React.FC<ButtonProps> = ({ text }) => {
  // VIOLATION: Hard-coded styling
  // VIOLATION: Hard-coded behavior
  // VIOLATION: Cannot be extended without modification
  return (
    <button
      className="btn-primary"
      onClick={() => {
        console.log('Button clicked');
        // Hard-coded behavior
      }}
      style={{
        padding: '10px 20px',
        backgroundColor: '#007bff',
        color: 'white',
        border: 'none',
        borderRadius: '4px',
        cursor: 'pointer',
      }}
    >
      {text}
    </button>
  );
};

// VIOLATION: To add a secondary button, must modify this component
// VIOLATION: To add different sizes, must modify this component
// VIOLATION: To add icons, must modify this component
// VIOLATION: To add custom onClick, must modify this component

