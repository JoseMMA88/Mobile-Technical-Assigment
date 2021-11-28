//
//  RequestHelper.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import Foundation
import CoreData


//MARK: Completion Handlers
typealias RequestCompletionHandler = (_ data: Data?,_ error: Error?) -> Void


//MARK: Structs
struct ProductData: Codable {
    var id: Int64
    var name: String
    var price: Double
    var type: String
    
}


public class RequestHelper {    
    
    //MARK: Variables
    static let apiURL = "https://raw.githubusercontent.com/bmdevel/MobileCodeChallengeResources/main/groceryProducts.json"
    
    static func dataRequest(withCompletionHandler completion: @escaping RequestCompletionHandler) {
        let session = URLSession.shared
        
        if let url = URL(string: self.apiURL) {
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print(error)
                    completion(nil, error)
                }
                if let data = data {
                    DispatchQueue.main.async {
                        completion(data, nil)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
}
