//
//  PhotosRepository.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 07/02/2021.
//

protocol PhotosRepository: APIClient {
    func searchPhotos(tags: String, page: Int, completion: @escaping (Result<PhotosAPIResponse?, AppError>) -> Void)
    func getSizes(photoId: String, completion: @escaping (Result<SizesAPIResponse?, AppError>) -> Void)
}

class PhotosRepositoryImpl: PhotosRepository {
    var client = SecuredClient(allHostsMustBeEvaluated: true)
    
    func searchPhotos(tags: String, page: Int, completion: @escaping (Result<PhotosAPIResponse?, AppError>) -> Void) {
        performRequest(route: APIRouter.searchPhotos(tags: tags, page: page), completion: completion)
    }
    
    func getSizes(photoId: String, completion: @escaping (Result<SizesAPIResponse?, AppError>) -> Void) {
        performRequest(route: APIRouter.getSizesForPhoto(id: photoId), completion: completion)
    }
    
    func cancelCurrentRequests() {
        cancelOngoingRequests()
    }
}
