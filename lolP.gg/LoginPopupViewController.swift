//
//  LoginPopViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import Foundation
import UIKit
import AuthenticationServices
import GoogleSignIn
import Firebase
import FirebaseAuth

@available(iOS 13.0,*) //IOS13이상 가능하기 떄문에 사용해야 한다.
class LoginPopupViewController: UIViewController {
    
    @IBOutlet var popup: UIView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var googleloginBtn: GIDSignInButton!
    @IBOutlet weak var appleloginBtn: ASAuthorizationAppleIDButton!
    
    @IBOutlet var txtuserLoginEmail: UITextField!
    @IBOutlet var txtuserLoginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //googleloginBtn.style = .standard
        appleloginBtn.addTarget(self, action: #selector(LoginPopupViewController.appleLogInButtonTapped), for: .touchDown)
        popup.layer.cornerRadius = 30
        
//        if let user = Auth.auth().currentUser {
//            print("로그인 되어있는 상태")
//            self.showDetailViewController()
//        }
    }
    //로그인이 되어있는 상태면 바로 디테일화면으로.
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            self.showDetailViewController()
            }
    }
    
    //이메일 로그인 버튼 눌렀을때
    @IBAction func btnActSubmit(_ sender: UIButton) {
        guard let userEmail = txtuserLoginEmail.text else { return }
        guard let userPassword = txtuserLoginPassword.text else  { return }
        
//        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
//            guard self != nil else { return }
//
//            if authResult != nil {
//                print("로그인 되었습니다")
//            } else {
//                print("로그인되지 않았습니다.", error?.localizedDescription ?? "")
//            }
//        }
//    }
    
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) {
            (user, error) in
            if user != nil{
                print("로그인 성공")
                self.showDetailViewController()
            }
            else{
                print("로그인되지 않았습니다.", error?.localizedDescription ?? "")
            }
        }
    }
    
    
    //애플 버튼 눌렀을때
    @objc func appleLogInButtonTapped() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //임시 버튼. 나중에 삭제할 것.
    @IBAction func emsilogoubtn(_ sender: Any) {
            //Auth.auth().signOut()
            do {
                try FirebaseAuth.Auth.auth().signOut()
                print("로그아웃됨")
            } catch {
                print("에러 발생")
            }
        
    }
    //구글 버튼 눌렀을 때
    @IBAction func googleLoginBtnAction(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
      GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
        guard error == nil else { return }

        guard let authentication = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
        // access token 부여 받음
        
        // 파베 인증정보 등록
        Auth.auth().signIn(with: credential) {_,_ in
            // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
            print("로그인 됨")
            
            self.showDetailViewController()
            
        }
      }
    }
    
    private func showDetailViewController() {
        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let DetailViewController = mystoryboard.instantiateViewController(identifier: "LoginDetailView")
        //이방법은 로그인창까지 겹쳐서 올라옴.
//        self.show(DetailViewController, sender: self)
        //로그인창을 닫으면서 정보창 띄우기.
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            pvc.present(DetailViewController, animated: true, completion: nil)
        }
    }
}

//MARK: Apple Login
@available(iOS 13.0, *)
extension LoginPopupViewController: ASAuthorizationControllerDelegate {
    
    //성공적으로 로그인을 완료했을 때
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
    //에러가 있을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
}

//MARK: 애플 로그인 텍스트 프로바이딩
@available(iOS 13.0, *)
extension LoginPopupViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
