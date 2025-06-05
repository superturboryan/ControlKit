//
//  DAO.swift
//  ControlKit
//

import Foundation

/// 💾 Describes a data access object used for persisting an item of generic `Codable` type.
/// - Parameters:
///   - codingKey: key used to encode + decode persisted object
public protocol DAO<DataType>: AnyObject {
    
    associatedtype DataType: Codable
    
    var codingKey: String { get }
    
    func get() throws -> DataType
    func save(_ value: DataType) throws
    func delete() throws
}

public enum UserDefaultsDAOError: Error {
    case noData(key: String)
    case decodingError(underlying: Error)
    case encodingError(underlying: Error)
}

public final class UserDefaultsDAO<T: Codable>: DAO {
    public typealias DataType = T
    
    public let codingKey: String
    
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    public init(
        _ codingKey: String,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.codingKey = codingKey
        self.jsonEncoder = encoder
        self.jsonDecoder = decoder
    }
    
    public func get() throws -> T {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: codingKey) else {
            throw UserDefaultsDAOError.noData(key: codingKey)
        }
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw UserDefaultsDAOError.decodingError(underlying: error)
        }
    }
    
    public func save(_ value: T) throws {
        do {
            let data = try jsonEncoder.encode(value)
            UserDefaults.standard.set(data, forKey: codingKey)
        } catch {
            throw UserDefaultsDAOError.encodingError(underlying: error)
        }
    }
    
    public func delete() throws {
        UserDefaults.standard.removeObject(forKey: codingKey)
    }
}
