//
//  Requester.swift
//  
//
//  Created by Franco on 26/06/22.
//

import Foundation

/// Types adopting the `ServiceRequestProtocol` protocol can be used to execute the API Requests.
public protocol RequesterProtocol {
    @discardableResult
    func request<T: Decodable>(_ request: HTTPRequest,
                               completion: @escaping (Result<T, Error>) -> Void) -> Cancellable?
    @discardableResult
    func request<T: Decodable>(_ request: HTTPRequest,
                               decoder: JSONDecoder,
                               completion: @escaping (Result<T, Error>) -> Void) -> Cancellable?
}

/// Class used to execute the API Requests.
public struct Requester: RequesterProtocol {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: ServiceRequestProtocol
    
    /// Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    /// - Parameters:
    ///   - request: A `HTTPRequest` model.
    ///   - completion: A value that represents either a success or a failure, including an associated value
    ///   in each case. where success should be an object implementing the `Decodable` protocol,
    ///   and failure will return a `NetworkError` object.
    @discardableResult
    public func request<T: Decodable>(_ request: HTTPRequest,
                                      completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return self.request(request, decoder: decoder, completion: completion)
    }
    
    /// Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    /// - Parameters:
    ///   - request: A `HTTPRequest` model.
    ///   - decoder: A `JSONDecoder` instance. Offers a way to configured decoder.
    ///   - completion: A value that represents either a success or a failure, including an associated value
    ///   in each case. where success should be an object implementing the `Decodable` protocol,
    ///   and failure will return a `Error` object.
    @discardableResult
    public func request<T: Decodable>(
        _ request: HTTPRequest,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, Error>) -> Void
    )
        -> Cancellable? {
        return APICaller.request(request, session: session) { result in
            completion(result.flatMap { data in
                do {
                    let responseObject = try decoder.decode(T.self, from: data)
                    return .success(responseObject)
                } catch {
                    return .failure(error)
                }
            })
        }
    }
    
    /// Make a raw data request
    /// - Parameters:
    ///   - request: A `HTTPRequest` model.
    ///   - completion: A `Result` object wrapping either the raw `Data` object received or a `Error` on failure.
    /// - Returns: A `Cancellable` token in case request has to be cancelled before completing
    @discardableResult
    private func requestData(
        _ request: HTTPRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Cancellable? {
        return APICaller.request(request, session: session, completion: completion)
    }
}
