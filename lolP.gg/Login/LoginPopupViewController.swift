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
import CryptoKit
import FirebaseDatabase

@available(iOS 13.0,*) //IOS13이상 가능하기 떄문에 사용해야 한다.
class LoginPopupViewController: UIViewController {
    
    let ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet var popup: UIView!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var googleloginBtn: GIDSignInButton!
    @IBOutlet weak var appleloginBtn: ASAuthorizationAppleIDButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet var txtuserLoginEmail: UITextField!
    @IBOutlet var txtuserLoginPassword: UITextField!
    
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [loginBtn, googleloginBtn, signUpBtn].forEach {
            $0?.layer.cornerRadius = 3
        }
        appleloginBtn.cornerRadius = 3
        appleloginBtn.addTarget(self, action: #selector(LoginPopupViewController.appleLogInButtonTapped), for: .touchDown)
    }

    
    
    //MARK: - 이메일 로그인 버튼
    @IBAction func btnActSubmit(_ sender: UIButton) {
        guard let userEmail = txtuserLoginEmail.text else { return }
        guard let userPassword = txtuserLoginPassword.text else  { return }
         
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) {
            (user, error) in
            if user != nil{
                print("로그인 성공")
                self.showDetailViewController()
            }
            else{
                print("로그인되지 않았습니다.", error?.localizedDescription ?? "")
                let confirm = UIAlertController(title: "Complete", message: "입력한 정보가 올바르지 않습니다. \(error)", preferredStyle: .alert)
                //17008 이메일 주소 에러, 17009 비밀번호 에러
                let okAction = UIAlertAction(title: "OK", style: .default)
                confirm.addAction(okAction)
                self.present(confirm, animated: false, completion: nil)
            }
        }
    }
    
    //MARK: - 애플 로그인 버튼
    @objc func appleLogInButtonTapped() {
        startSignInWithAppleFlow()
    }
    
    //MARK: - 구글 로그인 버튼
    @IBAction func googleLoginBtnAction(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
      GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }

          guard let email = user?.profile?.email,
                let nickName = user?.profile?.givenName,
                let pic = user?.profile?.imageURL(withDimension: 150) else {
                    return
                }
          print("구글이미지 url : \(pic)")

          guard let authentication = user?.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken:   authentication.accessToken)
          // access token 부여 받음
          // 파베 인증정보 등록
          Auth.auth().signIn(with: credential) {_,_ in
              // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
              print("로그인 됨")
              self.showDetailViewController()
            }
        }
    }
    
    //회원가입 버튼
    @IBAction func signUpBtn(_ sender: UIButton) {
        showSignUpViewController()
    }
    //MARK: - 정보화면 띄우기
    private func showDetailViewController() {
        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detailViewController = mystoryboard.instantiateViewController(identifier: "LoginDetailView")
        //이방법은 로그인창까지 겹쳐서 올라옴.
//        self.show(DetailViewController, sender: self)
        //로그인창을 닫으면서 정보창 띄우기.
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            pvc.present(detailViewController, animated: true, completion: nil)
        }
    }
    //MARK: - 회원가입창 띄우기
    private func showSignUpViewController() {
        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let signUpViewController = mystoryboard.instantiateViewController(identifier: "SignUpViewController")
        //로그인창을 닫으면서 회원가입창 띄우기.
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            pvc.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    //임시 메소드
    private func showimsiViewContollrer() {
        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let signUpViewController = mystoryboard.instantiateViewController(identifier: "TestLoginView")
        //로그인창을 닫으면서 회원가입창 띄우기.
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            pvc.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    //화면 터치시 키보드 내리기.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//MARK: Apple Login
@available(iOS 13.0, *)
extension LoginPopupViewController: ASAuthorizationControllerDelegate {

        //성공적으로 로그인을 완료했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            // 계정 정보 가져오기
            let userIdentifier = credential.user
            let fullName = credential.fullName
            let email = credential.email
            let idToken = credential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: tokeStr))")
            
            guard let nonce = currentNonce else { return }
            
            guard let appleIDToken = credential.identityToken else {
              print("Unable to fetch identity token")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            
            let credenTial = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            //애플로그인
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {
                (credentialState, error) in
                switch credentialState {
                case .authorized:
                    DispatchQueue.main.async {
                        Auth.auth().signIn(with: credenTial) {_,_ in
                            // token을 넘겨주면, 성공했는지 안했는지에 대한 result값과 error값을 넘겨줌
                            self.showimsiViewContollrer()
                            print("로그인 됨")
                        }
                    }
                    print("해당 ID는 연동되어 있습니다.")
                    break
                case .revoked, .notFound:
                    print("해당 ID는 연동되어있지 않습니다.")
                    break
                default:
                    print("해당 ID를 찾을 수 없습니다.")
                    break
                }
            }
            break
        default:
            break
        }
    }

    //에러가 있을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Credential failed with error: \(error.localizedDescription)")
    }
//
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus   \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

//MARK: 애플 로그인 텍스트 프로바이딩
@available(iOS 13.0, *)
extension LoginPopupViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
