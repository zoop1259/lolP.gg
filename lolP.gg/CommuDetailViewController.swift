//. 복사용...
//  CommuDetailViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/02.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommuDetailViewController : UITableViewController {

    @IBOutlet var detailcommutableView: UITableView!
    @IBOutlet weak var commenttextField: UITextField!
    
    
    var ref = Database.database().reference()
    var detailBoard: [DetailBoard] = []
    
    
    
    //게시글 key값 받아오자. 주후에 댓글에 쓸것.
    var commuKey : String?
    var commufbuser: [FBUser] = []
    var commufbusernickName: String = ""
    
    //게시글 값 받아오기
    var detailtitle : String?
    var detailtext : String?
    var detailwriteDate : String?
    var detailnickName : String?
    
    //댓글 관련
    var commentsBoard: [CommentsBoard] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CommuDetailCell.nib(), forCellReuseIdentifier: CommuDetailCell.identifier)
        tableView.register(CommuCommentCell.nib(), forCellReuseIdentifier: CommuCommentCell.identifier)
        
        //테이블뷰 설정
        tableView.rowHeight = UITableView.automaticDimension
        detailcommutableView.dataSource = self
        detailcommutableView.delegate = self
        detailcommutableView.estimatedRowHeight = 100.0
        getDetailBoard() //게시글 받아올 것.
        getComment() // 댓글 받아올 것.
        
    }
    
    @IBAction func writeComment(_ sender: UIButton) {
        //로그인정보부터 불러오기.
        guard let user = Auth.auth().currentUser else { return }
        //작성날짜 구하기 위해서.
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        let writedateString = formatter.string(from: Date())
        print(writedateString)
      
        //board다음에 autoid를 넣는것.
        guard let keyValue = ref.child("board").childByAutoId().key else { return }
        guard let text = self.commenttextField.text, !text.isEmpty else {
                  self.view.makeToast("댓글 작성해주세요.", duration: 1.0, position: .center)
                  return
              }
        
        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String:Any] else { return }
            
            let userdata = try! JSONSerialization.data(withJSONObject: Array(userData.values), options: [])

            print("data1 : \(userdata)")
            print("\(userData.values)")
            
            do {
                let decoder = JSONDecoder()
                let usingData = try decoder.decode([FBUser].self, from: userdata)
                self.commufbuser = usingData
                print("저장된 FBUser: \(self.commufbuser)")

                for i in usingData {
                    self.commufbusernickName = i.nickName
                    print("이름이 이상해...\(self.commufbusernickName)")
                }
                
            } catch let error {
                print("유저닉 에러 \(error.localizedDescription)")
            }
            
            if let commukey = self.commuKey {

                self.ref.child("board").child("create").child(commukey).child("comment").child(keyValue).setValue([
                                          "text" : self.commenttextField.text as Any,
                                          "recordTime" : ServerValue.timestamp(),
                                          "uid" : user.uid,
                                          "nickName" : self.commufbusernickName
                                                       ?? "별명이없는자",
                                        "writeDate" : writedateString

                                                        ])
            }
        }
    }
    
    
    // MARK: - 게시물 읽기.
    func getDetailBoard() {
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
            print("받은 커뮤키값 : \(commukey)")
            ref.child("board").child("create").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String:Any] else { return }

                let commudetaildata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
                //print("게시글 데이터 ---> \(value.values)")
                do {
                    let decoder = JSONDecoder()
                    let usingcommudetailData = try decoder.decode([DetailBoard].self, from: commudetaildata)
    
                    DispatchQueue.main.async {
                        self.detailcommutableView.reloadData()
                    }
                } catch let error {
                    print("게시글 로드 에러 : \(error.localizedDescription)")
                    print("정확한 에러 원인 : \(String(describing: error))")
                }
            }
        }
    }
    
    // MARK: - 댓글 읽기.
    func getComment() {
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
            print("받은 커뮤키값 : \(commukey)")
            ref.child("board").child("create").child(commukey).child("comment").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String:Any] else { return }
                let commucommentdata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
                //print("댓글 데이터 ---> \(value.values)")
                do {
                    let decoder = JSONDecoder()
                    let usingcommentData = try decoder.decode([CommentsBoard].self, from: commucommentdata)
                    
                    self.commentsBoard = usingcommentData
                    self.commentsBoard.sort(by: {$0.recordTime > $1.recordTime})
                    DispatchQueue.main.async {
                        self.detailcommutableView.reloadData()
                    }
                } catch let error {
                    print("댓글 로드 에러 : \(error.localizedDescription)")
                    print("정확한 에러 원인 : \(String(describing: error))")
                }
            }
        }
    }
    
    
    // MARK: - 테이블뷰 설정
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return commentsBoard.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommuDetailCell", for: indexPath) as? CommuDetailCell else {
            return UITableViewCell()
            }
            cell.detailtitleLabel.text = self.detailtitle
            cell.detailtextLabel.text = self.detailtext
            cell.detailnicknameLabel.text = self.detailnickName
            cell.detaildateLabel.text = self.detailwriteDate
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommuCommentCell", for: indexPath) as? CommuCommentCell else {
            return UITableViewCell()
            }
            cell.commenttextLabel.text = commentsBoard[indexPath.row].text
            cell.commentdateLabel.text = commentsBoard[indexPath.row].writeDate
            cell.commentnicknameLabel.text = commentsBoard[indexPath.row].nickName
            return cell
        }
    }
}
