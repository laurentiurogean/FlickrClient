//
//  Photos.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 07/02/2021.
//

struct PhotosAPIResponse: Codable {
    var photos: Photos
}

struct Photos: Codable {
    var page: Int?
    var pages: Int?
    var total: String?
    var photo: [Photo]
}
