//
//  ProductCell.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit

class ProductCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var minusView: UIView!
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
