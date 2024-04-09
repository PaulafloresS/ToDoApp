
//  AuthViewController.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 05/04/24.
//
import UIKit
class AuthViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var idSegue = "AuthScreenToTasksScreenSegue"
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func passwordFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.password = sender.text!
        }
    }
    
    @IBAction func usernameFieldChanged(_ sender: UITextField) {
        if (sender.text != nil) {
            self.username = sender.text!
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if (username == "" || password == "") {
            self.showMissingFieldsAlert()
            return
        }
        let authRequest = AuthRequest(username: username, password: password)
        apiClient.authenticate(authRequest: authRequest) { [self] result in
            switch result {
            case .success(let authResponse):
                apiClient.setToken(token: authResponse.token)
                performSegue(withIdentifier: idSegue, sender: nil)
            case .failure(let error):
                showAuthErrorAlert()
            }
        }
    }
    
    func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Campos vacíos", message: "Por favor llena los campos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAuthErrorAlert() {
        let alertController = UIAlertController(title: "Error en la Autenticación", message: "error en el nombre o contraseña", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
    
    




