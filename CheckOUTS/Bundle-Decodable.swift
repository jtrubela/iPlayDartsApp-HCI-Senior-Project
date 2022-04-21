//
//  Bundle-Decodable.swift
//  CheckOUTS
//
//  Created by Justin Trubela on 4/16/22.
//

import Foundation


extension Bundle {
    
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project")
        }
        
        do {
            let loadedData = try JSONDecoder().decode(T.self, from: data)
            return loadedData
        } catch {
            print(error)
            fatalError("Could not decode \(file) in the project")
        }
    }
}

