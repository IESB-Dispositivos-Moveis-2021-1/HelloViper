//
//  LoginViewController.swift
//  HelloViper
//
//  Created by Pedro Henrique on 28/10/21.
//

import UIKit
import RxSwift
import RxSwiftExt
import RxRelay


protocol LoginViewToPresenter: AnyObject {
    
    var credentials: Observable<(login: String, password: String)> { get }
    func setLoading(_ loading: Bool)
    
}

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var credential = BehaviorRelay<(login: String, password: String)?>(value: nil);
    
    var presenter: LoginPresenterToView!
    
    let disposeBag = DisposeBag()
    
    private var user: User? {
        didSet {
            print(user?.name) //Fins didáticos
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        bind()
    }
    
    private func bind() {
        presenter.authenticatedUser.bind { [weak self] user in
            self?.user = user
        }
        .disposed(by: disposeBag)
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        guard let login = loginField.text, let password = passwordField.text else { return }
        credential.accept((login, password))
    }
    
}

extension LoginViewController: LoginViewToPresenter {
    
    var credentials: Observable<(login: String, password: String)> {
        return credential.unwrap().asObservable()
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            self.activityIndicator.startAnimating()
        }else {
            self.activityIndicator.stopAnimating()
        }
    }
    
}
