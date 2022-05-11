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
    //var fbuserwriteDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        //로그인정보부터 불러오기.
        guard let user = Auth.auth().currentUser else { return }
        
        //작성날짜 구하기 위해서.
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        let writedateString = formatter.string(from: Date())
        print(writedateString)
        
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
                let usingData = try decoder.decode([FBUser].self, from: userdata)
                self.fbuser = usingData
                print("저장된 FBUser: \(self.fbuser)")

                for i in usingData {
                    self.fbusernickName = i.nickName
                    print("이름이 이상해...\(self.fbusernickName)")
                }
                
            } catch let error {
                print("유저닉 에러 \(error.localizedDescription)")
            }
            
            //데이터 저장. 별명이없는자는 일단 apple로그인 때문.
            self.ref.child("board").child(keyValue).setValue(["title" : self.titleLabel.text as Any,
                                          "text" : self.textLabel.text as Any,
                                          "recordTime" : ServerValue.timestamp(),
                                          "uid" : user.uid,
                                          "nickName" : self.fbusernickName
                                                       ?? "별명이없는자",
                                        "writeDate" : writedateString
                                                   
                                                        ])
        }
        //push형식으로 뷰컨트롤러를 띄운다면 pop으로 바꾸어 dismiss해야한다.
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}
