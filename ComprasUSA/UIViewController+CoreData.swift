//
//  UIViewController+CoreData.swift
//  ComprasUSA
//
//  Created by Rafael Fioretti on 4/17/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//
import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate 
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
