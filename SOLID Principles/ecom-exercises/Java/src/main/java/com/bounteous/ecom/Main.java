package com.bounteous.ecom;

public class Main {
    public static void main(String[] args) {
        try {
            EcommerceManager manager = new EcommerceManager();
            
            // Test the e-commerce functionality
            System.out.println("E-commerce Manager Demo");
            System.out.println("=====================");
            
            // Get products
            var products = manager.getProducts();
            System.out.println("Available products: " + products.size());
            
            // Create a customer
            int customerId = manager.createCustomer("test@example.com", "John", "Doe", "555-0101", "123 Main St");
            System.out.println("Created customer with ID: " + customerId);
            
            // Create a cart
            int cartId = manager.createCart(customerId);
            System.out.println("Created cart with ID: " + cartId);
            
            // Add product to cart
            if (!products.isEmpty()) {
                int productId = products.get(0).getId();
                manager.addToCart(customerId, productId, 2);
                System.out.println("Added product " + productId + " to cart");
                
                // Calculate total
                double total = manager.calculateCartTotal(customerId);
                System.out.println("Cart total: $" + total);
            }
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
