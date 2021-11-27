//
//  DBHelper.swift
//  Mobile Technical Assigment
//
//  Created by Jose Manuel Malagón Alba on 27/11/21.
//

import Foundation
import CoreData

public class DBHelper {
    
    static var moc: NSManagedObjectContext?
    
    static func addCartProduct(ByProduct product: Product) -> CartProduct?{
        
        guard let moc = self.moc else { return nil }
        
        let entityCartProduct = NSEntityDescription.entity(forEntityName: "CartProduct", in: moc)
        
        if let objectCartProduct = NSManagedObject(entity: entityCartProduct!, insertInto: moc ) as? CartProduct{
            objectCartProduct.product = product
            objectCartProduct.quantity = 1
            
            return objectCartProduct
        }
        
        return nil
    }
    
    static func deleteCartProduct(ByProduct product: Product) {
        
        if let productCart = self.getCartProduct(ByProduct: product){
            self.moc!.delete(productCart)
        }
    }
    
    
    static func getAllCartProduct() -> [CartProduct]{
        
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
