//
//  File.swift
//  
//
//  Created by Franco on 26/06/22.
//

import Foundation

public protocol HTTPBody {
    /// A Boolean value indicating whether the body has no data.
    var isEmpty: Bool { get }
    
    /// Encodes an instance of the indicated type.
    func encode() throws -> Data?
}

public extension HTTPBody {
    var isEmpty: Bool { return false }
}

public extension HTTPBody where Self: Encodable {
    func encode() throws -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

public struct EmptyBody: HTTPBody {
    public let isEmpty = true

    public init() {}
    public func encode() throws -> Data? { nil }
}

public struct JSONBody: HTTPBody {
    public let isEmpty = false
    public var additionalHeaders = [
        "Content-Type": "application/json; charset=utf-8"
    ]
    
    private let encodes: () throws -> Data
    
    public init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        encodes = { try encoder.encode(value) }
    }
    
    public func encode() throws -> Data? { return try encodes() }
}

public struct DataHTTPBody: HTTPBody {
    private var jsonObject: Any
    
    public let isEmpty = false
    
    public func encode() throws -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            preconditionFailure("Attempt to serialise invalid data")
        }
        return data
    }
    
    public init(jsonObject: Any) {
        self.jsonObject = jsonObject
    }
}
