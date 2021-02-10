//
//  SinglePhotoViewController.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 09/02/2021.
//

import UIKit

class SinglePhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    
    var imageURL: URL?
    private var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.addSubview(spinner)
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoImageView.enableZoom()
        if let imageURL = imageURL {
            photoImageView.af.setImage(withURL: imageURL, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true) { _ in
                self.spinner.removeFromSuperview()
            }
        }
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
