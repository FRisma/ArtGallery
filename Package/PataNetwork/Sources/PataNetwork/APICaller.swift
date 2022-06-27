//
//  APICaller.swift
//  
//
//  Created by Franco on 26/06/22.
//
 
import Foundation

/// A structure that parses URLs into URLRequest from the `HTTPRequest` parts and execute the service request.
public enum APICaller {
    
    /// Function to configure and execute the request.
    /// - Parameters:
    ///   - request: A model of `HTTPRequest`
    ///   - session: An object that coordinates a group of related, network data-transfer tasks.
    ///   - completion: Result<Data, Error>
    public static func request(_ request: HTTPRequest,
                               session: URLSession,
                               completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        let configuredUrl = configureUrl(with: request)

        switch configuredUrl {
        case .success(let urlRequest):
            return execute(urlRequest, request: request, session: session) { response in
                completion(response)
            }
        case .failure(let error):
            completion(.failure(error))
            return nil
        }
    }

    /// Function to configure the `URLRequest`.
    /// - Parameter request: A `HTTPRequest` model.
    /// - Returns: In case of success it will return a `URLRequest` object configured with the `URLComponents` model; on the other hand, if it fails the return will be an `Error` object.
    private static func configureUrl(with request: HTTPRequest) -> (Result<URLRequest, Error>) {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.customHost ?? request.host
        components.path = request.path
        components.queryItems = request.parameters

        guard let url = components.url else {
            return .failure(NSError(domain: "com.frisma.pataTest", code: -1))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue

        if !request.body.isEmpty {
            do {
                let encodedBody = try request.body.encode()
                urlRequest.httpBody = encodedBody
            } catch {
                return .failure(NSError(domain: "com.frisma.pataTest", code: -2))
            }
        }
        
        return .success(urlRequest)
    }

    /// Creates a task that retrieves the contents of a URL based on the specified URL request object, and calls a handler upon completion.
    /// - Parameters:
    ///   - urlRequest: A URL load request that is independent of protocol or URL scheme.
    ///   - request: A model of `HTTPRequest`
    ///   - session: An object that coordinates a group of related, network data-transfer tasks.
    ///   - completion: Result<Data, Error>
    private static func execute(_ urlRequest: URLRequest,
                                request: HTTPRequest,
                                session: URLSession,
                                completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable {
        let task = session.dataTask(with: urlRequest) { data, response, error in
//            var httpResponse: HTTPResponse?

//            if let response = response as? HTTPURLResponse {
//                httpResponse = HTTPResponse(request: request, response: response, body: data ?? Data())
//            }

//            if let responseError = error as NSError? {
//                guard responseError.code != NSURLErrorCancelled else { return }
//                let networkErrorCode: NetworkError.Code = responseError.code == -1009 ? .noInternetConnection : .encodeBodyFailed
//                return completion(.failure(responseError)
//            }

//            guard let httpUrlResponse = response as? HTTPURLResponse else {
//                return completion(.failure(NetworkError(code: .noData, request: request, response: httpResponse, underlyingError: nil)))
//            }
//
            guard var data = data else {
                return completion(.failure(NSError(domain: "com.frisma.pataTest", code: -3)))
            }

            if data.isEmpty, let emptyJSONData = "{}".data(using: .utf8) {
                data = emptyJSONData
            }

            completion(.success(data))
        }
        task.resume()
        
        return task
    }
    
//    private static func apiErrorMessageCode(from data: Data?) -> (Int, String)? {
//        if let errorDTO = try? JSONDecoder().decode(BitsoErrorCodeDescriptionDTO.self, from: data ?? .init()), let code = Int(errorDTO.errorCode) {
//            return (code, errorDTO.description)
//        }
//
//        if let errorDTO = try? JSONDecoder().decode(StandardErrorResponse.self, from: data ?? .init()) {
//            return (errorDTO.error.code, errorDTO.error.message)
//        }
//
//        return nil
//    }
}

struct PataNetworkErrorCodeDescriptionDTO: Decodable {
    let errorCode: String
    let description: String
}

struct StandardErrorResponse: Codable {
    let success: Bool
    let error: StandardErrorPayload
    
    enum CodingKeys: String, CodingKey {
        case success
        case error
    }
}

struct StandardErrorPayload: Codable {
    let message: String
    let code: Int

    enum CodingKeys: String, CodingKey {
        case message
        case code
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode(String.self, forKey: .message)
        do {
            code = try values.decode(Int.self, forKey: .code)
        } catch {
            let stringCode = try values.decode(String.self, forKey: .code)
            code = Int(stringCode) ?? 0
        }
    }
}

public protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable {}
