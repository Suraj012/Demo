//
//  APIClient.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

public protocol APIProtocol: AnyObject {
    func cancel()
}

public protocol APIClient: APIProtocol {
    func send<T: Encodable>(_ encodableObject: T, path: String, completion: @escaping ResultCallback<Data>)
}

public extension APIClient {
    func send<T: Encodable>(_ encodableObject: T, path: String, completion: @escaping ResultCallback<Data>) {
        self.send(encodableObject, path: path, completion: completion)
    }
}

public class DefaultAPIClient: NSObject, APIClient {
    private var baseUrl = ""
    
    private var session: URLSession {
        get {
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 20.0
            sessionConfig.timeoutIntervalForResource = 40.0
            let session = URLSession(configuration: sessionConfig)
            return session
        }
    }
    private var task: URLSessionDataTask?
    
    public override init() {
        super.init()
        self.baseUrl = WebService.baseUrl
    }
    
    public func send<T: Encodable>(_ encodableObject: T, path: String, completion: @escaping ResultCallback<Data>) {
        guard Reachability.isConnectedToNetwork() else {
            completion(.failure(APIError.unreachable))
            return
        }
        let absolutePath = "\(baseUrl)\(path)"
        guard let url = URL(string: absolutePath) else {
            return
        }
        let task = session.dataTask(with: url) { [weak self] (data, _ , _) -> Void in
            guard let data = data else {
                completion(.failure(APIError.unknown))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
}

public extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let parametersData = try JSONEncoder().encode(self)
        let parameters = try JSONSerialization.jsonObject(with: parametersData, options: []) as? [String: Any]
        
        return parameters ?? [:]
    }
}

public extension Data {
    func decode<T: Decodable>(to type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/M/yyyy h:mm:ss a"
            return formatter
        }()
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try decoder.decode(T.self, from: self)
    }
}
