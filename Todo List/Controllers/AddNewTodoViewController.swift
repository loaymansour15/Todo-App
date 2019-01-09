//
//  AddNewTodoViewController.swift
//  Todo List
//
//  Created by Loay on 1/7/19.
//  Copyright © 2019 Loay Productions. All rights reserved.
//

import UIKit

class AddNewTodoViewController: UIViewController, UITextViewDelegate {

    // Variables
    lazy var todoItem = TodoItem()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var descTextField: UITextView!
    
    // Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descTextField.delegate = self
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        todoItem.addTodo(title: titleTextField.text!, date: dateTextField.text!, desc: descTextField.text!, isDone: false)
        showCustomAlert(title: "Saved", msg: "Your Todo Item was saved", duration: 1.0)
        
    }
    
    // Show alet to user
    func showCustomAlert(title : String, msg : String, duration: Float){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }

}
