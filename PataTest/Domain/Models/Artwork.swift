//
//  Artwork.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import RealmSwift
import Foundation
import PataCore

final class Artwork: Object, Decodable {
    @Persisted
    var id: Double
    @Persisted
    var title: String
    @Persisted
    var dateDisplay: String
    @Persisted
    var mainReferenceNumber: String
    @Persisted
    var artistDisplay: String
    @Persisted
    var imageId: String?
    @Persisted
    var artistId: Double?
}
