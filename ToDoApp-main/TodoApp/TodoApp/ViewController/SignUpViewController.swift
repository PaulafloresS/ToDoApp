//
//  SignUpViewController.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 05/04/24.
//
import UIKit
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    var name: String = ""
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.name = sender.text!
        }
    }
    
    @IBAction func usernameFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.username = sender.text!
        }
    }
    
    @IBAction func passwordFieldChange(_ sender: UITextField) {
        if (sender.text != nil) {
            self.password = sender.text!
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if (username == "" || password == "" || name == "") {
            self.showMissingFieldsAlert()
            return
        }
        let signupRequest = SignupRequest(name: name, username: username, password: password)
        apiClient.signup(signupRequest: signupRequest) { [self] result in
            switch result {
            case .success():
                showSuccessfulSignUpAlert()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Campos vacíos", message: "Por favor llena los campos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessfulSignUpAlert() {
        let alertController = UIAlertController(title: "Registro exitoso", message: "El registro fue exitoso", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
