//
//  String+Extension.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//
import Foundation

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func toCurrencyFormat() -> String {
        if let numberValue = Double(self){
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            return numberFormatter.string(from: NSNumber(value: numberValue)) ?? ""
        }
        return ""
    }
}
