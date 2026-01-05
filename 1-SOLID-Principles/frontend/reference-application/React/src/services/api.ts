// VIOLATION: Dependency Inversion Principle (DIP)
// This service directly uses fetch() and hard-codes API endpoints
// No abstraction layer - violates DIP

import type { Product, User, Order } from '../types';

const API_BASE_URL = '/api'; // VIOLATION: Hard-coded endpoint

// VIOLATION: Direct dependency on fetch API
export const getProducts = async (): Promise<Product[]> => {
  const response = await fetch(`${API_BASE_URL}/products`);
  if (!response.ok) {
    throw new Error('Failed to fetch products');
  }
  return response.json();
};

export const getProduct = async (id: number): Promise<Product | null> => {
  const response = await fetch(`${API_BASE_URL}/products/${id}`);
  if (!response.ok) {
    return null;
  }
  return response.json();
};

export const getUser = async (id: number): Promise<User | null> => {
  const response = await fetch(`${API_BASE_URL}/users/${id}`);
  if (!response.ok) {
    return null;
  }
  return response.json();
};

export const updateUser = async (id: number, userData: Partial<User>): Promise<User> => {
  const response = await fetch(`${API_BASE_URL}/users/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(userData),
  });
  if (!response.ok) {
    throw new Error('Failed to update user');
  }
  return response.json();
};

export const getOrders = async (userId: number): Promise<Order[]> => {
  const response = await fetch(`${API_BASE_URL}/users/${userId}/orders`);
  if (!response.ok) {
    throw new Error('Failed to fetch orders');
  }
  return response.json();
};

