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

class CommuCreateViewController : UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var textLabel: UITextView!
    
    var ref: DatabaseReference!
    //닉네임설정을 안한자를 위한..
    var fbusernickName: String = "별명이없는자"
    
    var labelcount = 0
    
    var textfieldBool = false
    var textViewBool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        configureContentsTextView()
        placeholderSetting()

        
        titleLabel.delegate = self
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }

    
    //MARK: - UIConfigure
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        //layer관련 색상을 변경할때에는 .cgColor를 해주어야 한다.
        self.textLabel.layer.borderColor = borderColor.cgColor
        self.textLabel.layer.borderWidth = 0.5
        self.textLabel.layer.cornerRadius = 5.0
    }

    
    //UILabel Placeholder
    func placeholderSetting() {
        textLabel.delegate = self
        textLabel.text = "내용을 입력해주세요."
        textLabel.textColor = UIColor.lightGray
    }
    
    //텍스트뷰를 터치하게되면 플레이스홀더 지우기.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    //글이 비어있거나, 시작부터 " " 면 작성버튼 비활성화.
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            //self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.textViewBool = false
        } else {
            //self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.textViewBool = true
        }
        print(self.textViewBool)
        
        if self.textfieldBool && self.textViewBool == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.textfieldBool = false
        } else {
            self.textfieldBool = true
        }
        print(self.textfieldBool)
        
        if self.textfieldBool && self.textViewBool == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    
    //텍스트뷰 플레이스홀더 변경용.
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "내용을 제대로 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func addBtn(_ sender: Any) {
        //로그인정보부터 불러오기.
        guard let user = Auth.auth().currentUser else { return }
        
        //유효성 검사. 정규식을 사용하지 않음.
//        guard let titlelabel = titleLabel.text, !titlelabel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            self.view.makeToast("❌제목을 입력해 주세요.", duration: 1.0, position: .center)
//            return
//        }
        
        //작성날짜 구하기 위해서.
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        let writedateString = formatter.string(from: Date())
        print(writedateString)
        
        //board다음에 autoid 생성.
        guard let keyValue = ref.child("board").childByAutoId().key else { return }

        //닉네임 가져오기.
        ref.child("users").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            (snapshot, error) in
            let nicknames = snapshot.value as? [String: Any] ?? [:]
            //닉네임가져오기
            if let nickkey = nicknames[user.uid] as? [String:Any] {
                //let getnick = nickkey.values
                if let getnick = nickkey["nickName"] as? String {
                    print(getnick)
                    self.fbusernickName = getnick
                }
            }
        })
        //게시글 등록!
        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            //데이터 저장.
            self.ref.child("board").child("create").child(keyValue).setValue([
                "title" : self.titleLabel.text as Any,
                "text" : self.textLabel.text as Any,
                "recordTime" : ServerValue.timestamp(),
                "uid" : user.uid,
                "nickName" : self.fbusernickName,
                "writeDate" : writedateString,
                "keyValue" : keyValue,
                "commentCount" : 0
                                                        ])
        }
        //화면 pop
        navigationController?.popViewController(animated: true)
    }
    
    //화면 터치시 키보드 내리기.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
