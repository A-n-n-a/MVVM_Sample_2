//
//  TemplatesApiRequest.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 22.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import Foundation

enum TemplatesAPIRequest: RestApiMethod {
    case userExists(UsernameExistsParameters)
    case getProfile(EmptyParameters)
    case updateProfile(ProfileUpdateParameters)
    
    var data: RestApiData {
        switch self {
        case .userExists(let parameters):
            return RestApiData(url: url+Endpoints.usernameExists, httpMethod: .post, parameters: parameters)
        case .getProfile(let parameters):
            return RestApiData(url: url+Endpoints.profile, httpMethod: .get, parameters: parameters)
        case .updateProfile(let parameters):
            return RestApiData(url: url+Endpoints.profile, httpMethod: .patch, parameters: parameters)
        }
    }
}
