// VIOLATION: Single Responsibility Principle (SRP)
// This component handles:
// 1. Data fetching
// 2. Filtering logic
// 3. Sorting logic
// 4. Cart management
// 5. UI rendering
// 6. Error handling
// 7. Loading state
// All in one component - violates SRP

import React, { useState, useEffect, useMemo } from 'react';
import { useProductData } from '../hooks/useProductData';
import type { Product, CartItem, SortOption } from '../types';

export const ProductDashboard: React.FC = () => {
  // Responsibility 1: Data Fetching (should be in a hook)
  const { products, loading, error } = useProductData();
  
  // Responsibility 2: Filtering State (should be separate)
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredProducts, setFilteredProducts] = useState<Product[]>([]);
  
  // Responsibility 3: Sorting State (should be separate)
  const [sortBy, setSortBy] = useState<SortOption>('name');
  
  // Responsibility 4: Cart Management (should be separate)
  const [cart, setCart] = useState<CartItem[]>([]);

  // Responsibility 2: Filtering Logic (should be in a hook)
  useEffect(() => {
    const filtered = products.filter(product =>
      product.name.toLowerCase().includes(searchTerm.toLowerCase())
    );
    setFilteredProducts(filtered);
  }, [products, searchTerm]);

  // Responsibility 3: Sorting Logic (should be in a hook)
  const sortedProducts = useMemo(() => {
    return [...filteredProducts].sort((a, b) => {
      if (sortBy === 'name') {
        return a.name.localeCompare(b.name);
      }
      return a.price - b.price;
    });
  }, [filteredProducts, sortBy]);

  // Responsibility 4: Cart Management Logic (should be in a hook)
  const addToCart = (product: Product) => {
    setCart(prev => {
      const existing = prev.find(item => item.id === product.id);
      if (existing) {
        return prev.map(item =>
          item.id === product.id
            ? { ...item, quantity: item.quantity + 1 }
            : item
        );
      }
      return [...prev, { 
        id: product.id, 
        name: product.name, 
        price: product.price, 
        quantity: 1,
        productId: product.id
      }];
    });
  };

  const removeFromCart = (productId: number) => {
    setCart(prev => prev.filter(item => item.id !== productId));
  };

  const updateCartQuantity = (productId: number, quantity: number) => {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    setCart(prev =>
      prev.map(item =>
        item.id === productId ? { ...item, quantity } : item
      )
    );
  };

  const cartTotal = useMemo(() => {
    return cart.reduce((total, item) => total + item.price * item.quantity, 0);
  }, [cart]);

  // Responsibility 5: Error Handling (should be separate component)
  if (error) {
    return (
      <div className="error-container">
        <h2>Error</h2>
        <p>{error}</p>
      </div>
    );
  }

  // Responsibility 6: Loading State (should be separate component)
  if (loading) {
    return (
      <div className="loading-container">
        <p>Loading products...</p>
      </div>
    );
  }

  // Responsibility 5: UI Rendering (should be split into multiple components)
  return (
    <div className="product-dashboard">
      <h1>Product Dashboard</h1>
      
      {/* Search and Sort Controls - should be separate components */}
      <div className="controls">
        <input
          type="text"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          placeholder="Search products..."
          className="search-input"
        />
        <select
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value as SortOption)}
          className="sort-select"
        >
          <option value="name">Sort by Name</option>
          <option value="price">Sort by Price</option>
        </select>
      </div>

      {/* Product List - should be separate component */}
      <div className="product-list">
        <h2>Products ({sortedProducts.length})</h2>
        {sortedProducts.length === 0 ? (
          <p>No products found</p>
        ) : (
          <div className="products-grid">
            {sortedProducts.map(product => (
              <div key={product.id} className="product-card">
                <h3>{product.name}</h3>
                <p className="price">${product.price.toFixed(2)}</p>
                {product.description && <p className="description">{product.description}</p>}
                <button
                  onClick={() => addToCart(product)}
                  className="add-to-cart-btn"
                >
                  Add to Cart
                </button>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Shopping Cart - should be separate component */}
      <div className="shopping-cart">
        <h2>Shopping Cart ({cart.length} items)</h2>
        {cart.length === 0 ? (
          <p>Your cart is empty</p>
        ) : (
          <>
            <div className="cart-items">
              {cart.map(item => (
                <div key={item.id} className="cart-item">
                  <span>{item.name}</span>
                  <span>${item.price.toFixed(2)}</span>
                  <div className="quantity-controls">
                    <button onClick={() => updateCartQuantity(item.id, item.quantity - 1)}>
                      -
                    </button>
                    <span>{item.quantity}</span>
                    <button onClick={() => updateCartQuantity(item.id, item.quantity + 1)}>
                      +
                    </button>
                  </div>
                  <span>${(item.price * item.quantity).toFixed(2)}</span>
                  <button onClick={() => removeFromCart(item.id)}>Remove</button>
                </div>
              ))}
            </div>
            <div className="cart-total">
              <strong>Total: ${cartTotal.toFixed(2)}</strong>
            </div>
          </>
        )}
      </div>
    </div>
  );
};

