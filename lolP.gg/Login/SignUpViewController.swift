//
//  SignUpViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/22.
//

import UIKit
import Firebase
import FirebaseDatabase //db
import FirebaseAuth //인증
import Toast_Swift //인스턴스메세지
import FirebaseCore
//import FirebaseStorage //이미지 저장소

class SignUpViewController: UIViewController, UITextFieldDelegate {

    let ref: DatabaseReference! = Database.database().reference() //리얼타임db 레퍼런스 초기화
    //let storage = Storage.storage().reference() //스토리지 레퍼런스 초기화
    //public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    //let imagePickerController = UIImagePickerController()
    //var selectedImage: UIImage?
    //@IBOutlet weak var imgProfilePicture: UIImageView!
    
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet var txtNickName: UITextField!

    
    //뷰 컨트롤러의 멤버변수
    var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //프로필 사진 ui설정
//        imgProfilePicture.contentMode = .scaleAspectFit
//        imgProfilePicture.image = UIImage(systemName: "person")
//        imgProfilePicture.tintColor = .gray
//        imgProfilePicture.layer.masksToBounds = true
//        imgProfilePicture.layer.cornerRadius = imgProfilePicture.frame.height/2
//        imgProfilePicture.layer.borderWidth = 2
//        imgProfilePicture.layer.borderColor = UIColor.lightGray.cgColor
        
        // 각 라이브러리에 대한 델리게이트 연결
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        txtNickName.delegate = self
        
        
    }
    
    //라이브러리 업로드버튼
//    @IBAction func uploadBtn(_ sender: UIButton) {
//        didTapChangeProfilePic()
//    }
//    @objc private func didTapChangeProfilePic() {
//        presentPhotoActionSheet()
//    }
    
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
        guard let email = txtUserEmail.text,
              let password = txtPassword.text,
              let passwordConfirm = txtPasswordConfirm.text,
              let nickName = txtNickName.text else {
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
        guard password != ""
                && passwordConfirm != ""
                && password == passwordConfirm else {
                    self.view.makeToast("❌패스워드가 일치하지 않습니다.", duration: 1.0, position: .center)
            return
        }
        
           //실질적 정보 post
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
    
            //그 밖에 회원가입 에러 핸들링
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.handleError(error)
                return
            } else {
    
               if let user = result?.user {
                   
                   self.ref.child("users/\(user.uid)/nickName").setValue(nickName)
                   
                    let confirm = UIAlertController(title: "Complete", message: "\(email) 회원가입이     완료되었습니다.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let detailViewController = mystoryboard.instantiateViewController(identifier:   "LoginDetailView")
                        guard let pvc = self.presentingViewController else { return }
                        self.dismiss(animated: true) {
                            pvc.present(detailViewController, animated: true, completion: nil)
                        }
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



//extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func presentPhotoActionSheet() {
//        let actionSheet = UIAlertController(title: "프로필 사진",
//                                            message: "업로드 방법을 선택해 주세요.",
//                                            preferredStyle: .actionSheet)
//        //아래서부터 위로.(스택)
//        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//        actionSheet.addAction(UIAlertAction(title: "카메라 촬영", style: .default, handler: {[weak self] _ in self?.presentCamera()
//        }))
//        actionSheet.addAction(UIAlertAction(title: "라이브러리", style: .default, handler: {[weak self] _ in
//            self?.presentLibrary()
//        }))
//
//        present(actionSheet, animated: true)
//
//    }
//
//    func presentCamera() {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true)
//    }
//
//    func presentLibrary() {
//        let picker = UIImagePickerController()
//        picker.sourceType = .photoLibrary
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true)
//    }
//
//    //사용자가 사진을 찍거나 사진을 선택할 때 호출된다.
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//        guard let imageData = image.pngData() else {
//            return
//        }
//        /*
//         /Desktop/file.png
//         */
//        storage.child("images/file.png").putData(imageData,
//                                                 metadata: nil,
//                                                 completion: {_, error in
//            guard error == nil else {
//                print("업로드 실패")
//                return
//            }
//            self.storage.child("images/file.png").downloadURL(completion: {url, error in
//                guard let url = url, error == nil else {
//                    return
//                }
//                let urlString = url.absoluteString
//                DispatchQueue.main.async {
//                    //self.label.text = urlString
//                    self.imgProfilePicture.image = image
//                }
//                print("Download URL: \(urlString)")
//                UserDefaults.standard.set(urlString, forKey: "url")
//            })
//        })
//        //upload image data
//        // get download url
//        //save download url to userDefaults
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//}
