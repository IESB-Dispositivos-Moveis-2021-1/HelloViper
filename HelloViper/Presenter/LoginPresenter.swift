//
//  LoginPresenter.swift
//  HelloViper
//
//  Created by Pedro Henrique on 28/10/21.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxRelay

protocol LoginPresenterToView: AnyObject {
    
    var authenticatedUser: Observable<User> { get }
    
    func viewDidLoad()
    
}

class LoginPresenter {
    
    weak var view: LoginViewToPresenter?
    
    var interactor: LoginInteractorInput?
    
    let disposeBag = DisposeBag()
    
    var user = BehaviorRelay<User?>(value: nil)
    
    
    func bind() {
        if let view = self.view {
            view.credentials
                .debounce(DispatchTimeInterval.seconds(3), scheduler: MainScheduler.instance)
                .bind { [weak self] (login, password) in
                    view.setLoading(true)
                    
                    self?.interactor?.login(with: login, and: password)
                }
                .disposed(by: disposeBag)
        }
    }
    
}

extension LoginPresenter: LoginPresenterToView {
    
    var authenticatedUser: Observable<User> {
        return user.asObservable().unwrap()
    }
    
    func viewDidLoad() {
        bind()
    }
    
}

extension LoginPresenter: LoginInteractorOutput {
    
    func userDidLogin(user: User) {
        view?.setLoading(false)
        self.user.accept(user)
    }
    
    func errorOccured(error: Error?) {
        view?.setLoading(false)
        debugPrint(error ?? "Deu erro") //Tratar melhor o caso de erro
    }
    
}
