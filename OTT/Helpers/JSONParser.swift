//
//  JSONParser.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import Foundation

final class JSONParser {
    
    static let shared = JSONParser()
    private init() {}
}


extension JSONParser {
    
    func parse<T: Decodable>(jsonFileName: String) throws -> T {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON file not found."])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw error
        }
    }
    
}
