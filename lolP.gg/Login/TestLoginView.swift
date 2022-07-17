//
//  TestLoginView.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/06/24.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import AVFoundation


class TestLoginView: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var imageIndicator: UIActivityIndicatorView!
    
    var ref = Database.database().reference() //db
    let storage = Storage.storage().reference() //스토리지 레퍼런스 초기화
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    let imagePickerController = UIImagePickerController()
    var selectedImage: UIImage?
    let fileManager: FileManager = FileManager.default     //파일매니저 인스턴스 생성
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeuserImg()
        
        emailLabel.text = Auth.auth().currentUser?.email
        nickLabel.text = Auth.auth().currentUser?.displayName ?? "별명이없다"
        uuidLabel.text = Auth.auth().currentUser?.uid
        
        settingimg()
        
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
    }
    
    func settingimg() {
        if let url = Auth.auth().currentUser?.photoURL {
            do {
                let imgData = try Data(contentsOf: url)
                if let image = UIImage(data: imgData) {
                    DispatchQueue.main.async {
                        self.userImg.image = image
                        self.imageIndicator.stopAnimating()
                    }
                }
            } catch {
                debugPrint("From catch block: Image could not be downloaded !!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getnickName()
        //changeuserImg()
        
        if Auth.auth().currentUser?.displayName == nil {
            
            let alert = UIAlertController(title: "최초 닉네임 설정", message: "닉네임을 입력해주세요.",preferredStyle: .alert)
            //텍스트필드 속성
            alert.addTextField() { field in
                field.placeholder = "닉네임 변경"
                field.keyboardType = .emailAddress
                
            }
            let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
                guard let fields = alert.textFields, fields.count == 1 else { return }
                let nicknameField = fields[0]
                
                guard let text = nicknameField.text, !text.isEmpty else { return }
                let change = Auth.auth().currentUser?.createProfileChangeRequest()
                change?.displayName = text
                change?.commitChanges { _ in
                }
                print(text)
                self.nickLabel.text = text
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
                //alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - 이미지변경
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    func changeuserImg() {
        guard let user = Auth.auth().currentUser else { return }
        DispatchQueue.global().async {
            self.ref.child("users").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
                (snapshot, error) in
                let profileimg = snapshot.value as? [String: Any] ?? [:]
                //닉네임가져오기
                if let urldata = profileimg[user.uid] as? [String:Any] {
                    //let getimg = geturl.values
                    if let urlstring = urldata["profileImageUrl"] as? String {
                        print(urlstring)
                        
                        let documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let filePath = documentsURL.appendingPathComponent("userImage")
                        
                        if !self.fileManager.fileExists(atPath: filePath.path) {
                        do {
                            try
                            self.fileManager.createDirectory(atPath:filePath.path,
                                                        withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                NSLog("Couldn't create document directory")
                            }
                        }
                        
                        if let url = URL(string: urlstring) {
                            if let data = try? Data(contentsOf: url) {
                                
                                let image: UIImage = UIImage(data: data) ?? UIImage(systemName: "person") as! UIImage
                                
                                let filename = filePath.appendingPathComponent("userImage.png")
                                try? data.write(to: filename)
                                print("파일 폴더 url: \(filePath)")
                                print("파일 url: \(filename)")
                                //filepath의 image를 불러와서 넣어주면된다.
                                do {
                                    let imageData = try Data(contentsOf: filename)
                                    DispatchQueue.main.async {
                                        self.userImg.image = UIImage(data: imageData)
                                    }
                                    print(imageData)
                                } catch let err as NSError {
                                    print(err)
                                }
//                                DispatchQueue.main.async {
//                                    self.userImg.image = UIImage(data: data)
//                                    //self.activityIndicator.stopAnimating()
//                                    //self.userView.isHidden = false
                                
                            }
                        }
                    }
                }
            })
        }
    }
    
//MARK: - 로그아웃버튼
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            //로그아웃하면 유저디폴트의 닉네임을 제거해준다. 그렇지 않으면 닉네임없는 다른아이디로 로그인하면 전아이디 닉네임이 뜨기 때문.
            UserDefaults.standard.removeObject(forKey: "nickName")
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
        //비밀번호를 재설정할 수 있는 이메일로 넘어간다.
        Auth.auth().sendPasswordReset(withEmail: email, completion: nil)
    }
    
//MARK: - 닉네임 변경
    @IBAction func nickNameUpdateBtn(_ sender: Any) {
        guard let user = Auth.auth().currentUser else { return }

        let alert = UIAlertController(title: "닉네임 변경", message: "닉네임을 입력해주세요.",preferredStyle: .alert)
        //텍스트필드 속성
        alert.addTextField() { field in
            field.placeholder = "닉네임 변경"
            field.keyboardType = .emailAddress
            
        }
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard let fields = alert.textFields, fields.count == 1 else { return }
            let nicknameField = fields[0]
            
            guard let text = nicknameField.text, !text.isEmpty else { return }
            let change = Auth.auth().currentUser?.createProfileChangeRequest()
            change?.displayName = text
            //커밋을 해주지 않으면 닉네임변경이 완료되지 않음.
            change?.commitChanges { _ in
            }
            print(text)
            self.nickLabel.text = user.displayName
            
            self.ref.child("users").child(user.uid).updateChildValues(["nickName" : alert.textFields?[0].text ?? "별명입력안함"])
  
            
//            var changeRequest = user.createProfileChangeRequest().displayName
//                changeRequest = text
            //self.getnickName()
            
            
//            let text = alert.textFields?[0].text
//
//            if text != nil {
//                var changeRequest = user.createProfileChangeRequest().displayName
//                changeRequest = text!
//                print(changeRequest!)
//            }

            
            //self.getnickName()
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
            self.ref.child("users").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
                (snapshot, error) in
                let nicknames = snapshot.value as? [String: Any] ?? [:]
                //닉네임가져오기
                if let nickkey = nicknames[user.uid] as? [String:Any] {
                    //let getnick = nickkey.values
                    if let getnick = nickkey["nickName"] as? String {
                        print(getnick)
//                        DispatchQueue.main.async {
                            //self.nickLabel.text = getnick
                            if getnick != "" {
                                UserDefaults.standard.set(getnick, forKey: "nickName")
                                self.nickLabel.text = UserDefaults.standard.string(forKey: "nickName")
                            } else {
                                self.nickLabel.text = "별명이없다."
                            }
//                        }
                    }
                }
            })
        }
    }
}



//MARK: - 이미지피커
extension TestLoginView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let user = Auth.auth().currentUser else { return }
    
        let image = selectedImage.jpegData(compressionQuality: 0.1)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        Storage.storage().reference().child("userImages").child(user.uid).putData(image!, metadata: metaData) { (data, err) in
            print("data fetch")
            Storage.storage().reference().child("userImages").child(user.uid).downloadURL { (url, err) in
                
                if let url = url {
                    let changeRequest = user.createProfileChangeRequest()
//                    changeRequest.displayName = "nickname"
                    changeRequest.photoURL = url
                }
                
                print("url이 db에 저장됨 : \(url)")
                Database.database().reference().child("users").child(user.uid).updateChildValues(["profileImageUrl":url?.absoluteString])
                
                self.changeuserImg()
            }
        }
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - 회원탈퇴
/*
 //회원탈퇴 : 버튼에 연결만 하면된다.
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



