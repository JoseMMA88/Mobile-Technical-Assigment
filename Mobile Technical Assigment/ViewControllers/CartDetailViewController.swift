//
//  CartDetailViewController.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit
import CoreData

protocol CartDetailViewDelegate {
    func changesAtUserCart(View view: CartDetailViewController, UserCart: UserCart)
}

class CartDetailViewController: UIViewController, CartDetailTableViewDelegate {
    
    
    //MARK: Outlets
    @IBOutlet weak var cartIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    //MARK: Variables
    var userCart: UserCart?
    var moc: NSManagedObjectContext?
    var delegate: CartDetailViewDelegate?
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.delegate?.changesAtUserCart(View: self, UserCart: self.userCart!)
        }
    }
    
    
    //MARK: Methods
    
    func setUpInterface() {
        
        self.navigationController?.navigationBar.subviews.forEach({ $0.removeFromSuperview() })
        
        
        self.checkoutButton.layer.cornerRadius = 5
        let titleLabel = String(format: "Checkout %@", "\(self.userCart!.calculateTotalPrice())".toCurrencyFormat())
        self.checkoutButton.setTitle(NSLocalizedString(titleLabel, comment: "Cart total price button title"),
                                     for: .normal)
    }
    
    //MARK: Actions
    @IBAction func checkoutButtonTapped(_ sender: UIButton){
        self.userCart?.removeAllProducts()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: CartDetailTableViewDelegate
    func changesAtUserCart(View view: CartDetailTableViewController, UserCart userCart: UserCart) {
        self.userCart = userCart
        self.setUpInterface()
    }

    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowContainer" {
            let vc: CartDetailTableViewController = segue.destination as! CartDetailTableViewController
            vc.userCart = self.userCart
            vc.moc = self.moc
            vc.delegate = self
        }
    }
    
    

}
