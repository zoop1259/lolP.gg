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
    
    let db = Firestore.firestore()
    
    @IBOutlet var userId: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    @IBOutlet var passwordReset: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The user's ID, unique to the Firebase project. Do NOT use
        // this value to authenticate with your backend server, if
        // you have one. Use User.getToken() instead.
        
        //let ref = Firestore.firestore().collection("users")
    
        
        //로그인 확인.
        if let user = Auth.auth().currentUser {
            print("당신의 \(user.uid), email: \(user.email ?? "no email")")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //로그인이 이메일로 환영하기 위함
        //그러나 이 방식은 애플로그인단계에서 이메일가리기로 로그인을하면 문제가 생긴다.
        if let user = Auth.auth().currentUser {
            userId.text = ("\(user.uid)")
            userEmail.text = ("\(user.email ?? "이메일로그인이 아님")")
            //userName.text = ("\()")
//            userName.text = ("\(user.name ?? "유저")")
        }
        
        //이메일 초기화
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        //이메일 로그인이 아니라면 비밀번호 변경 버튼은 사라져야 한다.
        passwordReset.isHidden = !isEmailSignIn
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
    //이것과 함꼐 묶을지...
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
