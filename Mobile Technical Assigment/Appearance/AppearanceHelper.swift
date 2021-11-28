//
//  AppearanceHelper.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import Foundation
import UIKit

class AppearanceHelper {
    
    static func addSubviewWithConstraint(toParent parentView: UIView, andChild childView: UIView, top:CGFloat, bottom:CGFloat, leading:CGFloat, trailing:CGFloat) {
        parentView.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: top)
        
        let bottomConstraint = NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: bottom)
        
        let leadingConstraint = NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: leading)
        
        let trailingConstraint = NSLayoutConstraint(item: childView, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: trailing)
        
        parentView.addConstraint(topConstraint)
        parentView.addConstraint(bottomConstraint)
        parentView.addConstraint(leadingConstraint)
        parentView.addConstraint(trailingConstraint)
    }
    
    static func center(ChildView childView: UIView, atParentView parentView: UIView) {
        
        childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        childView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    }
}
