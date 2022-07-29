//
//  ActionsService.swift
//  
//
//  Created by Łukasz Stachnik on 29/07/2022.
//

import Foundation

enum NetworkError: String, Error {
    case missingUrl = "URL is nil"
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case redirectionError = "Redirection error"
    case clientError = "Client Error"
    case serverError = "Server Error"
    case invalidRequest = "Invalid Request"
    case unknownError = "Unknown Error"
    case dataError = "Error getting valid data."
    case jsonDecodingError = "Error when decoding the reponse"
}

struct ActionsService {
    let baseURL = "http://127.0.0.1:8080/api/actions"
    
    func getActions(completionHandler: @escaping (Result<[Action], NetworkError>) -> ()) {
        guard let url = URL(string: baseURL) else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            
            if let responseError = self.handleNetworkResponse(response: response) {
                completionHandler(.failure(responseError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            do {
                let actions = try JSONDecoder().decode([Action].self, from: data)
                completionHandler(.success(actions))
            } catch {
                completionHandler(.failure(.jsonDecodingError))
            }
        }
        task.resume()
    }
    
    func getActions() async throws -> [Action] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if #available(macOS 12.0, *) {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.unknownError }
            
            if let responseError = self.handleNetworkResponse(response: httpResponse) {
                throw responseError
            }
            
            let decodedResponse = try JSONDecoder().decode([Action].self, from: data)
            
            return decodedResponse
        }
        
        return []
    }
    
    private func handleNetworkResponse(response: HTTPURLResponse) -> NetworkError? {
        switch response.statusCode {
        case 200...299: return (nil)
        case 300...399: return (NetworkError.redirectionError)
        case 400...499: return (NetworkError.clientError)
        case 500...599: return (NetworkError.serverError)
        case 600: return (NetworkError.invalidRequest)
        default: return (NetworkError.unknownError)
        }
    }
}
