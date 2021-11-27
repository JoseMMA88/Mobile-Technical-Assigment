//
//  ProductListTableViewController.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit
import CoreData

class ProductListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: Variables
    var moc: NSManagedObjectContext?
    var userCart: UserCart?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.moc = appDelegate.persistentContainer.viewContext
        self.userCart = UserCart()
        
        self.setUpInterface()
    }
    
    // MARK: - Interface
    func setUpInterface(){
        self.navigationItem.title = ""
        self.navigationController!.navigationBar.backgroundColor = UIColor(named: "MainColor")
        self.tableView.backgroundColor = UIColor(named: "MainColor")
        
        // Title Label
        let textLabel = UILabel()
        textLabel.text = NSLocalizedString("Hi, shop your favorites", comment: "Hi, shop your favorites")
        
        // Cart image
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = .label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cartImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
//        imageView.image.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: 100.0, height: 100.0)
        
        // Horizontal StackView
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 50.0
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(imageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.navigationController?.navigationBar.addSubview(stackView)
        
        let parentView = self.navigationController!.navigationBar
        stackView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: (self.navigationController?.navigationBar.centerXAnchor)!).isActive = true
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
        
        if let product: Product = fetchedResultsController?.object(at: indexPath){
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
    
    @objc func cartImageTapped(sender: UITapGestureRecognizer){
        
        if sender.state == .ended {
            self.performSegue(withIdentifier: "GoToCartDetail", sender: self)
        }
    }
    
    @objc func addProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let product: Product = fetchedResultsController?.object(at: indexPath){
            self.userCart!.addProduct(Product: product)
            self.tableView.reloadData()
        }
        

    }
    
    @objc func removeProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let product: Product = fetchedResultsController?.object(at: indexPath){
            self.userCart!.removeProduct(Product: product)
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: NSFetched Request
    
    lazy var fetchedResultsController: NSFetchedResultsController<Product>? = {
        
        guard let moc = moc else { return nil }

        let fetchRequest: NSFetchRequest = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: "type",
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch{
            print(error)
        }
        
        return fetchedResultsController
    }()
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "GoToCartDetail"){
            let vc: CartDetailViewController = segue.destination.view as! CartDetailViewController
            vc.userCart = self.userCart
        }
    }

}

