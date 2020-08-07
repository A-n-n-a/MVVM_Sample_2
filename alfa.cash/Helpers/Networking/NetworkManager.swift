//
//  NetworkManager.swift
//  AlfaCash
//
//  Created by Anna Alimanova on 22.01.2020.
//  Copyright © 2020 Anna Alimanova. All rights reserved.
//

import UIKit

class NetworkManager {
    

    typealias Completion = ((_ success: Bool, _ error: ACError?) -> Void)?
    typealias UsernameExistsCompletion = ((_ success: Bool?, _ error: ACError?) -> Void)?
    typealias ProfileCompletion = ((_ profile: Profile?, _ error: ACError?) -> Void)?
    
    
    static func isUsernameExists(_ username: String, completion: UsernameExistsCompletion) {
        
        let param = UsernameExistsParameters(username: username)
        let request = TemplatesAPIRequest.userExists(param)
        URLSessionRestApiManager.call(method: request) { (response: Result<UsernameExistsResponse>) in
            DispatchQueue.main.async {
                switch response {
                case .success(let result):
                    completion?(result.exists, nil)
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }
    
    static func getProfile(completion: ProfileCompletion) {
        
        let param = EmptyParameters()
        let request = TemplatesAPIRequest.getProfile(param)
        URLSessionRestApiManager.call(method: request) { (response: Result<ProfileResponse>) in
            DispatchQueue.main.async {
                switch response {
                case .success(let result):
                    completion?(result.profile, nil)
                case .failure(let error):
                    completion?(nil, error)
                }
            }
        }
    }
    
    static func updateProfile(_ profile: Profile, completion: Completion) {
        
        let param = ProfileUpdateParameters(profile: profile)
        let request = TemplatesAPIRequest.updateProfile(param)
        URLSessionRestApiManager.call(method: request) { (response: Result<BaseBoolResponse>) in
            DispatchQueue.main.async {
                switch response {
                case .success:
                    completion?(true, nil)
                case .failure(let error):
                    completion?(false, error)
                }
            }
        }
    }
}
