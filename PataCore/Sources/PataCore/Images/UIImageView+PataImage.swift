//
//  UIImageView+PataImage.swift
//  
//
//  Created by Franco on 26/06/22.
//

import Kingfisher
import UIKit

extension UIImageView {
    @discardableResult
    public func setPataImage(_ pataImage: PataImage) -> DownloadTask? {
        switch pataImage {
        case .local(let name):
            self.image = UIImage(named: name)
            return nil
        case .remote(let url):
            return self.kf.setImage(with: url)
        }
    }
}
