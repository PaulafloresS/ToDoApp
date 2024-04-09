
//  NewTaskViewController.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 05/04/24.
import UIKit
class NewTaskViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var endTaskField: UITextField!
    @IBOutlet weak var creationTaskField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    
    var taskTitle : String = ""
    var taskDescription : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func titleFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.taskTitle = sender.text!
        }
    }
    
    @IBAction func descriptionFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.taskDescription = sender.text!
        }
    }
    
    @IBAction func newSaveButtonPressed(_ sender: UIButton) {
        if (taskTitle == "" || taskDescription == "") {
            self.showMissingFieldsAlert()
            return
        }
        let createTaskRequest = CreateTaskRequest(title: taskTitle, description: taskDescription)
        apiClient.createTask(createTaskRequest: createTaskRequest) { [self] result in
            switch result {
            case .success(let task):
                self.titleField.text = ""
                self.descriptionField.text = ""
            default:
                return
            }
        }        
    }
    
    func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Campos vacíos", message: "Por favor llena los campos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


