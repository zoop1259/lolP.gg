//
//  LoginDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/22.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginDetailView: UIViewController {
    
    @IBOutlet var userId: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var passwordReset: UIButton!
    @IBOutlet var userImg: UIImageView!
    
    let storage = Storage.storage().reference() //스토리지 레퍼런스 초기화
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    let imagePickerController = UIImagePickerController()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let ref = Firestore.firestore().collection("users")
    
        //프로필 사진 ui설정
        userImg.contentMode = .scaleAspectFit
        userImg.image = UIImage(systemName: "person")
        userImg.tintColor = .white
        userImg.layer.masksToBounds = true
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.layer.borderWidth = 2
        userImg.layer.borderColor = UIColor.white.cgColor
        
        //이미지 눌렀을때
        userImg.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        userImg.addGestureRecognizer(gesture)
        
        //로그인 확인.
        if let user = Auth.auth().currentUser {
            print("당신의 \(user.uid), email: \(user.email ?? "no email")")
        }
    }
    
    //프로필사진 변경?
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //로그인이 이메일로 환영하기 위함
        //그러나 이 방식은 애플로그인단계에서 이메일가리기로 로그인을하면 문제가 생긴다.
        if let user = Auth.auth().currentUser {
            userId.text = ("\(user.uid)")
            userEmail.text = ("\(user.email ?? "이메일가린 애플유저")")
        
            //userName.text = ("\()")
//            userName.text = ("\(user.name ?? "유저")")
        }
        //이메일 초기화
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        //이메일 로그인이 아니라면 비밀번호 변경 버튼은 사라져야 한다.
        passwordReset.isHidden = !isEmailSignIn
    }
    
    func changenickName() {
        //프로필 이미지 받아오기.
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
        let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with:url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.userImg.image = image
            }
        })
        task.resume()
    }
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            //로그아웃과 동시에 뷰 닫기
            print("로그아웃 성공")
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("에러 발생")
        }
    }
    
    
    //나중에 이걸 다른 VC로 묶을지...
    @IBAction func tappasswordResetBtn(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        //비밀번호를 재설정할 수 있는 이메일로 넘어간다.
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    //닉네임변경 버튼 눌렀을떄 VC를 만들어야함.
    @IBAction func nickNameUpdateBtn(_ sender: Any) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "토끼"
        changeRequest?.commitChanges { _ in
            //UITextField를 사용해서 입력받은 값을 넣는게 좋을것이다.
            //버튼을 누르면 토끼가들어감. 나중엔 표시를 저렇게 개발해야한다.>> 없으면 이메일을, 그것도 없으면 그냥 고객으로 표시
            let displayName = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? "고객"
            self.userName.text = ("\(displayName)")
        }
    }
}

extension LoginDetailView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 사진",
                                            message: "업로드 방법을 선택해 주세요.",
                                            preferredStyle: .actionSheet)
        //아래서부터 위로.(스택)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "카메라 촬영", style: .default, handler: {[weak self] _ in self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "라이브러리", style: .default, handler: {[weak self] _ in
            self?.presentLibrary()
        }))

        present(actionSheet, animated: true)

    }

    func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func presentLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    //사용자가 사진을 찍거나 사진을 선택할 때 호출된다.
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
//
//        //여기 해제
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
//
//
//        //upload image data
//        // get download url
//        //save download url to userDefaults
//    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




/*
 //회원탈퇴
 private func loadDeleteFirebase()
     {
         let user = Auth.auth().currentUser
         user?.delete(completion: { (error) in
             guard error == nil else
             {
                 if let errorCode : AuthErrorCode = AuthErrorCode(rawValue: error!._code)
                 {
                     print("delete -> error -> \(errorCode.rawValue)")
                 }
                 return
             }
             return
         })
     }
 */
