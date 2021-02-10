//
//  Photo.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 07/02/2021.
//

struct Photo: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
        case imageUrl = "url_q"
    }
    
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var isPublic: Int?
    var isFriend: Int?
    var isFamily: Int?
    var imageUrl: String?
    var searchString: String?
}
