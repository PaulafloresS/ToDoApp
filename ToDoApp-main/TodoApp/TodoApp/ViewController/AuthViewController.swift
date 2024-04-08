
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
            showAlert()
            return
        }
        let authRequest = AuthRequest(username: username, password: password)
        apiClient.authenticate(authRequest: authRequest) { token in
            guard let token else {
                self.ErrorAuth()
                return
            }
            apiClient.setToken(token: token)
            DispatchQueue.main.async { [self] in
                performSegue(withIdentifier: idSegue, sender: nil)
            }
        }
    }
    func showAlert() {
            let alertController = UIAlertController(title: "Campos vacíos", message: "Por favor llena los campos", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    func ErrorAuth() {
            let alertController = UIAlertController(title: "Error en la Autenticación", message: "error en el nombre o contraseña", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idSegue {
        }
    }
}
    
    




