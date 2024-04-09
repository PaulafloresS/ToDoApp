//
//  HTTPClient.swift
//  TodoApp
//
//  Created by Ana Paula Flores on 08/04/24.
//

import Foundation

typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

class HTTPClient {
    
    func get(url: String, headers: [String: String], body: Codable? = nil, completionHandler: @escaping CompletionHandler) {
        request(url: url, method: "GET", headers: headers, body: body, completionHandler: completionHandler)
    }
    
    func post(url: String, headers: [String: String], body: Codable? = nil, completionHandler: @escaping CompletionHandler) {
        request(url: url, method: "POST", headers: headers, body: body, completionHandler: completionHandler)
    }
    
    func put(url: String, headers: [String: String], body: Codable? = nil, completionHandler: @escaping CompletionHandler) {
        request(url: url, method: "PUT", headers: headers, body: body, completionHandler: completionHandler)
    }
    
    func delete(url: String, headers: [String: String], body: Codable? = nil, completionHandler: @escaping CompletionHandler) {
        request(url: url, method: "DELETE", headers: headers, body: body, completionHandler: completionHandler)
    }
    
    private func request(url: String, method: String, headers: [String: String], body: Codable? = nil, completionHandler: @escaping CompletionHandler) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        for (headerField, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }
        if (body != nil) {
            request.httpBody = try? JSONEncoder().encode(body!)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { completionHandler(data, response, error) }
        }.resume()
    }
    
}
