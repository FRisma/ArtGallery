//
//  DefaultHistoryRepository.swift
//  PataTest
//
//  Created by Franco on 26/06/22.
//

import RealmSwift
import Foundation

final class DefaultHistoryRepository {
    typealias Dependencies = Any
    private let dependencies: Dependencies
    
    private var historyList: [Artwork] = []
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DefaultHistoryRepository: HistoryRepository {
    func getArtwork(id: Double) -> Artwork? {
        do {
            let engine = try Realm()
            let result = engine.objects(Artwork.self).where { $0.id == id }.first
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func getLastSeenArtwork() -> Artwork? {
        print("FRISMA - Running getLastSeenArtwork from mainThread \(Thread.isMainThread)")
        do {
            let engine = try Realm()
            let result = engine.objects(Artwork.self).last
            return result
        } catch {
            print(error)
            return nil
        }
    }
    
    func getHitstoryArtworkList() -> [Artwork] {
        print("FRISMA - getHitstoryArtworkList")
        do {
            let artworks = try Realm().objects(Artwork.self)
            var historyArray: [Artwork] = []
            for art in artworks {
                historyArray.append(art)
            }
            return historyArray
            
        } catch {
            print(error)
            return []
        }
    }
    
    func append(artwork: Artwork) {
        print("FRISMA - Running append from mainThread \(Thread.isMainThread)")
        do {
            let engine = try Realm()
            try engine.write {
                engine.add(artwork)
            }
        } catch {
            print(error)
        }
    }
}
