//
//  MockedRepository.swift
//  FlickrClientTests
//
//  Created by Laurentiu Rogean on 09/02/2021.
//

@testable import FlickrClient

class MockedRepository: PhotosRepository {
    func searchPhotos(tags: String, page: Int, completion: @escaping (Result<PhotosAPIResponse?, AppError>) -> Void) {
        let photo = Photo(id: "12345",
                          owner: "John",
                          secret: "xx",
                          server: "xx",
                          farm: 12,
                          title: "Test",
                          isPublic: 1,
                          isFriend: 1,
                          isFamily: 1,
                          imageUrl: "url",
                          searchString: "string")
        let photos = Photos(page: 1, pages: 3, total: "3", photo: [photo])
        let response = PhotosAPIResponse(photos: photos)
        completion(.success(response))
    }
    
    func getSizes(photoId: String, completion: @escaping (Result<SizesAPIResponse?, AppError>) -> Void) {
        completion(.failure(AppError(code: 0, message: "Test")))
    }
    
    
}
