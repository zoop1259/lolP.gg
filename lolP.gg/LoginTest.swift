//
//  LoginTest.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/17.
//

import Foundation
import UIKit
import AuthenticationServices
import GoogleSignIn
import Firebase

class Logintest: UIViewController {
    

    private var titleView: UILabel = UILabel()
    private var idField: UITextField = UITextField()
    private var pwField: UITextField = UITextField()
    private var loginButton: UIButton = UIButton()
    private let signInButton = ASAuthorizationAppleIDButton()
    private let googleLoginBtn = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainLayout()
        
    }
    
    private func setupMainLayout() {
        view.addSubview(titleView)
        view.addSubview(idField)
        view.addSubview(pwField)
        view.addSubview(loginButton)
        view.addSubview(signInButton)
        view.addSubview(googleLoginBtn)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        idField.translatesAutoresizingMaskIntoConstraints = false
        pwField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginBtn.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true
        titleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleView.backgroundColor = .link
        titleView.text = "LOLP.GG Login"
        titleView.font = .systemFont(ofSize: 28)
        titleView.textAlignment = .center
        
        idField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16).isActive = true
        idField.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        idField.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        idField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        idField.backgroundColor = .white
        
        pwField.topAnchor.constraint(equalTo: idField.bottomAnchor, constant: 16).isActive = true
        pwField.leadingAnchor.constraint(equalTo: idField.leadingAnchor).isActive = true
        pwField.trailingAnchor.constraint(equalTo: idField.trailingAnchor).isActive = true
        pwField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        pwField.backgroundColor = .white
        
        idField.placeholder = "Enter your ID."
        pwField.placeholder = "Enter your PW."
        
        loginButton.topAnchor.constraint(equalTo: pwField.bottomAnchor, constant: 16).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: pwField.leadingAnchor).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: pwField.trailingAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginButton.setTitle("LOGIN", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 10
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signInButton.frame = CGRect(x:0, y:0, width: 250, height: 50)
        signInButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        googleLoginBtn.addTarget(self, action: #selector(didTabGIDSignIn), for: .touchUpInside)
        googleLoginBtn.frame = CGRect(x:0, y:0, width: 250, height: 50)
        googleLoginBtn.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 16).isActive = true
        googleLoginBtn.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor).isActive = true
        googleLoginBtn.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor).isActive = true
        googleLoginBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    @objc func didTabGIDSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            
            guard let authentication = user?.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
        
            Auth.auth().signIn(with: credential) {_,_ in
                
                Logintest()
            }
        }
    }
    
    @objc func didTapSignIn() {
        //공급자를 만들어야 한다. 첫번쨰는 apple ID의 승인자.
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
       
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
}

//MARK: 애플 로그인 관련... 나중에 개발자 등록을 하고나면...
extension Logintest: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            let firstName = credential.fullName?.givenName
            let lastName = credential.fullName?.familyName
            let email = credential.email
            
            break
            
        default:
            break
            
        }
    }
}

extension Logintest: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}


