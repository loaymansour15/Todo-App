//
//  ShowTodoViewController.swift
//  Todo List
//
//  Created by Loay on 1/7/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit
import CoreData

class ShowTodoViewController: UIViewController {

    // Variables
    var titleS = ""
    var dateS = ""
    var descS = ""
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var descTF: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTF.text = titleS
        dateTF.text = dateS
        descTF.text = descS
    }

    @IBAction func updateButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        request.returnsObjectsAsFaults = false
        do {
            
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let temp = data.value(forKey: "title") as! String
                if temp == titleTF.text{
                    data.setValue(dateTF.text, forKey: "date")
                    data.setValue(descTF.text, forKey: "desc")
                    try context.save()
                    break
                }
            }
            
            showCustomAlert(title: "Updated", msg: "You have updated your Todo", duration: 1.0)
        } catch {
            
            print("Failed")
        }
    }
    
    // Show alet to user
    func showCustomAlert(title : String, msg : String, duration: Float){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
}
