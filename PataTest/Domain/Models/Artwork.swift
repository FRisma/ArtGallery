//
//  Artwork.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import Foundation
import PataCore

struct Artwork: Decodable {
    let id: Double
    let title: String
    let dateDisplay: String
    let mainReferenceNumber: String
    let artistDisplay: String
    let imageId: String?
    let artistId: Double?
}
