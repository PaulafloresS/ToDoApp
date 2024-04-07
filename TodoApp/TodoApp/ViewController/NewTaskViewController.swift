//
//  NewTaskViewController.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 05/04/24.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    var titles : String = ""
    var descriptions : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func titleFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.titles = sender.text!
        }
    }
    
    
    @IBAction func descriptionFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.descriptions = sender.text!
        }
    }
    
    @IBAction func newSaveButtonPressed(_ sender: UIButton) {
        print("hey")
        if (titles == "" || descriptions == "") {
            return
        }
        print("hi")
        let createTaskRequest = CreateTaskRequest(title: titles, description: descriptions)
        apiClient.createTask(createTaskRequest: createTaskRequest) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let task):
                    print("task", task)
                    self.titleField.text = ""
                    self.descriptionField.text = ""
                case .failure(let err):
                    print("err")
                }
            }
        }
    }
    
}

