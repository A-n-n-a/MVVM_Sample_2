//
//  RequestParameters.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 22.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import Foundation

protocol ParametersProtocol {
    typealias Parameters = [String: Any]
    
    var dictionaryValue: Parameters { get }
}

struct EmptyParameters: ParametersProtocol {
    
    var dictionaryValue: Parameters {
        let data:[String : Any] = [:]
        
        return data
    }
}

struct UsernameExistsParameters: ParametersProtocol {
    var username: String
    
    var dictionaryValue: Parameters {
        let data:[String : Any] = ["login": username]
        
        return data
    }
}

struct ProfileUpdateParameters: ParametersProtocol {
    var profile: Profile
    
    var dictionaryValue: Parameters {
        let data:[String : Any] = ["id" : profile.id,
                                   "name" : profile.name,
                                   "email" : profile.email,
                                   "login" : profile.login,
                                   "language" : profile.language.rawValue,
                                   "default_fiat" : profile.fiat.rawValue]
        
        return data
    }
}
