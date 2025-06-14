//
//  webService.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import Foundation
import Network

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum WebServiceError: Error {
    case noData
    case invalidResponse
    case invalidStatusCode(Int)
    case noInternetConnection
}

class WebService {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private(set) var isConnected: Bool = false

    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    func request<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]? = nil) async throws -> T {

        guard isConnected else {
            print("\u{1F6AB} No Internet Connection")
            throw WebServiceError.noInternetConnection
        }

        var urlRequest: URLRequest

        
        if method == .get, let params = parameters {
            var components = URLComponents(string: url)
            components?.queryItems = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            guard let urlWithParams = components?.url else {
                throw WebServiceError.invalidResponse
            }
            urlRequest = URLRequest(url: urlWithParams)
        } else {
            guard let urlObj = URL(string: url) else {
                throw WebServiceError.invalidResponse
            }
            urlRequest = URLRequest(url: urlObj)
            if let params = parameters {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
            }
        }

        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(TAConstant.accessToken)", forHTTPHeaderField: "Authorization")

        // Log request
        print("\u{1F4E4} Sending Request:")
        print("URL: \(urlRequest.url?.absoluteString ?? "")")
        print("Method: \(method.rawValue)")
        if let body = urlRequest.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            logError(WebServiceError.invalidResponse, url: url)
            throw WebServiceError.invalidResponse
        }

        // Log response
        print("\u{1F4E5} Received Response:")
        print("Status Code: \(httpResponse.statusCode)")
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("Response Body: \(jsonString)")
//        }

        switch httpResponse.statusCode {
        case 200, 201, 204:
            if httpResponse.statusCode == 204 {
                if let emptyData = "{}".data(using: .utf8) {
                    return try JSONDecoder().decode(T.self, from: emptyData)
                } else {
                    throw WebServiceError.noData
                }
            }

            guard data.count > 0 else {
                throw WebServiceError.noData
            }

            return try JSONDecoder().decode(T.self, from: data)

        case 400: logError(WebServiceError.invalidResponse, url: url, code: 400)
            throw WebServiceError.invalidResponse
        case 401: logError(WebServiceError.invalidResponse, url: url, code: 401)
            throw WebServiceError.invalidResponse
        case 403: logError(WebServiceError.invalidResponse, url: url, code: 403)
            throw WebServiceError.invalidResponse
        case 404: logError(WebServiceError.invalidResponse, url: url, code: 404)
            throw WebServiceError.invalidResponse
        case 405: logError(WebServiceError.invalidResponse, url: url, code: 405)
            throw WebServiceError.invalidResponse
        case 415: logError(WebServiceError.invalidResponse, url: url, code: 415)
            throw WebServiceError.invalidResponse
        case 422: logError(WebServiceError.invalidResponse, url: url, code: 422)
            throw WebServiceError.invalidResponse
        case 429: logError(WebServiceError.invalidResponse, url: url, code: 429)
            throw WebServiceError.invalidResponse
        case 500: logError(WebServiceError.invalidResponse, url: url, code: 500)
            throw WebServiceError.invalidResponse
        default:
            logError(WebServiceError.invalidStatusCode(httpResponse.statusCode), url: url, code: httpResponse.statusCode)
            throw WebServiceError.invalidStatusCode(httpResponse.statusCode)
        }
    }

    private func logError(_ error: Error, url: String, code: Int? = nil) {
        print("\u{274C} Error occurred for URL: \(url)")
        if let code = code {
            print("Status Code: \(code)")
        }
        print("Error: \(error.localizedDescription)")
    }
}

//for parameter
struct DictionaryEncoder {
    private let encoder = JSONEncoder()

    func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try encoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        guard let dictionary = jsonObject as? [String: Any] else {
            throw NSError(domain: "Invalid JSON", code: 0, userInfo: nil)
        }
        return dictionary
    }
}

struct EmptyResponse: Decodable {}
