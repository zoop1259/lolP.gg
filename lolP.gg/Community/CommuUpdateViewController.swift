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

//디테일뷰에서 제목과 내용은 받아서 뿌려주자.
//제목은 수정불가능하게하고 내용은 수정가능하게하자.
//제목은 Label
//내용은 TextField
//수정버튼을 만들어보자
//수정은 updateChildValue를 쓰면 될거같다.
//UI리팩토링후 삭제버튼을 추가해보자.
//삭제는 deleteValue같은게 있는지 찾아보자.

class CommuUpdateViewController : UIViewController {
    
    var commukey: String?
    var updatetitle: String?
    var updatetext: String?
    
}

