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
    
   
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if (username == "" || password == "" || name == "") {
            return
        }
        let signupRequest = SignupRequest(name: name, username: username, password: password)
        apiClient.signup(signupRequest: signupRequest) { done in
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
