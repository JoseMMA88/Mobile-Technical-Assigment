//
//  UserCart.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.


class ProductCart {
    var product: Product
    var quantity: Int
    
    init(Product product: Product, Quantity quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
    
}

class UserCart {
    var products: [ProductCart]?
    
    init() {
        self.products = []
    }
    
    func addProduct(Product product: Product){
        // ADD quantity
        if let productCart = self.getproductCart(ByProduct: product){
            productCart.quantity += 1
        }
        // ADD new
        else {
            self.products!.append(ProductCart(Product: product, Quantity: 1))
        }
    }
    
    func removeProduct(Product product: Product){
        // Remove quantity
        if let productCart = self.getproductCart(ByProduct: product){
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
                totalPrice += product.product.price * Double(product.quantity)
            }
        }
        
        return totalPrice
    }
    
    func getNumberOfTypes() -> Int{
        var typeNum = 0
        var currenType = ""
        
        self.products?.forEach({ product in
            if(currenType != product.product.type){
                typeNum += 1
                currenType = product.product.type!
            }
        })
        
        return typeNum
    }
    
    func splitProductsByCategory() -> [[Product]] {
        var productByCategory: [[Product]] = []
        
        var category = ""
        
        for cartProduct in self.products! {
            if(cartProduct.product.type != category){
                productByCategory.append([])
                category = cartProduct.product.type!
            }
            productByCategory[productByCategory.endIndex - 1].append(cartProduct.product)
        }
        
        return productByCategory
    }
    
    
}
