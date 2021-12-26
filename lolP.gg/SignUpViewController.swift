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


class SignUpViewController: UIViewController {

    private let ref: DatabaseReference! = Database.database().reference()
   
    @IBOutlet weak var txtUserEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPasswordConfirm: UITextField!
    @IBOutlet weak var lblPasswordConfirmed: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 텍스트 필드에 대한 딜리게이트, 데이터소스 연결 - 유효성 검사에서 필요함
        txtUserEmail.delegate = self
        txtPassword.delegate = self
        txtPasswordConfirm.delegate = self
        
        // 패스워드 일치 여부를 표시하는 레이블을 빈 텍스트로
        lblPasswordConfirmed.text = ""
        
        
    }
    
    @IBAction func btnActCancel(_ sender: UIButton) {
        //액션 세그로 이어진 뷰컨트롤러를 사라지게해서 되돌림.
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnActReset(_ sender: UIButton) {
        //초기값으로
        txtUserEmail.text = ""
        txtPassword.text = ""
        txtPasswordConfirm.text = ""
        lblPasswordConfirmed.text = ""
        // -- 사진 초기화 --
        
    }
    
    
    //이게 구현이 되질 않음.
    @IBAction func btnActSubmit(_ sender: UIButton) {
        //파이어베이스에 정보를 보내야됨.
        guard let userEmail = txtUserEmail.text,
              let userPassword = txtPassword.text,
              let userPasswordConfirm = txtPasswordConfirm.text else {
            return
        }
        
        //유효성 검사.
        guard let email = txtUserEmail.text, !email.isEmpty,
                let password = txtPassword.text, !password.isEmpty else {
                    self.view.makeToast("비어있는 항목이 있습니다.", duration: 1.0, position: .center)
                    return
                }
        
        guard let pwRange = txtPassword.text, (pwRange.count > 8) else {
            self.view.makeToast("8자 이상 입력해주세요.", duration: 1.0, position: .center)
            return
            
        }
        
        
        guard userPassword != ""
                && userPasswordConfirm != ""
                && userPassword == userPasswordConfirm else {
                    self.view.makeToast("❌패스워드가 일치하지 않습니다.", duration: 1.0, position: .center)
                    
            return
        }
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] authResult, error in
            // 이메일, 비밀번호 전송
            guard let user = authResult?.user, error == nil else {
                self.view.makeToast("❌전송 에러.", duration: 1.0, position: .center)
                return
            }
            
            // 파이어베이스에 추가정보 입력할떄..? id라던가..
            //ref.child("users").child(user.uid).setValue(["interesting": selectedInteresting])
            
            let confirm = UIAlertController(title: "Complete", message: "\(user.email!) 님의 회원가입이 완료되었습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler : nil )
            confirm.addAction(okAction)
            
            present(confirm, animated: true, completion: nil)
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
