//
//  CartDetailViewController.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit

class CartDetailViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var cartIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    //MARK: Variables
    var userCart: UserCart?
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    //MARK: Actions
    @IBAction func checkoutButtonTapped(_ sender: UIButton){
        
    }

    

}
