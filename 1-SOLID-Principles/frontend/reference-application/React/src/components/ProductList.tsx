// VIOLATION: Open/Closed Principle (OCP)
// This component has hard-coded layout and styling
// Cannot be extended without modification - violates OCP

import React from 'react';
import type { Product } from '../types';

interface ProductListProps {
  products: Product[];
}

export const ProductList: React.FC<ProductListProps> = ({ products }) => {
  // VIOLATION: Hard-coded layout
  // VIOLATION: Hard-coded styling
  // VIOLATION: Cannot be extended without modification
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(3, 1fr)',
        gap: '20px',
        padding: '20px',
      }}
    >
      {products.map(product => (
        <div
          key={product.id}
          style={{
            border: '1px solid #ccc',
            borderRadius: '8px',
            padding: '15px',
            backgroundColor: '#fff',
          }}
        >
          <h3 style={{ marginTop: 0 }}>{product.name}</h3>
          <p style={{ fontSize: '18px', fontWeight: 'bold', color: '#007bff' }}>
            ${product.price.toFixed(2)}
          </p>
          {product.description && (
            <p style={{ color: '#666' }}>{product.description}</p>
          )}
        </div>
      ))}
    </div>
  );
};

// VIOLATION: To change layout (e.g., list view), must modify this component
// VIOLATION: To add custom styling, must modify this component
// VIOLATION: To add product actions, must modify this component
// VIOLATION: To customize product card rendering, must modify this component

