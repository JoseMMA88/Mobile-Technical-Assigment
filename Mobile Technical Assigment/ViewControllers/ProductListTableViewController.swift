//
//  ProductListTableViewController.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit
import CoreData

class ProductListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, CartDetailViewDelegate {
    
    //MARK: Variables
    var moc: NSManagedObjectContext?
    var userCart: UserCart?
    var appDelegate: AppDelegate?
    var _fetchedResultsController: NSFetchedResultsController<Product>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
    
        self.appDelegate = appDel
        self.moc = appDelegate!.persistentContainer.viewContext
        DBHelper.moc = self.moc
        
        self.userCart = UserCart()
        
        self.setUpInterface()
    }
    
    // MARK: - Interface
    func setUpInterface(){
        
        // Navigation bar
        self.navigationController?.navigationBar.subviews.forEach({ $0.removeFromSuperview() })
        self.navigationItem.title = ""
        self.navigationController!.navigationBar.backgroundColor = .clear
        
        // TableView
        self.tableView.backgroundColor = UIColor(named: "MainColor")
        
        // Title Label
        let textLabel = UILabel()
        textLabel.text = NSLocalizedString("Hi, shop your favorites.", comment: "Hi, shop your favorites.")
        
        // Count Label
        let countLabel = UILabel()
        countLabel.text = "\(self.userCart!.getNumberOfCartProducts())"
        countLabel.textAlignment = .center
        countLabel.font =  countLabel.font.withSize(12)
        countLabel.textColor = .white
        
        // Cart image
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = .label
        imageView.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: 50.0, height: 40.0))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.cartImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        let view1 = UIView()
        view1.isHidden = true
        if(self.userCart!.getNumberOfCartProducts() > 0){
            view1.isHidden = false
        }
        view1.backgroundColor = UIColor(named: "redColor")
        view1.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: 5.0, height: 10.0))
        view1.layer.cornerRadius = 10
        view1.layer.masksToBounds = true
        view1.addSubview(countLabel)
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false

        AppearanceHelper.center(ChildView: countLabel, atParentView: view1)
        
        let view = UIView()
        view.addSubview(imageView)
        
        AppearanceHelper.center(ChildView: imageView, atParentView: view)
        
        AppearanceHelper.addSubviewWithConstraint(toParent: view, andChild: view1, top: 0.0, bottom: -20.0, leading: 30.0, trailing: 0.0)
        
        // Horizontal StackView
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 50.0
        
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(view)
        
        let parentView = self.navigationController!.navigationBar
        
        AppearanceHelper.addSubviewWithConstraint(toParent: parentView,
                                                  andChild: stackView,
                                                  top: 0.0,
                                                  bottom: 0.0,
                                                  leading: 20.0,
                                                  trailing: -40.0)
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
            appDelegate?.saveContext()
            self.setUpInterface()
        }
        

    }
    
    
    @objc func removeProductToCart(_ sender: CustomButton){
        
        guard let indexPath = sender.indexPath else { return }
        
        if let product: Product = fetchedResultsController?.object(at: indexPath){
            self.userCart!.removeProduct(Product: product)
            self.tableView.reloadData()
            appDelegate?.saveContext()
            self.setUpInterface()
        }
    }
    
    
    //MARK: NSFetched Request
    
    var fetchedResultsController: NSFetchedResultsController<Product>? {
        
        guard let moc = moc else { return nil }
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController
        }

        let fetchRequest: NSFetchRequest = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
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
        _fetchedResultsController = fetchedResultsController
        
        return fetchedResultsController
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    //MARK: CartDetailViewDelegate
    func changesAtUserCart(View view: CartDetailViewController, UserCart userCart: UserCart) {
        self.userCart = userCart
        self.setUpInterface()
        
        _fetchedResultsController = nil
        self.tableView.reloadData()
        
    }
    
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "GoToCartDetail"){
            let vc: CartDetailViewController = segue.destination as! CartDetailViewController
            vc.userCart = self.userCart
            vc.moc = self.moc
            vc.delegate = self
        }
    }

}

