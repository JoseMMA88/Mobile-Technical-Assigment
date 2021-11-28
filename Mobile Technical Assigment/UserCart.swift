//
//  UserCart.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.

class UserCart {
    var products: [CartProduct]?
    
    init(Products products: [CartProduct]) {
        self.products = products
    }
    
    func addProduct(Product product: Product){
        // ADD quantity
        if let productCart = self.getproductCart(ByProduct: product){
            productCart.quantity += 1
        }
        // ADD new
        else {
            if let productCart = DBHelper.addCartProduct(ByProduct: product){
                self.products?.append(productCart)
            }
        }
    }
    
    func removeProduct(Product product: Product){
        // Remove quantity
        if let productCart = self.getproductCart(ByProduct: product){
            if(productCart.quantity > 0){
                productCart.quantity -= 1
            }
            
            if(productCart.quantity <= 0){
                DBHelper.deleteCartProduct(ByProduct: productCart.product!)
            }
            
            self.products?.removeAll(where: { $0.quantity <= 0 })
        }
    }
    
    func removeAllProducts(){
        self.products?.removeAll()
        DBHelper.deleteAllCartProducts()
    }
    
    func getproductCart(ByProduct product: Product) -> CartProduct? {
        return DBHelper.getCartProduct(ByProduct: product)
    }
    
    func calculatePrice(ByType type: String) -> Double {
        
        var totalPrice = 0.0
        
        if let typeProducts = self.products?.filter({ product in
            return product.product!.type == type
        }){

            for product in typeProducts {
                totalPrice += product.product!.price * Double(product.quantity)
            }
        }
        
        return totalPrice
    }
    
    func calculateTotalPrice() -> Double {
        var totalPrice = 0.0
        
        for cartProduct in self.products! {
            totalPrice += cartProduct.product!.price * Double(cartProduct.quantity)
        }
        
        return totalPrice
    }
    
    func getNumberOfTypes() -> Int{
        var typeNum = 0
        var currenType = ""
        
        self.products?.forEach({ product in
            if(currenType != product.product!.type){
                typeNum += 1
                currenType = product.product!.type!
            }
        })
        
        return typeNum
    }
    
}
