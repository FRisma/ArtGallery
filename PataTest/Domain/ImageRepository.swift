//
//  ImageRepository.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import PataCore
import Foundation

protocol ImageRepositoryProvider {
    var imageRepository: ImageRepository { get }
}

protocol ImageRepository {
    func imageFor(imageId: String?, quality: ImageQuality) -> PataImage?
}


enum ImageQuality {
    case low
    case mid
    case high
}
