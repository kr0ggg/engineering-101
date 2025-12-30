import React from 'react';
import { render, screen } from '@testing-library/react';
import { Button } from '../Button';

describe('Button', () => {
  it('renders button with text', () => {
    render(<Button text="Click Me" />);
    expect(screen.getByText('Click Me')).toBeInTheDocument();
  });

  it('has hard-coded styling', () => {
    const { container } = render(<Button text="Test" />);
    const button = container.querySelector('button');
    expect(button).toHaveClass('btn-primary');
  });

  it('logs to console on click', () => {
    const consoleSpy = jest.spyOn(console, 'log').mockImplementation();
    render(<Button text="Test" />);
    const button = screen.getByText('Test');
    button.click();
    expect(consoleSpy).toHaveBeenCalledWith('Button clicked');
    consoleSpy.mockRestore();
  });
});

