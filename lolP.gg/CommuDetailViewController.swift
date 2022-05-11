//
//  CommuDetailViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommuDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var detailcommutableView: UITableView!

    
    var ref = Database.database().reference()
    var detailBoard: [DetailBoard] = []
    
    
    
    //게시글 key값 받아오자. 주후에 댓글에 쓸것.
    var commuKey : String?
    //게시글 값 받아오기
    var detailtitle : String?
    var detailtext : String?
    var detailwriteDate : String?
    var detailnickName : String?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //테이블뷰 설정
        detailcommutableView.dataSource = self
        detailcommutableView.delegate = self
        detailcommutableView.estimatedRowHeight = 100.0
        detailcommutableView.rowHeight = UITableView.automaticDimension
        
        //getDetailBoard() //댓글 받아올 것.
        
    }
    
    // MARK: - 댓글 작성하고 정보 저장하기.
    func getDetailBoard() {
        //키값으로 게시글 찾기.
//        if let commukey = commuKey {
//            print("받은 커뮤키값 : \(commukey)")
//
//            //데이터 저장. 별명이없는자는 일단 apple로그인 때문.
//            self.ref.child("board").child(commukey).setValue([
//                "title" : self.titleLabel.text as Any,
//                "text" : self.textLabel.text as Any,
//                "recordTime" : ServerValue.timestamp(),
//                "uid" : user.uid,
//                "nickName" : self.fbusernickName
//                            ?? "별명이없는자",
//                "writeDate" : writedateString
//                                                        ])
            
//            ref.child("board").child(commukey).observeSingleEvent(of: .value) { snapshot in
//                guard let value = snapshot.value as? [String:Any] else { return }
//
//                let commudetaildata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
//             print("게시글 데이터 ---> \(value.values)")
//                do {
//                    let decoder = JSONDecoder()
//                    let usingcommudetailData = try decoder.decode(DetailBoard.self, from: commudetaildata)
//
//                    print(usingcommudetailData)
//
//                    DispatchQueue.main.async {
//                        self.detailcommutableView.reloadData()
//                    }
//
//                    print("--->커뮤디테일 : \(self.detailBoard)")
//                } catch let error {
//                    print("게시글 로드 에러 : \(error.localizedDescription)")
//                }
//            }
//        }
        
    }
    
    // MARK: - 테이블뷰 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //        if section == 0 { // 본분 섹션
//            return 1
//        } else if section == 1 { //댓글 섹션
//            return 1 //후에 댓글수만큼 늘려줘야함.
//        } else if section == 2 { // 댓글입력 섹션
//            return 1
//        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailCommuCell", for: indexPath) as? DetailCommuCell else {
        return UITableViewCell()
        }
        cell.detailtitleLabel.text = self.detailtitle
        cell.detailtextLabel.text = self.detailtext
        cell.detailnickNameLabel.text = self.detailnickName
        cell.detailwriteDateLabel.text = self.detailwriteDate
        return cell
    }
    //셀 오토사이징
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - 셀 클래스들
//이건 댓글셀

class DetailCommuCell: UITableViewCell {
    @IBOutlet weak var detailtitleLabel: UILabel!
    @IBOutlet weak var detailtextLabel: UILabel!
    @IBOutlet weak var detailnickNameLabel: UILabel!
    @IBOutlet weak var detailwriteDateLabel: UILabel!
}

class DetailCommentCell: UITableViewCell {
    @IBOutlet weak var detailcommentLabel: UILabel!
    @IBOutlet weak var detailcommentnickNameLabel: UILabel!
    @IBOutlet weak var detailcommentdateLabel: UILabel!
}
