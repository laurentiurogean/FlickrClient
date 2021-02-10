//
//  Certificates.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 10/02/2021.
//

import Foundation

struct Certificates {
    
    static let certificate: SecCertificate = Certificates.certificate(filename: "flickr.com")
  
    private static func certificate(filename: String) -> SecCertificate {
        
        let filePath = Bundle.main.path(forResource: filename, ofType: "der")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        
        return certificate
  }
}
