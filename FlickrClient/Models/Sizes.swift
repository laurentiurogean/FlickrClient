//
//  Sizes.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 09/02/2021.
//

struct SizesAPIResponse: Codable {
    var sizes: Sizes?
}

struct Sizes: Codable {
    var canblog: Int?
    var canprint: Int?
    var candownload: Int
    var size: [Size]?
}
