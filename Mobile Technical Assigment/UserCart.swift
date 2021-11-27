//
//  UserCart.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

struct ProductCart {
    let product: Product
    var quantity: Int = 0
    
}

class UserCart {
    var products: [ProductCart]?
    
    init() {
        self.products = []
    }
    
    func addProduct(Product product: Product){
        // ADD quantity
        if var productCart = self.getproductCart(ByProduct: product){
            productCart.quantity += 1
        }
        // ADD new
        else {
            self.products!.append(ProductCart(product: product))
        }
    }
    
    func removeProduct(Product product: Product){
        // Remove quantity
        if var productCart = self.getproductCart(ByProduct: product){
            if(productCart.quantity > 0){
                productCart.quantity -= 1
            }
        }
        
        self.products = self.products?.filter({ product in
            return product.quantity > 0
        })
    }
    
    func getproductCart(ByProduct product: Product) -> ProductCart? {
        return self.products!.first(where: { $0.product ==  product }) ?? nil
    }
    
    func calculatePrice(ByType type: String) -> Double {
        
        var totalPrice = 0.0
        
        if let typeProducts = self.products?.filter({ product in
            return product.product.type == type
        }){

            for product in typeProducts {
                totalPrice += product.product.price
            }
        }
        
        return totalPrice
    }
    
    
}
