//
//  APIRouter.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 06/02/2021.
//

import Alamofire

enum APIRouter: APIConfiguration {
    private static let authorizationHttpHeader = "authorization"
    private static let apiKey = "f9cc014fa76b098f9e82f1c288379ea1"
    private static let format = "json"
    private static let baseUrl = "https://api.flickr.com/"
    private static let largeSquareImageParameter = "url_q"
    
    // MARK: - Routes
    case searchPhotos(tags: String, page: Int)
    case getSizesForPhoto(id: String)
    
    
    // MARK: - API Configuration
    
    var method: HTTPMethod {
        switch self {
        case .searchPhotos: return .get
        case .getSizesForPhoto: return .get
        }
    }
    
    var parameters: Parameters? {
        var parameters: Parameters = ["method": methodParam,
                                      "api_key": APIRouter.apiKey,
                                      "format": APIRouter.format,
                                      "extras": APIRouter.largeSquareImageParameter,
                                      "nojsoncallback": 1]
        
        switch self {
        case .searchPhotos(tags: let tags,page: let page):
            parameters["tags"] = tags
            parameters["page"] = page
        case .getSizesForPhoto(id: let id):
            parameters["photo_id"] = id
        }
        
        return parameters
    }
    
    var path: String {
        switch self {
        case .searchPhotos, .getSizesForPhoto: return "services/rest/"
        }
    }
    
    var headers: [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        
        return headers
    }
    
    private var methodParam: String {
        switch self {
        case .searchPhotos(tags: _, page: _):
            return "flickr.photos.search"
        case .getSizesForPhoto(id: _):
            return "flickr.photos.getSizes"
        }
    }
    
    // MARK: - URLRequest
    
    func asURLRequest() throws -> URLRequest {
        let url = try (APIRouter.baseUrl + path).asURL()
        var urlRequest = URLRequest(url: url)
        
        // Method
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        var headers: [String: String] = urlRequest.allHTTPHeaderFields ?? [:]
        headers.merge(self.headers, uniquingKeysWith: { _, last in last })
        urlRequest.allHTTPHeaderFields = headers
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}

