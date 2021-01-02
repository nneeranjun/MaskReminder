//
//  ModelData.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/26/20.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var locations: [Location] = load("SavedLocations")
    private let limit = 4
    
    public var locationLimit: Int {
        limit
    }
    
    public var isFull: Bool {
        locations.count == limit
    }
    
    public var isEmpty: Bool {
        locations.count == 0
    }
    
    
    
    public func save(_ location: Location) throws {
        for loc in locations {
            if loc.name == location.name {
                throw SaveError.DuplicateName
            } else if loc.latitude == location.latitude && loc.longitude == location.longitude {
                throw SaveError.DuplicateLocation
            }
        }
        locations.append(location)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(locations) {
            UserDefaults.standard.set(data, forKey: "SavedLocations")
        } else {
            throw SaveError.SystemError
        }
    }
    
    public func delete(index: Int) throws {
        if index < 0 || index >= locations.count {
            throw DeleteError.NonExistant
        }
        locations.remove(at: index)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(locations) {
            UserDefaults.standard.set(data, forKey: "SavedLocations")
        } else {
            throw DeleteError.SystemError
        }
    }
    
}

func load<T: Decodable>(_ key: String) -> T {
    let decoder = JSONDecoder()
    do {
        if let data = UserDefaults.standard.data(forKey: key), let arr = try decoder.decode([Location]?.self, from: data) {
            return arr as! T
        } else {
            return [] as! T
        }
    } catch {
        print(error)
        return [] as! T
    }
}
