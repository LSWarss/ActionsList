//
//  Action.swift
//  
//
//  Created by Łukasz Stachnik on 26/07/2022.
//

import Foundation

struct Action: Decodable, Encodable {
    let id: String
    var title: String
    var completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, completed
        case title = "name"
    }
    
    init(id: String = UUID().uuidString,
         title: String,
         completed: Bool = false) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        completed = try container.decode(Bool.self, forKey: .completed)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(completed, forKey: .completed)
    }
}

