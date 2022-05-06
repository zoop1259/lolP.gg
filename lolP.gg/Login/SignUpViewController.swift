//
//  SignUpViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/22.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Toast_Swift
import FirebaseFirestore
//import FirebaseStorage
import PhotosUI

class SignUpViewController: UIViewController, UITextFieldDelegate {

    private let ref: DatabaseReference! = Database.database().reference()
    let db = Firestore.firestore()
   
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet var txtNickName: UITextField!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    
    //뷰 컨트롤러의 멤버변수
    var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 텍스트 필드에 대한 딜리게이트 연결 유효성 검사에서 필요함, 구현후 지워도되면 지우자.
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        txtNickName.delegate = self
        
        
    }
    
    //취소 버튼
    @IBAction func btnActCancel(_ sender: UIButton) {
        //액션 세그로 이어진 뷰컨트롤러를 사라지게해서 되돌림.
        self.dismiss(animated: true, completion: nil)
    }
    //초기화 버튼
    @IBAction func btnActReset(_ sender: UIButton) {
        //초기값으로
        txtUserEmail.text = ""
        txtPassword.text = ""
        txtPasswordConfirm.text = ""
        // -- 사진 초기화 --
    }
    //확인 버튼
    @IBAction func btnActSubmit(_ sender: UIButton) {
        //파이어베이스에 정보를 보내야됨.
        guard let userEmail = txtUserEmail.text,
              let userPassword = txtPassword.text,
              let userPasswordConfirm = txtPasswordConfirm.text,
              let userNickname = txtNickName.text else {
            return
        }
        
        //유효성 검사. 정규식을 사용하지 않음.
        guard let email = txtUserEmail.text, !email.isEmpty,
              let password = txtPassword.text, !password.isEmpty,
              let nickname = txtNickName.text, !nickname.isEmpty else {
                    self.view.makeToast("비어있는 항목이 있습니다.", duration: 1.0, position: .center)
                    return
                }
        guard let pwRange = txtPassword.text, (pwRange.count >= 8) else {
            self.view.makeToast("비밀번호는 8자 이상 입력해주세요.", duration: 1.0, position: .center)
            return
        }
        guard userPassword != ""
                && userPasswordConfirm != ""
                && userPassword == userPasswordConfirm else {
                    self.view.makeToast("❌패스워드가 일치하지 않습니다.", duration: 1.0, position: .center)
            return
        }
            
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { result, error in
            
            //그 밖에 회원가입 에러 핸들링
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.handleError(error)
                return
            } else {
                
                if let user = result?.user {
                    self.ref.child("users").child(user.uid).setValue(["ninkname": userNickname])
                    
                    let confirm = UIAlertController(title: "Complete", message: "\(userEmail) 회원가입이     완료되었습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    confirm.addAction(okAction)
                    self.present(confirm, animated: false, completion: nil)
                
                    guard let user = result?.user else { return }
                    print(user)
                }
            }
        }
    }
}


func uploadImage(image: UIImage) {

    // jpeg 파일의 퀄리티를 반으로 해서 가져오기, jpege 파일이 아니면 리턴
    guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }

    // E621E1F8-C36C-495A-93FC-0C247A3E6E5F 형식으로 이미지 이름 짓기
    let filename = NSUUID().uuidString
    let ref = Storage.storage().reference(withPath: "폴더이름은/알아서지어요/\(filename)")

    // 이미지 업로드 하기
    ref.putData(imageData, metadata: nil) { data, error in
        if let error = error {
            print("DEBUG: \(error.localizedDescription)")
            return
        }

        // 업로드한 이미지 url 가져오기
        ref.downloadURL { url, _ in
            guard let imageUrl = url?.absoluteString else { return }

            print("URL: \(imageUrl)")
        }
    }
}


//회원가입 에러핸들링.
extension AuthErrorCode {
    
    //FIRAuthErrorDomainCode=17007 //중복이메일
    //FIRAuthErrorDomainCode=17008 //이메일형식
    
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}

extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
    }
    /*
     권고하는 파이어베이스 에러핸들링 방식이라 한다.
     
     if let errorCode : AuthErrorCode = AuthErrorCode(rawValue: error!._code)
     {
         print("-> errorCode -> \(errorCode.rawValue)")
         if AuthErrorCode.emailAlreadyInUse.rawValue == errorCode.rawValue
         {
         }
     }
     
     */
    

}
