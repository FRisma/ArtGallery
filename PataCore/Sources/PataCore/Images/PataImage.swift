//
//  PataImage.swift
//  
//
//  Created by Franco on 26/06/22.
//

import Foundation

public enum PataImage {
    case local(named: String)
    case remote(url: URL)
}
