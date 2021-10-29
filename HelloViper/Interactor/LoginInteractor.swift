//
//  LoginInteractor.swift
//  HelloViper
//
//  Created by Pedro Henrique on 28/10/21.
//

import Foundation
import RxSwift


protocol LoginInteractorOutput: AnyObject { //Presenter
    
    func userDidLogin(user: User)
    func errorOccured(error: Error?)

}


protocol LoginInteractorInput: AnyObject { // Ponteiro strong do Presenter
    
    func login(with login: String, and password: String)
    
}


class LoginInteractor {
    
    weak var output: LoginInteractorOutput?
    
    let disposeBag = DisposeBag()
    
}

extension LoginInteractor: LoginInteractorInput {
    
    func login(with login: String, and password: String) {
        if login == "admin" && password == "123456" {
            LoginClient.getUser(by: 3)
                .subscribe { [weak self] event in
                    if let user = event.element {
                        self?.output?.userDidLogin(user: user)
                    }
                    if let error = event.error {
                        self?.output?.errorOccured(error: error)
                    }
                }
                .disposed(by: disposeBag)
        }
    
    }
    
}
