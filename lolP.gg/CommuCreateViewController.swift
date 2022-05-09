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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        
        guard let user = Auth.auth().currentUser else { return }
//        guard let key = REF.child("board").childByAutoId().key else { return }
        
        //board다음에 autoid를 넣는것.
        guard let keyValue = ref.child("board").childByAutoId().key else { return }
        guard let text = self.textLabel.text, !text.isEmpty,
              let title = self.titleLabel.text, !title.isEmpty else {
                  self.view.makeToast("모든 내용을 작성해주세요.", duration: 1.0, position: .center)
                  return
              }
        
        ref.child("board").child(keyValue).setValue(["title" : self.titleLabel.text as Any,
                                      "text" : self.textLabel.text as Any,
                                      "recordTime" : ServerValue.timestamp(),
                                      "uid" : user.uid])
        
        ref.child("board").observeSingleEvent(of: .value) { snapshot in
            print("--> \(snapshot.value)")
//            self.ref.child("board").getData {(error, snapshot) in
//                if let error = error {
//                    print("Error getting data \(error)")
//                }
//                else if snapshot.exists() {
//                    guard let value = snapshot.value else {return}
//                    do {
//                        let userComment = try FirebaseDecoder().decode(Board.self, from: value)
//                        print(userComment)
//                    } catch let err {
//                        print (err)
//                    }
//                }
//                else {
//                    print("No data available")
//                }
//            }
        }
        
       //ref.child("board/\(self.titleLabel.text))/detail").setValue(["text" : self.textLabel.text,
         //                                                            "recordTime" : ServerValue.timestamp()])

    }
}
