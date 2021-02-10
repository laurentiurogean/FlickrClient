//
//  Reuse.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 07/02/2021.
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable where Self: UIView {
    static var nib: UINib? {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        Self.className
    }
}

extension NSObject {
    static var className: String {
        String(describing: self)
    }
}

extension UICollectionViewCell: Reusable { }
