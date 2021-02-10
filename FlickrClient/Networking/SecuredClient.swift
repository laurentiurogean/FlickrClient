//
//  SecuredClient.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 10/02/2021.
//

import Alamofire

class SecuredClient {
    private let certificates = [
         "api.flickr.com":
           PinnedCertificatesTrustEvaluator(certificates: [Certificates.certificate],
                                            acceptSelfSignedCertificates: false,
                                            performDefaultValidation: true,
                                            validateHost: true)
       ]

       private let session: Session
       
       init(allHostsMustBeEvaluated: Bool) {
           
           let serverTrustPolicy = ServerTrustManager(
               allHostsMustBeEvaluated: allHostsMustBeEvaluated,
               evaluators: certificates
           )
           
           session = Session(serverTrustManager: serverTrustPolicy)
       }
       
       func request(_ convertible: URLRequestConvertible) -> DataRequest {
         return session.request(convertible)
       }
}
