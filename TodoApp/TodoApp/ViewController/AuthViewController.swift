//
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
        // Do any additional setup after loading the view.
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
            return
        }
        let authRequest = AuthRequest(username: username, password: password)
        apiClient.authenticate(authRequest: authRequest) { token in
            guard let token else {
                // No se pudo autenticar
                return
            }
            apiClient.setToken(token: token)
            DispatchQueue.main.async { [self] in
                performSegue(withIdentifier: idSegue, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idSegue {
        }
    }

}
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


