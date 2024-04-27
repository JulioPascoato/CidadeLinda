//
//  UIViewController+Context.swift
//  MoviesLib
//
//  Created by Julio Pascoato on 23/04/24.
//


import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
