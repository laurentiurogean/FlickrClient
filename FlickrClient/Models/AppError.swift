//
//  AppError.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 06/02/2021.
//

import Alamofire

class AppError: Error, Codable {

    let code: Int
    let message: String

    init(code: Int = 0,
         message: String = "Something went wrong") {
        self.code = code
        self.message = message
    }

    init(_ error: AFError) {
        code = error.responseCode ?? 0
        message = error.failureReason ?? "Something wrong happened"
    }

}
