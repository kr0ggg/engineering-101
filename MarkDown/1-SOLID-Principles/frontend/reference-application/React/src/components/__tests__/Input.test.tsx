import React from 'react';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Input, EmailInput, NumberInput } from '../Input';

describe('Input Components - LSP Violations', () => {
  describe('Base Input', () => {
    it('calls onChange for all input', async () => {
      const onChange = jest.fn();
      const user = userEvent.setup();
      
      render(<Input value="" onChange={onChange} />);
      const input = screen.getByRole('textbox');
      
      await user.type(input, 'test');
      
      // Base input should call onChange for every character
      expect(onChange).toHaveBeenCalledTimes(4);
    });
  });

  describe('EmailInput (Violates LSP)', () => {
    it('does not call onChange for invalid email', async () => {
      const onChange = jest.fn();
      const user = userEvent.setup();
      
      render(<EmailInput value="" onChange={onChange} />);
      const input = screen.getByRole('textbox');
      
      // Type something without @ - should not call onChange
      await user.type(input, 'invalid');
      
      // VIOLATION: This demonstrates the LSP violation
      // EmailInput doesn't call onChange for invalid input
      // This breaks the contract established by base Input
      expect(onChange).not.toHaveBeenCalled();
    });
  });

  describe('NumberInput (Violates LSP)', () => {
    it('does not call onChange for non-numeric input', async () => {
      const onChange = jest.fn();
      const user = userEvent.setup();
      
      render(<NumberInput value="" onChange={onChange} />);
      const input = screen.getByRole('textbox');
      
      // Type letters - should not call onChange
      await user.type(input, 'abc');
      
      // VIOLATION: This demonstrates the LSP violation
      // NumberInput doesn't call onChange for non-numeric input
      // This breaks the contract established by base Input
      expect(onChange).not.toHaveBeenCalled();
    });
  });
});

