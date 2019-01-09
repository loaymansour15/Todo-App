//
//  TodolistViewController.swift
//  Todo List
//
//  Created by Loay on 1/6/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import CoreData

class TodolistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [TodoItem]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(TodolistViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black

        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTodos()
        self.tableView.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //self.myTable.reloadData()
        //refreshControl.endRefreshing()
    }

    func getTodos() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as! String
                let date = data.value(forKey: "date") as! String
                let desc = data.value(forKey: "desc") as! String
                let isDone = data.value(forKey: "isDone") as! Bool
                let todoItem = TodoItem(title, date, desc, isDone)
                
                todos.append(todoItem)
            }
            
        } catch {
            
            print("Failed")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(todos.count)
        return todos.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoid", for: indexPath) as! TodoTableViewCell
        
        let todo = todos[indexPath.row]
        
        cell.titleLabel?.text = todo.title
        cell.descriptionLabel?.text = todo.description
        cell.dateLabel?.text = todo.date
        cell.switchButton?.setOn(todo.isDone, animated: false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if editingStyle == .delete{
            
            let title = self.todos[indexPath.row].title
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            request.returnsObjectsAsFaults = false
            do {
                
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    let temp = data.value(forKey: "title") as! String
                    if temp == title{
                        context.delete(data)
                        try context.save()
                        break
                    }
                }
                
            } catch {
                
                print("Failed")
            }
            self.todos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    @IBAction func todoSwitch(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        let title = self.todos[indexPath!.row].title
        let state = (sender as AnyObject).isOn
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let temp = data.value(forKey: "title") as! String
                if temp == title{
                    data.setValue(state, forKey: "isDone")
                    try context.save()
                    break
                }
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        self.todos.removeAll()
        getTodos()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let showTodoVC = segue.destination as? ShowTodoViewController{
            let row = tableView.indexPathForSelectedRow!.row
            showTodoVC.titleS = self.todos[row].title
            showTodoVC.dateS = self.todos[row].date
            showTodoVC.descS = self.todos[row].description
        }
     }


}


