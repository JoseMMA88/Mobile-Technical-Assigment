//
//  CartDetailTableViewController.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit
import CoreData

protocol CartDetailTableViewDelegate {
    func changesAtUserCart(View view: CartDetailTableViewController, UserCart: UserCart)
}

class CartDetailTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: Variables
    var userCart: UserCart?
    var moc: NSManagedObjectContext?
    var delegate: CartDetailTableViewDelegate?
    var appDelegate: AppDelegate?
    var _fetchedResultsController: NSFetchedResultsController<CartProduct>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        self.appDelegate = appDel
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let sectionInfo = self.fetchedResultsController?.sections![section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let sectionLabel = UILabel()
        sectionLabel.textColor = .gray
        let totalSectionPriceLabel = UILabel()
        totalSectionPriceLabel.textColor = .gray
        if let sectionInfo = self.fetchedResultsController?.sections![section] {
            sectionLabel.text = sectionInfo.name.capitalizingFirstLetter()
            totalSectionPriceLabel.text = String(self.userCart!.calculatePrice(ByType: sectionInfo.name)).toCurrencyFormat()
        }
        
        sectionLabel.frame = CGRect(origin: totalSectionPriceLabel.frame.origin, size: CGSize(width: 80.0, height: 20.0))
        totalSectionPriceLabel.frame = CGRect(origin: totalSectionPriceLabel.frame.origin, size: CGSize(width: 80.0, height: 20.0))
        
        // Horizontal StackView
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 100.0
        
        stackView.addArrangedSubview(sectionLabel)
        stackView.addArrangedSubview(totalSectionPriceLabel)
        stackView.addArrangedSubview(UIView())
        
        AppearanceHelper.addSubviewWithConstraint(toParent: headerView, andChild: stackView, top: 0.0, bottom: 0.0, leading: 20.0, trailing: 0.0)
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionTitle = ""
        
        if let sectionInfo = self.fetchedResultsController?.sections![section] {
            sectionTitle = sectionInfo.name.capitalizingFirstLetter() + " " + String(self.userCart!.calculatePrice(ByType: sectionInfo.name)).toCurrencyFormat()
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
        
        if let cartProduct: CartProduct = self.fetchedResultsController?.object(at: indexPath){
            auxCell.backgroundColor = UIColor(named: "MainColor")
            auxCell.plusView.backgroundColor = .clear
            auxCell.minusView.backgroundColor = .clear
            
            auxCell.productName.text = cartProduct.product!.name
            auxCell.productPrice.text = "\(cartProduct.product!.price)".toCurrencyFormat()
            
            let addCustomButton = auxCell.addButton as! CustomButton
            addCustomButton.indexPath = indexPath
            auxCell.addButton.addTarget(self, action: #selector(addProductToCart(_:)), for: .touchDown)
    
            auxCell.productQuantity.text = String(cartProduct.quantity)
            
            let removeCustomButton = auxCell.removeButton as! CustomButton
            removeCustomButton.indexPath = indexPath
            auxCell.removeButton.addTarget(self, action: #selector(removeProductToCart(_:)), for: .touchDown)
        }
        
    }
    
    var fetchedResultsController: NSFetchedResultsController<CartProduct>? {
        
        guard let moc = moc else { return nil }
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }

        let fetchRequest: NSFetchRequest = CartProduct.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "product.type", ascending: true), NSSortDescriptor(key: "product.name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: "product.type",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch{
            print(error)
        }
        _fetchedResultsController = fetchedResultsController
        
        return fetchedResultsController
    }
    
    
    //MARK: - Actions
    
    @objc func addProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let product: Product = self.userCart?.products[indexPath.row].product{
            self.userCart!.addProduct(Product: product)
            self.appDelegate?.saveContext()
            
            _fetchedResultsController = nil
            self.tableView.reloadData()
            self.delegate?.changesAtUserCart(View: self, UserCart: self.userCart!)
        }
        

    }
    
    
    @objc func removeProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let cartProduct: CartProduct = self.fetchedResultsController?.object(at: indexPath){
            self.userCart!.removeProduct(Product: cartProduct.product!)
            self.appDelegate?.saveContext()
            
            _fetchedResultsController = nil
            self.tableView.reloadData()
            
            self.delegate?.changesAtUserCart(View: self, UserCart: self.userCart!)
        }
    }
    

}
