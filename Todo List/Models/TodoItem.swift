//
//  TodoItem.swift
//  Todo List
//
//  Created by Loay on 1/7/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TodoItem{
    
    var title:String
    var date:String
    var description:String
    var isDone:Bool
    
    init() {
        self.title = ""
        self.date = ""
        self.description = ""
        self.isDone = false
    }
    
    init(_ title: String,_ date: String,_ desc: String,_ isDone: Bool) {
        self.title = title
        self.date = date
        self.description = desc
        self.isDone = isDone
    }
    
    func addTodo (title: String, date: String, desc: String, isDone: Bool) {
        self.title = title
        self.date = date
        self.description = desc
        self.isDone = isDone
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context)
        let newTodo = NSManagedObject(entity: entity!, insertInto: context)
        
        newTodo.setValue(self.title, forKey: "title")
        newTodo.setValue(self.date, forKey: "date")
        newTodo.setValue(self.description, forKey: "desc")
        newTodo.setValue(self.isDone, forKey: "isDone")
        
        do{
            try context.save()
        }catch{
            print("Error while saving")
        }
    }
    
}
