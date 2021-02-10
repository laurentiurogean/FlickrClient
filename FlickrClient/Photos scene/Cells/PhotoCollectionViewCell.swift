//
//  PhotoCollectionViewCell.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 07/02/2021.
//

import UIKit
import AlamofireImage

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    private var spinner = UIActivityIndicatorView()
    
    var imageURL: URL? {
        didSet {
            photoImageView.af.setImage(withURL: imageURL!, cacheKey: nil, placeholderImage: nil, serializer: nil, filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: false) { _ in
                self.spinner.removeFromSuperview()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        spinner.startAnimating()
        spinner.center = photoImageView.center
        photoImageView.addSubview(spinner)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = nil
        spinner.startAnimating()
        photoImageView.addSubview(spinner)
    }
    
    func configure(with imageUrlString: String?) {
        if let urlString = imageUrlString {
            imageURL = URL(string: urlString)
        }
    }
}
