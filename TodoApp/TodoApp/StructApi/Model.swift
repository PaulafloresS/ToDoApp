//
//  Model.swift
//  TodoApp
//
//  Created by Ana Paula Flores Salinas  on 05/04/24.
//
import UIKit
import Foundation

struct AuthRequest: Codable {
    let username: String
    let password: String
}

struct SignupRequest: Codable {
    let name: String
    let username: String
    let password: String
}

struct CreateTaskRequest: Codable {
    let title: String
    let description: String
}
enum TaskStatus: String, Codable {
    case todo
    case inProgress
    case complete
}

struct UpdateTaskRequest: Codable {
    let title: String
    let description: String
    let status: TaskStatus
}

struct TaskResponse: Codable {
 
}
