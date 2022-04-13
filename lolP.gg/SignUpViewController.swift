//
//  SignUpViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Toast_Swift
import FirebaseFirestore
//import FirebaseStorage
import PhotosUI

class SignUpViewController: UIViewController {

    private let ref: DatabaseReference! = Database.database().reference()
   
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var lblPasswordConfirmed: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!

    //뷰 컨트롤러의 멤버변수
    var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 텍스트 필드에 대한 딜리게이트, 데이터소스 연결 - 유효성 검사에서 필요함
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        
        // 패스워드 일치 여부를 표시하는 레이블을 빈 텍스트로
        lblPasswordConfirmed.text = ""
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
        lblPasswordConfirmed.text = ""
        // -- 사진 초기화 --
    }
    //확인 버튼
    @IBAction func btnActSubmit(_ sender: UIButton) {
        //파이어베이스에 정보를 보내야됨.
        guard let userEmail = txtUserEmail.text else {
            return
        }
        guard let userPassword = txtPassword.text else {
            return
        }
        guard let userPasswordConfirm = txtPasswordConfirm.text else {
            return
        }
        //유효성 검사.
        guard let email = txtUserEmail.text, !email.isEmpty,
                let password = txtPassword.text, !password.isEmpty else {
                    self.view.makeToast("비어있는 항목이 있습니다.", duration: 1.0, position: .center)
                    return
                }
        guard let pwRange = txtPassword.text, (pwRange.count >= 8) else {
            self.view.makeToast("8자 이상 입력해주세요.", duration: 1.0, position: .center)
            return
        }
        guard userPassword != ""
                && userPasswordConfirm != ""
                && userPassword == userPasswordConfirm else {
                    self.view.makeToast("❌패스워드가 일치하지 않습니다.", duration: 1.0, position: .center)
            return
        }
            
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { result, error in
            if let error = error { // 로그인 실패시 메시지 출력
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            //confirm과 okAction이 안되네? 뭐지...
//            let confirm = UIAlertController(title: "Complete", message: "\(userEmail) 님의 회원가입이 완료되었습니다.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
//            confirm.addAction(okAction)
//
//            guard let user = result?.user else { return }
//            print(user)
            
            /*
             //신규사용자 생성
             Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
                 //weak self이후에 이렇게 사용하면 강한참조가 된다.
                 guard let self = self else { return }
                 
                 //동일 계정 회원가입시 처리 또한 나머지도 처리.
                 if let error = error {
                     let code = (error as NSError).code
                     switch code {
                     case 17007: //이미 가입한 계정일 때
                         //로그인하기로..
                         self.loginUser(withEmail: email, password: password)
                     default: //각 에러메세지.
                         self.errorMessageLabel.text = error.localizedDescription
                     }
                 } else { //에러가 없는경우
                     self.showMainViewController()
                 }
             }
             */
            
                //present(confirm, animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            // 파이어베이스에 추가정보 입력할떄..? id라던가..
            //ref.child("users").child(user.uid).setValue(["interesting": selectedInteresting])
        }
    }
}

//비밀번호 일치 확인하기 위한 delegate 설정
extension SignUpViewController: UITextFieldDelegate {
    func setLabelPasswordConfirm(_ password: String, _ passwordConfirm: String)  {
        guard passwordConfirm != "" else {
            lblPasswordConfirmed.text = ""
            return
        }
        
        if password == passwordConfirm {
            lblPasswordConfirmed.textColor = .green
            lblPasswordConfirmed.text = "패스워드가 일치합니다."
        } else {
            lblPasswordConfirmed.textColor = .red
            lblPasswordConfirmed.text = "패스워드가 일치하지 않습니다."
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case txtUserEmail:
            txtPassword.becomeFirstResponder()
        case txtPassword:
            txtPasswordConfirm.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == txtPasswordConfirm {
//            guard let password = txtPassword.text,
//                  let passwordConfirmBefore = txtPasswordConfirm.text else {
//                return true
//            }
//            let passwordConfirm = string.isEmpty ? passwordConfirmBefore[0..<(passwordConfirmBefore.count - 1)] : passwordConfirmBefore + string
//            setLabelPasswordConfirm(password, passwordConfirm)
//
//        }
//        return true
//    }
}

/*
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
*/
