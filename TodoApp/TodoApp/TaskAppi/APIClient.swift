//
//  APIClient.swift
//  TodoApp
//
//  Created by Ana Paula Flores Salinas  on 05/04/24.
//
import UIKit
class APIClient: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        registerAndAuthenticateUser()
    }
    // MARK: REGISTRO
    func register(name: String, username: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/auth/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["name": name, "username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            if httpResponse.statusCode == 200 {
                // Registro exitoso
                completion(true)
            } else {
                // Error en el registro
                completion(false)
            }
        }.resume()
    }
    // MARK: AUTENTICACION
     func registerAndAuthenticateUser() {
        let name = "name"
        let username = "user"
        let password = "password"
        // Registra al usuario
        register(name: name, username: username, password: password) { success in
            if success {
                // Registro exitoso, procede con la autenticación
                self.authenticateUser(username: username, password: password)
            } else {
                // Error en el registro
                print("Error en el registro")
            }
        }
    }
    func authenticateUser(username: String, password: String) {
        // Autentica al usuario
        authenticate(username: username, password: password) { token in
            if let token = token {
                // Autenticación exitosa
                print("Autenticación exitosa. Token: \(token)")
            } else {
                // Error en la autenticación
                print("Error en la autenticación")
            }
        }
    }
    func authenticate(username: String, password: String, completion: @escaping (String?) -> Void) {
        // Implementación de la función de autenticación
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Crea el cuerpo de la solicitud en formato JSON
        let body: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        // Realiza la solicitud
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Autenticación exitosa, parsea el token
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String {
                    completion(token)
                } else {
                    completion(nil)
                }
            } else {
                // Error en la autenticación
                completion(nil)
            }
        }.resume()
    }
    // MARK: Funciones del API
    
    // Función para crear una nueva tarea
       func createTask(request: CreateTaskRequest, completion: @escaping (Result<TaskResponse, Error>) -> Void) {
          
       }
       
       // Función para obtener todas las tareas
       func getAllTasks(completion: @escaping (Result<[TaskResponse], Error>) -> Void) {
          
       }
       
       // Función para actualizar una tarea existente
       func updateTask(id: String, request: UpdateTaskRequest, completion: @escaping (Result<TaskResponse, Error>) -> Void) {
    
       }
       
       // Función para eliminar una tarea
       func deleteTask(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
      
       }
}
