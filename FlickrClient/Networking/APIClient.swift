//
//  APIClient.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 06/02/2021.
//

import Alamofire

protocol APIClient {
    var client: SecuredClient { get set }
    func performRequest<T: Decodable>(route: APIRouter, completion: @escaping (Result<T, AppError>) -> Void)
    func performRequest(route: APIRouter, completion: @escaping (Result<Data?, AppError>) -> Void)
    func cancelOngoingRequests()
}

extension APIClient {
    func performRequest<T: Decodable>(route: APIRouter, completion: @escaping (Result<T, AppError>) -> Void) {
        client.request(route)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                print(response)
            })
            .responseDecodable (decoder: JSONDecoder()) { (response: AFDataResponse<T>) in
                if let error = response.error {
                    print(error)
                    completion(.failure(AppError(error)))
                } else {
                    if let statusCode = response.response?.statusCode, statusCode >= 300 { completion(.failure(AppError(code: statusCode)))
                    }
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        print(error)
                        completion(.failure(AppError(error)))
                    }
                }
            }
    }
    
    func performRequest(route: APIRouter, completion: @escaping (Result<Data?, AppError>) -> Void) {
        client.request(route)
            .responseJSON(completionHandler: { response in
                print(response)
            })
            .response { response in
                if let error = response.error {
                    print(error)
                } else {
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(AppError(error)))
                    }
                }
            }
    }
    
    func cancelOngoingRequests() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
    }
}
