//
//  ResponseTypes.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 22.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import UIKit

public enum Result<T> {
    case success(T)
    case failure(ACError)
}


struct BaseBoolResponse: Codable {
    var success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case success
    }
}

struct UsernameExistsResponse: Codable {
    var exists: Bool
    
    enum CodingKeys: String, CodingKey {
        case exists = "data"
    }
}

struct ProfileResponse: Decodable {
    var profile: Profile
    
    enum CodingKeys: String, CodingKey {
        case profile = "data"
    }
}

struct BoolResponse: Codable {
    var data: Bool
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}


