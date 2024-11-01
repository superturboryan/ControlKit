//
//  Keychain.swift
//  ControlKit
//

import OSLog
import Security

public extension Control {
    
    /// Wrapper for device keychain aka ``Security/SecItem`` 🔐
    @propertyWrapper
    struct Keychain<T: Codable> {
        
        private let key: String
        private let defaultValue: T
        
        public init(_ key: String, default: T) {
            self.key = key
            self.defaultValue = `default`
        }
        
        public var wrappedValue: T {
            get {
                KeychainHelper.retrieveValue(for: key, as: T.self) ?? defaultValue
            }
            set {
                KeychainHelper.save(newValue, for: key)
            }
        }
    }
}

public extension Control {
    
    enum KeychainHelper {
        
        /// Save a value to the keychain.
        public static func save<T: Codable>(_ value: T, for key: String) {
            do {
                let data = try encoder.encode(value)
                
                // Delete any existing item before adding a new one
                deleteValue(for: key)
                
                let attributes = [
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrAccount: key,
                    kSecValueData: data,
                    kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
                ] as CFDictionary
                SecItemAdd(attributes, nil)
            } catch {
                log.error("Failed to save value: \(error.localizedDescription)")
            }
        }
        
        /// Retrieve a value from the keychain.
        public static func retrieveValue<T: Codable>(for key: String, as type: T.Type) -> T? {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecReturnData: true,
                kSecMatchLimit: kSecMatchLimitOne,
                kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
            ] as CFDictionary
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query, &result)
            
            do {
                guard
                    status == errSecSuccess,
                    let data = result as? Data
                else {
                    throw Error.secItemCopyMatching(status)
                }
                return try decoder.decode(T.self, from: data)
            } catch {
                log.error("Failed to retrieve value: \(error.localizedDescription)")
                return nil
            }
        }
        
        /// Delete a value from the keychain.
        public static func deleteValue(for key: String) {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
            ] as CFDictionary
            SecItemDelete(query)
        }
    }
}

private extension Control.KeychainHelper {
    
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    static let log = Logger(
        subsystem: Control.subsystem,
        category: "Keychain"
    )
    
    enum Error: LocalizedError {
        
        case secItemCopyMatching(_ status: OSStatus)
        
        var errorDescription: String? {
            switch self {
            
            case .secItemCopyMatching(let status):
                "SecItemCopyMatching failed with status: \(status)"
            }
        }
    }
}
