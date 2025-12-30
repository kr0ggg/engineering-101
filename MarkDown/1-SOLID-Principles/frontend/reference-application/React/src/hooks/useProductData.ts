// VIOLATION: Dependency Inversion Principle (DIP)
// This hook directly depends on the concrete api.ts implementation
// No abstraction - violates DIP

import { useState, useEffect } from 'react';
import { getProducts } from '../services/api'; // VIOLATION: Direct dependency
import type { Product } from '../types';

export const useProductData = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchProducts = async () => {
      setLoading(true);
      setError(null);
      try {
        // VIOLATION: Direct call to concrete implementation
        const data = await getProducts();
        setProducts(data);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Failed to fetch products');
      } finally {
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);

  return { products, loading, error };
};

