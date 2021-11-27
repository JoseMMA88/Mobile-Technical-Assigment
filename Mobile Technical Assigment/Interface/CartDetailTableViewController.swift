//
//  CartDetailTableViewController.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit

class CartDetailTableViewController: UITableViewController {
    
    //MARK: Variables
    var userCart: UserCart?
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.userCart!.getNumberOfTypes()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.userCart!.splitProductsByCategory()[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        if let firstProductName = self.userCart!.splitProductsByCategory()[section].first?.name {
            sectionTitle = firstProductName.capitalizingFirstLetter() + " " + String(self.userCart!.calculatePrice(ByType: firstProductName)).toCurrencyFormat()
        }
        
        return sectionTitle
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)

        self.configure(Cell: cell, atIndexPath: indexPath)

        return cell
    }
    
    func configure(Cell cell: UITableViewCell, atIndexPath indexPath: IndexPath){
        
        let auxCell: ProductCell = cell as! ProductCell
        
        if let product: Product = self.userCart?.products?[indexPath.row].product{
            auxCell.backgroundColor = UIColor(named: "MainColor")
            auxCell.plusView.backgroundColor = .clear
            auxCell.minusView.backgroundColor = .clear
            
            auxCell.productName.text = product.name
            auxCell.productPrice.text = "\(product.price)".toCurrencyFormat()
            
            let addCustomButton = auxCell.addButton as! CustomButton
            addCustomButton.indexPath = indexPath
            auxCell.addButton.addTarget(self, action: #selector(addProductToCart(_:)), for: .touchDown)
            
            auxCell.productQuantity.text = "0"
            if let productCart = self.userCart?.getproductCart(ByProduct: product){
                auxCell.productQuantity.text = String(productCart.quantity)
            }
            
            let removeCustomButton = auxCell.removeButton as! CustomButton
            removeCustomButton.indexPath = indexPath
            auxCell.removeButton.addTarget(self, action: #selector(removeProductToCart(_:)), for: .touchDown)
        }
        
    }
    
    
    //MARK: - Actions
    
    @objc func addProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let product: Product = self.userCart?.products?[indexPath.row].product{
            self.userCart!.addProduct(Product: product)
            self.tableView.reloadData()
        }
        

    }
    
    @objc func removeProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let product: Product = self.userCart?.products?[indexPath.row].product{
            self.userCart!.removeProduct(Product: product)
            self.tableView.reloadData()
        }
    }
    

}
