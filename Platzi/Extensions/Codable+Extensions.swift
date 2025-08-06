//
//  Codable+Extensions.swift
//  Platzi
//
//  Created by Mohammad Azam on 7/18/25.
//

import Foundation

extension Encodable {
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    
}
