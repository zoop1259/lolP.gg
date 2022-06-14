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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let updatetextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //바버튼 생성,설정
    lazy var updateButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(updateButton(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "수정하기"
        //UI등록
        view.addSubview(titleLabel)
        view.addSubview(updatetextField)
        self.navigationItem.rightBarButtonItem = self.updateButton
        
        //UIConstraints
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        updatetextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        updatetextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 10).isActive = true
        updatetextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -10).isActive = true

        //UIData load
        if let updatetitle = updatetitle {
            titleLabel.text = updatetitle
        }
        if let updatetext = updatetext {
            updatetextField.text = updatetext
        }
    }
    
    @objc private func updateButton(_ sender: Any) {
        print("수정버튼눌림")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

