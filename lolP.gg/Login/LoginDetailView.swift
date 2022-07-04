//
//  LoginDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/22.
//

import Foundation
import UIKit
//import AuthenticationServices
//import GoogleSignIn
//import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import AVFoundation

class LoginDetailView: UIViewController {
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet var userId: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var passwordReset: UIButton!
    @IBOutlet var userImg: UIImageView!
    
    var ref = Database.database().reference() //db
    let storage = Storage.storage().reference() //스토리지 레퍼런스 초기화
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    let imagePickerController = UIImagePickerController()
    var selectedImage: UIImage?
    
    //인디케이터 생성
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        return activityIndicator
    } ()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.view.addSubview(self.activityIndicator)
        //프로필 사진 ui설정
        userImg.contentMode = .scaleAspectFill
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
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraPermission()
        checkAlbumPermission()
        
        self.activityIndicator.startAnimating()
        self.userView.isHidden = true

        print("디테일화면 나온당")
        //로그인이 이메일로 환영하기 위함
        userEmail.text = Auth.auth().currentUser?.email
        userName.text = Auth.auth().currentUser?.displayName ?? "별명이없다"
        userId.text = Auth.auth().currentUser?.uid
        
        getnickName()
        loadUserImg()

        //이메일 초기화
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        //이메일 로그인이 아니라면 비밀번호 변경 버튼은 사라져야 한다.
        passwordReset.isHidden = !isEmailSignIn
    }
    
    //MARK: - 권한요청
    func checkCameraPermission() {
        let dialog = UIAlertController(title: "주의", message: "일부 기능이 동작하지 않습니다. 설정에서 확인해주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        dialog.addAction(action)
        
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("권한 허용")
            } else {
                print("권한 거부")
            }
        })
    }
    
    func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization({ status in
            switch status {
            case .authorized:
                print("앨범 권한 허용")
            case .denied:
                print("앨범 권한 거부")
            case .restricted, .notDetermined:
                print("앨범 권한 선택하지 않았거나 강제종료")
            default:
                break
            }
        })
    }
    
    //MARK: - 이미지변경
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    func loadUserImg() {
        guard let user = Auth.auth().currentUser else { return }
        DispatchQueue.global().async {
            self.ref.child("users").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
                (snapshot, error) in
                let profileimg = snapshot.value as? [String: Any] ?? [:]
                //프로필가져오기.
                if let urldata = profileimg[user.uid] as? [String:Any] {
                    //let getimg = geturl.values
                    if let urlstring = urldata["profileImageUrl"] as? String {
                        print(urlstring)
                        if let url = URL(string: urlstring) {
                            if let data = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    self.userImg.image = UIImage(data: data)
                                    self.activityIndicator.stopAnimating()
                                    self.userView.isHidden = false
                                }
                            }
                        }
                    //프로필사진이 등록되어있지 않은경우 바로 프로필화면을 보여준다.
                    } else {
                        self.activityIndicator.stopAnimating()
                        self.userView.isHidden = false
                    }
                }
            })
        }
    }
    
//MARK: - 로그아웃버튼
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
    
    
//MARK: - 암호 변경
    @IBAction func tappasswordResetBtn(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        Auth.auth().languageCode = "kr"
        //비밀번호를 재설정할 수 있는 이메일을 보냄
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
//MARK: - 닉네임 변경
    @IBAction func nickNameUpdateBtn(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }

        let alert = UIAlertController(title: "닉네임 변경", message: "닉네임을 입력해주세요.",preferredStyle: .alert)
        alert.addTextField()
        let ok = UIAlertAction(title: "OK", style: .default) { [weak alert] (ok) in
            
            let textField = alert!.textFields![0] as UITextField
            
            guard let textRange = textField.text, (textRange.count <= 12) else {
                self.view.makeToast("❌12자 이하로 입력해주세요..", duration: 1.0, position: .center)
                return
            }
            self.ref.child("users").child(user.uid).updateChildValues(["nickName" : alert?.textFields?[0].text])
            self.getnickName()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            //alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - 닉네임 가져오기.
    func getnickName() {
         guard let user = Auth.auth().currentUser else { return }
         DispatchQueue.global().async {
             self.ref.child("users").observeSingleEvent(of: .value,     andPreviousSiblingKeyWith: {
                 (snapshot, error) in
                 let nicknames = snapshot.value as? [String: Any] ?? [:]
                 //닉네임가져오기
                 if let nickkey = nicknames[user.uid] as? [String:Any] {
                     //let getnick = nickkey.values
                     if let getnick = nickkey["nickName"] as? String {
                         print(getnick)
                         DispatchQueue.main.async {
                             self.userName.text = getnick
                         }
                     }
                 }
             })
         }
     }
    
    //빈화면 터치시 키보드내림.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - 회원탈퇴
    @IBAction func signOutBtn(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }

        let alert = UIAlertController(title: "회원탈퇴", message: "정말 탈퇴하시겠습니까?",preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            user.delete { error in
                if let error = error {
                    // An error happened.
                     print("에러 발생: \(error)")
                } else {
                     // Account deleted.
                    print("회원탈퇴완료")
                    self.ref.child("users").child(user.uid).removeValue()
                    self.dismiss(animated: true, completion: nil)
                    //defer
                    let deleteImg = self.storage.child("userImages").child(user.uid)
                    deleteImg.delete { error in
                        if let error = error {
                            print("이미지 삭제 오류 \(error)")
                        } else {
                            print("모든정보 삭제됨")
                            
                        }
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            //alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}



//MARK: - 이미지피커
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let user = Auth.auth().currentUser else { return }
        
        
        //let image = self.userImg.image?.jpegData(compressionQuality: 0.1)
        let image = selectedImage.jpegData(compressionQuality: 0.1)
        //
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        Storage.storage().reference().child("userImages").child(user.uid).putData(image!, metadata: metaData) { (data, err) in
            
            print("data fetch")
            Storage.storage().reference().child("userImages").child(user.uid).downloadURL { (url, err) in
//                print("url fetch")
                
                print("url이 db에 저장됨 : \(url)")
                Database.database().reference().child("users").child(user.uid).updateChildValues(["profileImageUrl":url?.absoluteString])
                self.loadUserImg()
            }
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
