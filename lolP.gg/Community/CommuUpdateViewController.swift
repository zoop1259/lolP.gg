//
//  CommuUpdateViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/06/15.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

//수정은 updateChildValue를 쓰면 될거같다.
//UI리팩토링후 삭제버튼을 추가해보자.
//삭제는 deleteValue같은게 있는지 찾아보자.

class CommuUpdateViewController : UIViewController {
    
    var commukey: String?
    var updatetitle: String?
    var updatetext: String?
    var ref = Database.database().reference()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var uptextView: UITextView!
    
    //바버튼 생성,설정
    lazy var updateButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(updateButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "수정하기"
        //UI등록
        self.navigationItem.rightBarButtonItem = self.updateButton

        //UIData load
        if let updatetitle = updatetitle {
            titleLabel.text = updatetitle
        }
        if let updatetext = updatetext {
            uptextView.text = updatetext
        }
    }
    
    @objc private func updateButton(_ sender: Any) {
        print("수정버튼눌림")
        guard let text = self.uptextView.text, !text.isEmpty else {
                  self.view.makeToast("내용 작성해주세요.",
                                      duration: 1.0, position: .center)
            return
        }
        
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommuDetailViewController") as! CommuDetailViewController
        
        if let commukey = commukey {
            self.ref.child("board").child("create").child(commukey).updateChildValues(["text" : text])
            NotificationCenter.default.post(name: Notification.Name("willDismiss"), object: self.uptextView.text)
            navigationController?.popViewController(animated: true)
        }
    }

}




/*
 게시글 삭제 구현준비.
 //실시간 db삭제
 //option1 구현
//            let cardID = creditCardList[indexPath.row].id
//            ref.child("Item\(cardID)").removeValue()
 
 //option2 구현 .. 특정패스를 모를떄.
//            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
//                guard let self = self,
//                      let value = snapshot.value as? [String: [String:Any]],
//                      //first는 키의 첫번쨰 값을 가져온다.
//                      let key = value.keys.first else { return }
//
//                self.ref.child("\(key)/isSelected").setValue(true)
//            }
 */
