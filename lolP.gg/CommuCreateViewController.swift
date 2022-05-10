//
//  CommuCreateViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/02/15.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Toast_Swift

class CommuCreateViewController : UIViewController {
    
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var textLabel: UITextView!
    
    var ref: DatabaseReference!
    var fbuser: [FBUser] = []
    var fbusernickName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    func findusernickName() {
        
    }
    
    @IBAction func addBtn(_ sender: Any) {
        //로그인정보부터 불러오기.
        guard let user = Auth.auth().currentUser else { return }
//        guard let key = REF.child("board").childByAutoId().key else { return }
        
        //board다음에 autoid를 넣는것.
        guard let keyValue = ref.child("board").childByAutoId().key else { return }
        guard let text = self.textLabel.text, !text.isEmpty,
              let title = self.titleLabel.text, !title.isEmpty else {
                  self.view.makeToast("모든 내용을 작성해주세요.", duration: 1.0, position: .center)
                  return
              }
           
        //닉네임을 가져오기 위한 함수다.
        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String:Any] else { return }

            let userdata = try! JSONSerialization.data(withJSONObject: Array(userData.values), options: [])

            print("data1 : \(userdata)")
            print("\(userData.values)")
            
            do {
                let decoder = JSONDecoder()
                let asdasd = try decoder.decode([FBUser].self, from: userdata)
                self.fbuser = asdasd
                print("저장된 FBUser: \(self.fbuser)")

                
                
                //옵셔널 값이구나..
                for i in asdasd {
                    self.fbusernickName = i.nickName
                    print("이름이 이상해...\(self.fbusernickName)")
                }
                
            } catch let error {
                print("유저닉 에러 \(error.localizedDescription)")
            }
            
            //데이터 저장.
            self.ref.child("board").child(keyValue).setValue(["title" : self.titleLabel.text as Any,
                                          "text" : self.textLabel.text as Any,
                                          "recordTime" : ServerValue.timestamp(),
                                          "uid" : user.uid,
                                    "nickName" : self.fbusernickName ?? "별명이없는자"
                                                        ])
        }
        
        /*
         //닉네임을 가져오기 위한 함수다.
         ref.child("users").child(user.uid).observeSingleEvent(of: .value) { snapshot in
             guard let userData = snapshot.value as? [String:Any] else { return }

             let userdata = try! JSONSerialization.data(withJSONObject: Array(userData.values), options: [])

             print("data1 : \(userdata)")
             print("\(userData.values)")
         }
         */
        
        //데이터 불러오기.
//        ref.child("board").child(keyValue).observeSingleEvent(of: .value, with: { snapshot in
//            guard let value = snapshot.value as? [String:Any] else { return }
//            print("Auto키 제외하고 저장될 값들 출력 : \(value)")
////            for skinnames in atskin {
////                var nameArr = [String]()
////                nameArr.append(skinnames["name"] as! String)
//////                                        print(nameArr)
////            }
//        })
        
        //옵저버싱글이벤트를 사용하면 데이터베이스 값이 변경될 때마다 최근 데이터베이스 값에 대한 단일 값을 보냄
        //스냅샷은 실제로 그 안에 값을 가질것.(처음에 api다룰때 data와 같음.)
//        ref.child("board").observeSingleEvent(of: .value) { snapshot in
//            //print("--> \(snapshot.value)") //1
//            guard let savedata = snapshot.value as? [String:Any] else { return }
//
//            print("저장될 데이터는 : \(savedata)") //1번이랑 같다.
//

    }
}
