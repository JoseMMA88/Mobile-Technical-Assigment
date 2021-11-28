//
//  DBHelper.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import Foundation
import CoreData

public class DBHelper {
    
    //MARK: Variables
    static var moc: NSManagedObjectContext?
    
    
    //MARK: Methods
    static func addCartProduct(ByProduct product: Product){
        
        guard let moc = self.moc else { return }
        
        let entityCartProduct = NSEntityDescription.entity(forEntityName: "CartProduct", in: moc)
        
        if let objectCartProduct = NSManagedObject(entity: entityCartProduct!, insertInto: moc ) as? CartProduct{
            objectCartProduct.product = product
            objectCartProduct.quantity = 1
        }
    }
    
    
    static func deleteCartProduct(ByProduct product: Product) {
        
        guard let moc = moc else { return }
        
        if let productCart = self.getCartProduct(ByProduct: product){
            moc.delete(productCart)
        }
    }
    
    
    static func deleteAllCartProducts() {
        
        guard let moc = moc else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CartProduct")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try moc.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    moc.delete(objectData)
                }
            } catch let error {
                print("Detele all data in CartProduct error :", error)
            }
    }
    
    
    static func getAllCartProducts() -> [CartProduct]{
        
        guard let moc = moc else { return [] }

        let fetchRequest: NSFetchRequest = CartProduct.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "product.type", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: "product.type",
                                                                  cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch{
            print(error)
        }
        
        
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    
    static func getAllProducts() -> [Product]{
        
        guard let moc = moc else { return [] }

        let fetchRequest: NSFetchRequest = Product.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "type", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: "type",
                                                                  cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch{
            print(error)
        }
        
        return fetchedResultsController.fetchedObjects ?? []
    }
    
    
    static func getCartProduct(ByProduct product: Product) -> CartProduct?{
        
        var cartProduct: CartProduct? = nil
        guard let moc = moc else { return nil }

        let fetchRequest: NSFetchRequest = CartProduct.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "product == %@", product)
        
        do {
            cartProduct = try moc.fetch(fetchRequest).first
        }
        catch{
            print(error)
        }
        
        return cartProduct
        
    }
    
}
