//
//  ArticImageRepository.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import PataCore
import Foundation

final class ArticImageRepository: ImageRepository {
    private let imageApiEndpoint = "https://www.artic.edu/iiif/2"
    
    func imageFor(imageId: String?, quality: ImageQuality) -> PataImage? {
        guard let imageId = imageId,
              let imageURL = URL(string: "https://www.artic.edu/iiif/2/\(imageId)/full/\(quality.getQueryParamValue())/0/default.jpg")
        else { return nil }
        return PataImage.remote(url: imageURL)
    }
}

private extension ImageQuality {
    func getQueryParamValue() -> String {
        switch self {
        case .low: return "200,"
        case .mid: return "843,"
        case .high: return "1686,"
        }
    }
}
