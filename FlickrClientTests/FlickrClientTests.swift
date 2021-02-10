//
//  FlickrClientTests.swift
//  FlickrClientTests
//
//  Created by Laurentiu Rogean on 06/02/2021.
//

import XCTest
@testable import FlickrClient

class FlickrClientTests: XCTestCase {

    var repository: PhotosRepository = MockedRepository()
    
    func testSearchPhotos() {
        var testError: AppError?
        var testResponse: PhotosAPIResponse?
        
        repository.searchPhotos(tags: "test", page: 1) { result in
            switch result {
            case .failure(let error):
                testError = error
            case .success(let response):
                testResponse = response!
            }
        }
        
        XCTAssertNil(testError)
        XCTAssertNotNil(testResponse?.photos.photo)
        XCTAssertTrue(testResponse?.photos.photo.count == 1)
        
        let object = testResponse?.photos.photo.first
        XCTAssertEqual(object?.id, "12345")
        XCTAssertEqual(object?.title, "Test")
    }
    
    func testGetSizes() {
        var testError: AppError?
        var testResponse: SizesAPIResponse?
        
        repository.getSizes(photoId: "123") { result in
            switch result {
            case .failure(let error):
                testError = error
            case .success(let response):
                testResponse = response
            }
        }
        
        XCTAssertNotNil(testError)
        XCTAssertNil(testResponse)
        XCTAssertEqual(testError?.code, 0)
        XCTAssertEqual(testError?.message, "Test")
    }

}
