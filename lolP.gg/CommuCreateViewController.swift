//
//  CommuCreateViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/02/15.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommuCreateViewController : UIViewController {
    
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var textLabel: UITextView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        //이렇게하면 밸류값만 바뀜. 즉 새로 추가가 되지 않고 키값이 그대로라 밸류값만 바뀜.
        //ref.child("board").setValue(["title" : self.titleLabel.text,
        //                            "text" : self.textLabel.text])
        
        guard let user = Auth.auth().currentUser else { return }
//        guard let key = REF.child("board").childByAutoId().key else { return }
        
        guard let keyValue = ref.child("board").childByAutoId().key else { return }
        
        ref.child(keyValue).setValue(["title" : self.titleLabel.text,
                                      "text" : self.textLabel.text,
                                      "recordTime" : ServerValue.timestamp(),
                                      "uid" : user.uid])
        
       //ref.child("board/\(self.titleLabel.text))/detail").setValue(["text" : self.textLabel.text,
         //                                                            "recordTime" : ServerValue.timestamp()])

    }
}
