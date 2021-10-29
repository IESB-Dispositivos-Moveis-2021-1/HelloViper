//
//  LoginClient.swift
//  HelloViper
//
//  Created by Pedro Henrique on 28/10/21.
//

import Foundation
import RxSwift
import RxAlamofire

struct LoginClient {
    
    static let kBaseURL = "https://jsonplaceholder.typicode.com"
    
    static func getUser(by id: Int) -> Observable<User> {
        return RxAlamofire.requestDecodable(.get, "\(kBaseURL)/users/\(id)")
            .map { (response, user: User) in
                /* Estamos ignorando o response apenas para
                 fins didáticos. No mundo real, o response é
                 sempre tratado adequadamente.
                 */
                return user
            }
    }
    
}
