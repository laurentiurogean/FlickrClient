//
//  PhotosViewModel.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 07/02/2021.
//

import RxCocoa

class PhotosViewModel {
    
    enum Event {
        case receivedData
        case showPhoto(url: URL)
        case failed(error: AppError)
    }
    
    enum ImageLabel: String {
        case square = "Square"
        case medium = "Medium"
        case largeSquare = "Large Square"
        case small = "Small"
        case large = "Large"
        case original = "Original"
    }
    
    private(set) var event: BehaviorRelay<Event?> = BehaviorRelay(value: nil)
    private var repository: PhotosRepository
    
    private var pages = 0
    var page = 1
    var isPaginating = false
    
    var photos: [Photo]? {
        didSet {
            self.event.accept(.receivedData)
        }
    }
    
    init(repository: PhotosRepository) {
        self.repository = repository
    }
    
    func searchPhotos(tags: String) {
        repository.searchPhotos(tags: tags, page: page) { result in
            switch result {
            case .failure(let error):
                self.event.accept(.failed(error: error))
            case .success(let response):
                switch self.page {
                case 1:
                    self.photos = response?.photos.photo
                default:
                    self.photos?.append(contentsOf: response?.photos.photo ?? [])
                }
                
                self.pages = response?.photos.pages ?? 0
            }
        }
    }
    
    func getSizes(for photoID: String) {
        repository.getSizes(photoId: photoID) { result in
            switch result {
            case .failure(let error):
                self.event.accept(.failed(error: error))
            case .success(let response):
                guard let sizes = response?.sizes?.size else {
                    let error = AppError(code: 500, message: "Server error. Please try again later.")
                    self.event.accept(.failed(error: error))
                    return
                }
                
                if let url = self.imageURL(for: sizes)  {
                    self.event.accept(.showPhoto(url: url))
                } else {
                    let error = AppError(code: 500, message: "URL is missing.")
                    self.event.accept(.failed(error: error))
                }
            }
        }
    }
    
    func imageURL(for sizes: [Size]) -> URL? {
        if let urlString = sizes.filter({ $0.label == ImageLabel.original.rawValue }).first?.source {
            return URL(string: urlString)
        } else if let urlString = sizes.filter({ $0.label == ImageLabel.large.rawValue }).first?.source {
            return URL(string: urlString)
        } else if let urlString = sizes.filter({ $0.label == ImageLabel.medium.rawValue }).first?.source {
            return URL(string: urlString)
        }
        
        return nil
    }

    func prepareForNewRequest() {
        photos?.removeAll()
        page = 1
        repository.cancelOngoingRequests()
    }
    
    func paginate() {
        if page < pages {
            page += 1
        }
    }
}
