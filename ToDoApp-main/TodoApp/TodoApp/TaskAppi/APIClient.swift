//
//  APIClient.swift
//  TodoApp
//
//  Created by Ana Paula Flores Salinas  on 05/04/24.
//
import UIKit

enum APIError: Error {
    case RequestError(String)
    case ClientError(String)
}

class APIClient {
    
    let http = HTTPClient()
    
    let baseURL: String = "https://todo-app-bmna.onrender.com/api"
    var token: String = ""
    
    func signup(signupRequest: SignupRequest, completion: @escaping (Result<Void, APIError>) -> Void) {
        let url = "\(baseURL)/auth/signup"
        let headers = ["Content-Type": "application/json"]
        http.post(url: url, headers: headers, body: signupRequest) { data, response, error in
            guard let _ = data, error == nil else {
                completion(.failure(.ClientError("Error")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.ClientError("Error parsing response")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.RequestError("Error in request")))
                return
            }
            completion(.success(()))
        }
    }
    
    func authenticate(authRequest: AuthRequest, completion: @escaping (Result<AuthResponse, APIError>) -> Void) {
        let url = "\(baseURL)/auth"
        let headers = ["Content-Type": "application/json"]
        http.post(url: url, headers: headers, body: authRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.ClientError("Error")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.ClientError("Error parsing response")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.RequestError("Error in request")))
                return
            }
            guard let auth = try? JSONDecoder().decode(AuthResponse.self, from: data) else {
                completion(.failure(.RequestError("Error parsing json")))
                return
            }
            completion(.success(auth))
        }
    }

    func createTask(createTaskRequest: CreateTaskRequest, completion: @escaping (Result<TaskResponse, APIError>) -> Void) {
        let url = "\(baseURL)/task"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
        http.post(url: url, headers: headers, body: createTaskRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.ClientError("Error")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.ClientError("Error parsing response")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.RequestError("Error in request")))
                return
            }
            guard let task = try? JSONDecoder().decode(TaskResponse.self, from: data) else {
                completion(.failure(.RequestError("Error parsing json")))
                return
            }
            completion(.success(task))
        }
    }
       
    // Función para obtener todas las tareas
    func getAllTasks(completion: @escaping (Result<[TaskResponse], APIError>) -> Void) {
        let url = "\(baseURL)/task"
        let headers = ["Authorization": "Bearer \(token)"]
        http.get(url: url, headers: headers) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.ClientError("Error")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.ClientError("Error parsing response")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.RequestError("Error in request")))
                return
            }
            guard let tasks = try? JSONDecoder().decode([TaskResponse].self, from: data) else {
                completion(.failure(.RequestError("Error parsing json")))
                return
            }
            completion(.success(tasks))
        }
    }
    
    func updateTask(id: String, updateTaskRequest: UpdateTaskRequest, completion: @escaping (Result<TaskResponse, APIError>) -> Void) {
        let url = "\(baseURL)/task/\(id)"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
        http.put(url: url, headers: headers, body: updateTaskRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.ClientError("Error")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.ClientError("Error parsing response")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.RequestError("Error in request")))
                return
            }
            guard let task = try? JSONDecoder().decode(TaskResponse.self, from: data) else {
                completion(.failure(.RequestError("Error parsing json")))
                return
            }
            completion(.success(task))
        }
    }

    // Función para eliminar una tarea
    func deleteTask(id: String, completion: @escaping (Result<TaskResponse, APIError>) -> Void) {
        let url = "\(baseURL)/task/\(id)"
        let headers = ["Authorization": "Bearer \(token)"]
        http.delete(url: url, headers: headers) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.ClientError("Error")))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.ClientError("Error parsing response")))
                return
            }
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.RequestError("Error in request")))
                return
            }
            guard let task = try? JSONDecoder().decode(TaskResponse.self, from: data) else {
                completion(.failure(.RequestError("Error parsing json")))
                return
            }
            completion(.success(task))
        }
    }
    
    func setToken(token: String) {
        self.token = token;
    }
    
}

let apiClient = APIClient()
