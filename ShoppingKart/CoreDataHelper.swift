//
//  CoreDataHelper.swift
//  ShoppingKart
//
//  Created by Sampada on 1/10/18.
//  Copyright © 2018 Sampada. All rights reserved.
//

import UIKit
import CoreData

struct CoreDataHelper {
    
    //adding the product to cart
    static func addCart(idProduct: String, price:Int, imgUrl:String, name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Cart",
                                                in: managedContext)!
        
        let cart = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        cart.setValue(idProduct, forKeyPath: "idProduct")
        cart.setValue(name, forKeyPath: "name")
        cart.setValue(imgUrl, forKeyPath: "url")
        cart.setValue(Int16(price), forKeyPath: "price")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    //getting all the products from cart
    static func fetchAllCarts() -> [Product]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cart")
        do {
            let carts = try managedContext.fetch(fetchRequest) as! [Cart]
            var products: [Product] = []
            for cart in carts {
                var p = Product()
                p.name = cart.name
                p.idProduct = cart.idProduct
                p.url = cart.url
                p.price = Int(cart.price)
                products.append(p)
            }
            return products
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    //delete product from Cart
    static func deleteCartItem(id:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let predicate = NSPredicate(format: "idProduct == %@", id as CVarArg)
        fetchRequest.predicate = predicate
        let result = try? managedContext.fetch(fetchRequest)
        let resultData = result as! [Cart]
        
        for object in resultData {
            managedContext.delete(object)
        }
        
        do {
            try managedContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
}
