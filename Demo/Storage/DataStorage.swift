//
//  DataStorage.swift
//  Demo
//
//  Created by inficare on 02/02/2022.
//

import Foundation

public protocol DataStorage {
    associatedtype T
    func save(object: T, completion: @escaping ResultCallback<T>)
    func save(objects: [T], completion: @escaping ResultCallback<[T]>)
    func fetch(completion: @escaping ResultCallback<T>)
    func fetchObjects(completion: @escaping ResultCallback<[T]>)
}

public final class Cache<T: Codable>: DataStorage {
    enum CacheError: AError {
        case saveObject(T)
        case saveObjects([T])
        case fetchObject(T.Type)
        case fetchObjects(T.Type)
    }
    enum FileNames {
        static var objectFileName: String {
            return "\(T.self).dat"
        }
        static var objectsFileName: String {
            return "\(T.self)s.dat"
        }
    }
    
    private let _path: String
    
    public init(path: String) {
        self._path = path
    }
    
    public func save(object: T, completion: @escaping ResultCallback<T>) {
        guard let directoryURL = self.directoryURL() else {
            return
        }
        
        let path = directoryURL
            .appendingPathComponent(FileNames.objectFileName)
        self.createDirectoryIfNeeded(at: directoryURL)
        
        do  {
            let encodedData = try PropertyListEncoder().encode(object)
            let data = try NSKeyedArchiver.archivedData(withRootObject: encodedData, requiringSecureCoding: true)
            try data.write(to: path)
            completion(.success(object))
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func save(objects: [T], completion: @escaping ResultCallback<[T]>) {
        guard let directoryURL = self.directoryURL() else {
            return
        }
        let path = directoryURL
            .appendingPathComponent(FileNames.objectsFileName)
        self.createDirectoryIfNeeded(at: directoryURL)
        do {
            try NSKeyedArchiver.archivedData(withRootObject: objects, requiringSecureCoding: true)
                .write(to: path)
            completion(.success(objects))
        } catch {
            
        }
    }
    
    public func fetch(completion: @escaping ResultCallback<T>) {
        guard let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask).first else {
                completion(.failure(CacheError.fetchObject(T.self)))
                return
        }
        let path = url.appendingPathComponent(self._path)
            .appendingPathComponent(FileNames.objectFileName)
        
        do {
            let data = try Data(contentsOf: path)
            guard let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Data else {
                throw CacheError.fetchObject(T.self)
            }
            let products = try PropertyListDecoder().decode(T.self, from: object)
            completion(.success(products))
        } catch let error {
            print(error)
            completion(.failure(CacheError.fetchObject(T.self)))
        }
    }
    
    public func fetchObjects(completion: @escaping ResultCallback<[T]>) {
        guard let directoryURL = self.directoryURL() else {
            return
        }
        let fileURL = directoryURL
            .appendingPathComponent(FileNames.objectsFileName)
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: fileURL.path))
            guard let objects = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [T] else {
                throw CacheError.fetchObjects(T.self)
            }
            completion(.success(objects))
        } catch {
            return
        }
    }
    
    private func directoryURL() -> URL? {
        return FileManager.default
            .urls(for: .documentDirectory,
                  in: .userDomainMask)
            .first?
            .appendingPathComponent(_path)
    }
    
    private func createDirectoryIfNeeded(at url: URL) {
        do {
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Cache Error createDirectoryIfNeeded \(error)")
        }
    }
}

