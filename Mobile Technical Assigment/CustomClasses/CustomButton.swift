//
//  CustomButton.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import UIKit

class CustomButton: UIButton {

    var indexPath: IndexPath?

    convenience init(indexPath: IndexPath) {
        self.init()
        self.indexPath = indexPath
    }

}
