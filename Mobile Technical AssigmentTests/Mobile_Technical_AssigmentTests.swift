//
//  Mobile_Technical_AssigmentTests.swift
//  Mobile Technical AssigmentTests
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import XCTest

@testable import Mobile_Technical_Assigment

class Mobile_Technical_AssigmentTests: XCTestCase {
    
    var userCart: UserCart!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        userCart = UserCart()
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        userCart = nil
    }
    
    //MARK: - User Cart Test
    func testFetchAllProducts(){
        
        let totalProductsCount = DBHelper.getAllProducts().count
        
        XCTAssertEqual(totalProductsCount, 8, "Stored products quantity is wrong")
    }
    
    
    func testAddProductToUserCart(){
        
        let totalProducts = DBHelper.getAllProducts()
        
        self.userCart.addProduct(Product: totalProducts.first!)
        
        XCTAssertEqual(self.userCart.getNumberOfCartProducts(), 1, "Add product to user cart is wrong")
    }
    
    
    func testRemoveProductFromUserCart(){
        
        let totalProducts = DBHelper.getAllProducts()
        
        self.userCart.removeProduct(Product: totalProducts.first!)
        
        XCTAssertEqual(self.userCart.getNumberOfCartProducts(), 0, "Remove product to user cart is wrong")
    }
    
    
    func testUserCartCategoryQuantity1(){
        
        let totalProducts = DBHelper.getAllProducts()
        
        self.userCart.addProduct(Product: totalProducts.first!)
        self.userCart.addProduct(Product: totalProducts.first!)
        
        XCTAssertEqual(self.userCart?.getNumberOfTypes(), 1, "User cart category quantity count is wrong")
    }
    
    
    func testUserCartCategoryQuantity2(){
        
        let totalProducts = DBHelper.getAllProducts()
        
        self.userCart.addProduct(Product: totalProducts.first!)
        self.userCart.addProduct(Product: totalProducts.last!)
        
        XCTAssertEqual(self.userCart?.getNumberOfTypes(), 2, "User cart category quantity count is wrong")
    }
    
    
    func testUserCartRemoveAllProducts(){
        
        let totalProducts = DBHelper.getAllProducts()
        
        self.userCart.addProduct(Product: totalProducts.first!)
        self.userCart.addProduct(Product: totalProducts.first!)
        self.userCart.addProduct(Product: totalProducts[4])
        self.userCart.addProduct(Product: totalProducts[6])
        self.userCart.addProduct(Product: totalProducts[2])
        self.userCart.addProduct(Product: totalProducts.last!)
        
        self.userCart.removeAllProducts()
        
        XCTAssertEqual(self.userCart.getNumberOfCartProducts(), 0, "User cart remove all cart products is wrong")
    }

    

}
