//
//  LoginDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/22.
//

import Foundation
import UIKit
import AuthenticationServices
import GoogleSignIn
import Firebase
import FirebaseAuth

class LoginDetailView: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //구글 로그인이 제대로 되었는지 확인하기.
        if let user = Auth.auth().currentUser {
            print("당신의 \(user.uid), email: \(user.email ?? "no email")")
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        //Auth.auth().signOut()
        do {
            try FirebaseAuth.Auth.auth().signOut()
            //뷰 닫기?
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("에러 발생")
        }
    }
}

//db랑
