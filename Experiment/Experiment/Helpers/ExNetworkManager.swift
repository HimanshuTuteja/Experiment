//
//  ExNetworkManager.swift
//  Experiment
//
//  Created by Himanshu Tuteja on 22/07/19.
//  Copyright © 2019 Himanshu Tuteja. All rights reserved.
//

import Foundation


public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}


public protocol RequestType {
    associatedtype ResponseType: Codable
    var data: RequestData { get }
}

public protocol NetworkDispatcher {
    func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void)
}

public enum ConnError: Error {
    case invalidURL
    case noData
}

public struct RequestData {
    public let path: String
    public let method: HTTPMethod
    
    public init (path: String,method: HTTPMethod = .get) {
        self.path = path
        self.method = method
    }
}

public struct URLSessionNetworkDispatcher: NetworkDispatcher {
    public static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    public func dispatch(request: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) {
        guard let url = URL(string: request.path) else {
            onError(ConnError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            guard let _data = data else {
                onError(ConnError.noData)
                return
            }
            onSuccess(_data)
            }.resume()
    }
}

public extension RequestType {
    func execute (dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance, onSuccess: @escaping (ResponseType) -> Void, onError: @escaping (Error) -> Void) {
        dispatcher.dispatch(request: self.data, onSuccess: { (responseData: Data) in
            do {
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(ResponseType.self, from: responseData)
                DispatchQueue.main.async {
                    onSuccess(result)
                }
            } catch let error {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        }, onError: { (error: Error) in
            DispatchQueue.main.async {
                onError(error)
            }
        })
    }
}
