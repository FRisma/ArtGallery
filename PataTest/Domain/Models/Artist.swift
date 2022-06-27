//
//  Artist.swift
//  PataTest
//
//  Created by Franco on 27/06/22.
//

import Foundation

struct Artist: Decodable {
    let id: Double?
    let title: String
    let description: String?
    let birthDate: Int?
    let birthPlace: String?
    let deathDate: Int?
    let deathPlace: String?
}
