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
    var getnick: String = "별명이없는자"
    
    //게시글 값 받아오기
    var detailtitle : String?
    var detailtext : String?
    var detailwriteDate : String?
    var detailnickName : String?
    var detailuid : String?
    //댓글
    var commentsBoard: [CommentsBoard] = []
    //댓글 수
    var countingComment = 0
    
    //바버튼 생성,설정
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        return button
    }()

    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "게시글"
        let checkUser = Auth.auth().currentUser?.uid
        //이메일 초기화
        if checkUser == detailuid  {
            //작성자가 아니면 수정버튼은 사라져야한다.
            self.navigationItem.rightBarButtonItem = self.rightButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        //셀등록.
        tableView.register(CommuDetailCell.nib(), forCellReuseIdentifier: CommuDetailCell.identifier)
        tableView.register(CommuCommentCell.nib(), forCellReuseIdentifier: CommuCommentCell.identifier)
        
        //테이블뷰 설정
        tableView.rowHeight = UITableView.automaticDimension
        detailcommutableView.dataSource = self
        detailcommutableView.delegate = self
        detailcommutableView.estimatedRowHeight = 100.0
        //메서드 call
        getComment() // 댓글 받아오기
        
        //노티등록
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("willDismiss"), object: nil)
    }
    
    //MARK: - 글 수정했을때 노티 적용하기.
     @objc func reloadTableView(_ notification: Notification){

         let getValue = notification.object as! String
         print("getValue : \(getValue)")
         
         self.detailtext = getValue
         //getDetailBoard()
         
         DispatchQueue.main.async {
             self.detailcommutableView.reloadData()
         }
         
     }
    
    //MARK: - 댓글쓰기
    @IBAction func writeComment(_ sender: UIButton) {
        //로그인정보부터 불러오기.
        guard let user = Auth.auth().currentUser else {
            let confirm = UIAlertController(title: "로그인이 필요합니다.", message: "로그인 해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                self.dismiss(animated: true, completion: nil)
            }
            confirm.addAction(okAction)
            self.present(confirm, animated: false, completion: nil)
            return
        }
        //작성날짜 구하기 위해서.
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        let writedateString = formatter.string(from: Date())
        //print(writedateString) //날짜 출력
        
        //board다음에 autoid를 넣는것.
        guard let keyValue = ref.child("board").childByAutoId().key else { return }
        guard let text = self.commenttextField.text, !text.isEmpty else {
                  self.view.makeToast("댓글 작성해주세요.", duration: 1.0, position: .center)
                  return
              }
        
        //유저닉 얻기.
        ref.child("users").observeSingleEvent(of: .value, andPreviousSiblingKeyWith: {
            (snapshot, error) in
            let nicknames = snapshot.value as? [String: Any] ?? [:]
            //닉네임가져오기
            if let nickkey = nicknames[user.uid] as? [String:Any] {
                let getnick = nickkey.values
                if let gettnick = nickkey["nickName"] as? String {
                    print(gettnick)
                    self.getnick = gettnick
                }
            }
            DispatchQueue.main.async {
                self.detailcommutableView.reloadData()
            }
        })
        //닉네임 가져오기.
        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            if let commukey = self.commuKey {
                self.ref.child("board").child("create").child(commukey).child("comment").child(keyValue).setValue([
                                          "text" : self.commenttextField.text as Any,
                                          "recordTime" : ServerValue.timestamp(),
                                          "uid" : user.uid,
                                          "nickName" : self.getnick,
                                        "writeDate" : writedateString
                ])
                //댓글 업로드와 동시에 댓글카운트 수 늘리기.
                self.ref.child("board").child("create").child(commukey).updateChildValues(["commentCount" : self.countingComment + 1])
                //그리고 텍스트필드 지우기.
                self.commenttextField.text = ""
                
                //메서드 자체를 불러와야 댓글이 새로고침된다.
                self.getComment()
                
//                //왜 리로딩이 안되는걸까
//                DispatchQueue.main.async {
//                    self.detailcommutableView.reloadData()
                //댓글 섹션 리로드 하기...애니메이션이 보이는데 댓글이 읽히지 않는다는건...
//                    self.detailcommutableView.reloadSections(IndexSet(1...1), with: .left)
//                }
            }
        }
    }
    
    // MARK: - 게시물 읽기.
    func getDetailBoard() {
        //키값으로 게시글 찾기.
        if let commukey = commuKey {
            print("getDetailBoard의 커뮤키값 : \(commukey)")
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
            print("getComment의 커뮤키값 : \(commukey)")
            ref.child("board").child("create").child(commukey).child("comment").observeSingleEvent(of: .value) { snapshot in
                
                //카운트 수
                //print("댓글 수 : \(snapshot.childrenCount)")
           
                guard let value = snapshot.value as? [String:Any] else { return }
                let commucommentdata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
                //print("댓글 데이터 ---> \(value.values)")
                do {
                    let decoder = JSONDecoder()
                    let usingcommentData = try decoder.decode([CommentsBoard].self, from: commucommentdata)
                    
                    self.commentsBoard = usingcommentData
                    self.commentsBoard.sort(by: {$0.recordTime > $1.recordTime})
                    self.countingComment = Int(snapshot.childrenCount)
                    print("댓글수 저장용 프린트 : \(self.countingComment)")
                    
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
            
            let titleLabel = "제목 : " + self.detailtitle!
            let textLabel = "내용 : " + self.detailtext!
            let nicknameLabel = "닉네임 : " + self.detailnickName!
            
            //cell.detailtitleLabel.text =  self.detailtitle
            cell.detailtitleLabel.text = titleLabel
            cell.detailtextLabel.text = textLabel
            cell.detailnicknameLabel.text = nicknameLabel
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
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let comment = "댓글"

        switch section {
        case 0:
            return comment
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .link
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        print("탭바아이템눌림")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommuUpdateViewController") as! CommuUpdateViewController
        vc.commukey = self.commuKey
        vc.updatetext = self.detailtext
        vc.updatetitle = self.detailtitle
        show(vc, sender: nil)
    }
    
}
