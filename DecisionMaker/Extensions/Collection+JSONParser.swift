//
//  JSONParser.swift
//  DecisionMaker
//
//  Created by Amy Cheong on 16/8/20.
//

import Foundation

let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first? .appendingPathComponent("DecisionMakerDatabase")
    .appendingPathExtension("json")

extension Collection {
    
    static func loadJSON() throws -> [Collection]? {

        let foundPath = FileManager.default.fileExists(atPath: url!.path) ?  url!.path : Bundle.main.path(forResource: "DecisionMakerDatabase", ofType: "json")
        
        if let path = foundPath {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    
                    let jsonObj = try JSONDecoder().decode([Collection].self, from: data)
                    return jsonObj
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                print("Invalid filename/path.")
            }

        return nil
    }
    
    static func save(jsonObject: [Collection]) throws -> Bool {
        if let url = url {
            try JSONEncoder().encode(jsonObject).write(to: url)
            return true
        }
        
        return false
    }
}

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
