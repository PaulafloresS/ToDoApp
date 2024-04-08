//
//  APIClient.swift
//  TodoApp
//
//  Created by Ana Paula Flores Salinas  on 05/04/24.
//
import UIKit
class APIClient {
    var token: String = ""
    // MARK: REGISTRO
    func signup(signupRequest: SignupRequest, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/auth/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["name": signupRequest.name, "username": signupRequest.username, "password": signupRequest.password]
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
    func authenticate(authRequest: AuthRequest, completion: @escaping (String?) -> Void) {
        // Implementación de la función de autenticación
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username": authRequest.username, "password": authRequest.password]
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
    func createTask(createTaskRequest: CreateTaskRequest, completion: @escaping (Result<TaskResponse, Error>) -> Void) {
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/task")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["title": createTaskRequest.title, "description": createTaskRequest.description]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error!))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Autenticación exitosa, parsea el token
                if let task = try? JSONDecoder().decode(TaskResponse.self, from: data) {
                    completion(.success(task))
                } else {
                    completion(.failure(NSError()))
                }
            } else {
                // Error en la autenticación
                completion(.failure(NSError()))
            }
        }.resume()
    }
       
    // Función para obtener todas las tareas
    func getAllTasks(completion: @escaping (Result<[TaskResponse], Error>) -> Void) {
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/task")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error!))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Autenticación exitosa, parsea el token
                if let tasks = try? JSONDecoder().decode([TaskResponse].self, from: data) {
                    completion(.success(tasks))
                } else {
                    print("err json")
                    completion(.failure(NSError()))
                }
            } else {
                // Error en la autenticación
                print("err auth")
                completion(.failure(NSError()))
            }
        }.resume()
    }
    // Función para actualizar una tarea existente con el nuevo estado
    func updateTask(id: String, newStatus: TaskStatus, request: UpdateTaskRequest, completion: @escaping (Result<TaskResponse, Error>) -> Void) {
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/task/\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Actualizar el estado en la solicitud
        let updatedRequest = UpdateTaskRequest(title: request.title,
                                               description: request.description,
                                               status: newStatus)
        do {
            // Convertir el objeto UpdateTaskRequest a datos JSON
            let requestBody = try JSONEncoder().encode(updatedRequest)
            urlRequest.httpBody = requestBody
            
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    completion(.failure(error!))
                    return
                }
                if httpResponse.statusCode == 200 {
                    // Tarea actualizada exitosamente, parsea la respuesta
                    if let responseData = data {
                        do {
                            let updatedTask = try JSONDecoder().decode(TaskResponse.self, from: responseData)
                            completion(.success(updatedTask))
                        } catch {
                            print("Error decoding response data: \(error.localizedDescription)")
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(NSError(domain: "APIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response data"])))
                    }
                } else {
                    // Error al actualizar la tarea
                    print("Error updating task. Status code: \(httpResponse.statusCode)")
                    completion(.failure(NSError(domain: "APIClient", code: httpResponse.statusCode, userInfo: nil)))
                }
            }.resume()
        } catch {
            print("Error encoding request body: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    // Función para eliminar una tarea
    func deleteTask(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "https://todo-app-bmna.onrender.com/api/task/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error!))
                return
            }
            if httpResponse.statusCode == 204 {
                // Tarea eliminada exitosamente
                completion(.success(()))
            } else {
                // Error al eliminar la tarea
                print("Error deleting task. Status code: \(httpResponse.statusCode)")
                completion(.failure(NSError(domain: "APIClient", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }
    func setToken(token: String) {
        self.token = token;
    }
    
}

let apiClient = APIClient()
