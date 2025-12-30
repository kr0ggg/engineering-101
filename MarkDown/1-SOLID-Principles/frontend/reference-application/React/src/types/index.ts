// Type definitions for the e-commerce application

export interface Product {
  id: number;
  name: string;
  price: number;
  description?: string;
  imageUrl?: string;
  sku: string;
  stockQuantity: number;
}

export interface CartItem {
  id: number;
  name: string;
  price: number;
  quantity: number;
  productId: number;
}

export interface User {
  id: number;
  name: string;
  email: string;
  avatar?: string;
  isAdmin: boolean;
}

export interface Order {
  id: number;
  orderNumber: string;
  customerId: number;
  items: OrderItem[];
  totalAmount: number;
  status: OrderStatus;
  orderDate: Date;
}

export interface OrderItem {
  productId: number;
  productName: string;
  quantity: number;
  unitPrice: number;
  totalPrice: number;
}

export type OrderStatus = 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled';

export interface AdminAction {
  id: string;
  label: string;
  action: string;
}

export type SortOption = 'name' | 'price';

export interface ProductService {
  getProducts(): Promise<Product[]>;
  getProduct(id: number): Promise<Product | null>;
}

export interface UserService {
  getUser(id: number): Promise<User | null>;
  updateUser(id: number, user: Partial<User>): Promise<User>;
}

