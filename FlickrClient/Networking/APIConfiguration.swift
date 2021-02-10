//
//  APIConfiguration.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 06/02/2021.
//

import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: Parameters? { get }
}
