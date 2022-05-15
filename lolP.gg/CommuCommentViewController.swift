////. 복사용...
////  CommuDetailViewController.swift
////  lolP.gg
////
////  Created by 강대민 on 2021/12/02.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//
//class CommuDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var detailcommutableView: UITableView!
//
//    var ref = Database.database().reference()
//    var detailBoard: [DetailBoard] = []
//
//    //게시글 key값 받아오자. 주후에 댓글에 쓸것.
//    var commuKey : String?
//    //게시글 값 받아오기
//    var detailtitle : String?
//    var detailtext : String?
//    var detailwriteDate : String?
//    var detailnickName : String?
//
//    // MARK: - viewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //테이블뷰 설정
//        detailcommutableView.dataSource = self
//        detailcommutableView.delegate = self
//        detailcommutableView.estimatedRowHeight = 100.0
//        detailcommutableView.rowHeight = UITableView.automaticDimension
//
//        getDetailBoard() //댓글 받아올 것.
//
//    }
//
//    // MARK: - 댓글 작성하고 정보 저장하기.
//    func getDetailBoard() {
//        //키값으로 게시글 찾기.
//        if let commukey = commuKey {
//            print("받은 커뮤키값 : \(commukey)")
//
//            ref.child("board").child("create").observeSingleEvent(of: .value) { snapshot in
//                guard let value = snapshot.value as? [String:Any] else { return }
//
//                let commudetaildata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
//                //print("게시글 데이터 ---> \(value.values)")
//                do {
//                    let decoder = JSONDecoder()
//                    let usingcommudetailData = try decoder.decode([DetailBoard].self, from: commudetaildata)
//
//                    print(usingcommudetailData)
//                    //self.detailBoard = usingcommudetailData
//
//                    DispatchQueue.main.async {
//                        self.detailcommutableView.reloadData()
//                    }
//
//                    print("--->커뮤디테일 : \(self.detailBoard)")
//                } catch let error {
//                    print("게시글 로드 에러 : \(error.localizedDescription)")
//                    print("정확한 에러 원인 : \(String(describing: error))")
//                }
//            }
//        }
//    }
//
//    // MARK: - 테이블뷰 설정
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//        //        if section == 0 { // 본분 섹션
////            return 1
////        } else if section == 1 { //댓글 섹션
////            return 1 //후에 댓글수만큼 늘려줘야함.
////        } else if section == 2 { // 댓글입력 섹션
////            return 1
////        } else { return 0 }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommuCell", for: indexPath) as? DetailCommuCell else {
//        return UITableViewCell()
//        }
//        cell.detailtitleLabel.text = self.detailtitle
//        cell.detailtextLabel.text = self.detailtext
//        cell.detailnickNameLabel.text = self.detailnickName
//        cell.detailwriteDateLabel.text = self.detailwriteDate
//        return cell
//    }
//    //셀 오토사이징
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    //댓글VC에 값 넘기기
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        guard let VC = segue.destination as? CommuCommentViewController else { return }
////
////        VC.detailAutokey = self.commuKey
////    }
//
//}
//
//
//// MARK: - 셀 클래스들
////이건 댓글셀
//
//class DetailCommuCell: UITableViewCell {
//    @IBOutlet weak var detailtitleLabel: UILabel!
//    @IBOutlet weak var detailtextLabel: UILabel!
//    @IBOutlet weak var detailnickNameLabel: UILabel!
//    @IBOutlet weak var detailwriteDateLabel: UILabel!
//}
//
//class DetailCommentCell: UITableViewCell {
//    @IBOutlet weak var detailcommentLabel: UILabel!
//    @IBOutlet weak var detailcommentnickNameLabel: UILabel!
//    @IBOutlet weak var detailcommentdateLabel: UILabel!
//}
//
//
//
//
//
//
//
//
////////////////////////
/////
//
////
////  CommuCommentViewController.swift
////  lolP.gg
////
////  Created by 강대민 on 2022/05/12.
////
//
////import UIKit
////import Firebase
////import FirebaseAuth
////import FirebaseDatabase
////
////class CommuCommentViewController: UITableViewController {
////
////    @IBOutlet var commenttableview: UITableView!
////    var detailAutokey : String?
////    var ref: DatabaseReference!
////    var commentsboard : [CommentsBoard] = []
////
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        ref = Database.database().reference()
////
//////        getDetailBoard()
////    }
////
////    // MARK: - 댓글 가져오기
////    func getDetailBoard() {
////        //키값으로 게시글 찾기.
////        if let detailAutokey = detailAutokey {
////            print("받은 커뮤키값 : \(detailAutokey)")
////
////            ref.child("board").child("create").child(detailAutokey).observeSingleEvent(of: .value) { snapshot in
////                guard let value = snapshot.value as? [String:Any] else { return }
////
////                let commentsdata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
////                //print("게시글 데이터 ---> \(value.values)")
////                do {
////                    let decoder = JSONDecoder()
////                    let usingcommentsdata = try decoder.decode([CommentsBoard].self, from: commentsdata)
////
////                    print(usingcommentsdata)
////                    //self.detailBoard = usingcommudetailData
////
////                    DispatchQueue.main.async {
////                        self.commenttableview.reloadData()
////                    }
////
////                    print("--->댓글 : \(self.commenttableview)")
////                } catch let error {
////                    print("댓글 로드 에러 : \(error.localizedDescription)")
////                    print("정확한 에러 원인 : \(String(describing: error))")
////                }
////            }
////        }
////    }
////
////    // MARK: - Table view data source
////
////    override func numberOfSections(in tableView: UITableView) -> Int {
////        // #warning Incomplete implementation, return the number of sections
////        return self.commentsboard.count
////    }
////
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        // #warning Incomplete implementation, return the number of rows
////        return 2
////    }
////
////
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commuCommentCell", for: indexPath) as? CommuCommentCell else { return UITableViewCell() }
////
////        cell.commentsLabel.text = self.commentsboard[indexPath.row].text
////
////        return cell
////    }
////
////    //셀 오토사이징
////    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return UITableView.automaticDimension
////    }
////}
////
////
////class CommuCommentCell: UITableViewCell {
////    @IBOutlet weak var commentsLabel: UILabel!
////    @IBOutlet weak var commentsnickNameLabel: UILabel!
////    @IBOutlet weak var commentswritedateLabel: UILabel!
////}
////
////class CreateCommentCell: UITableViewCell {
////
////    @IBOutlet weak var textfield: UITextField!
////}
//
//
//
////        if let commenttext = textfield.text, !commenttext.isEmpty {
////
////            //작성날짜 구하기 위해서.
////            let formatter = DateFormatter()
////            formatter.dateFormat = "yy-MM-dd"
////            let writedatecomment = formatter.string(from: Date())
////            print(writedatecomment)
////
////            //여기에 댓글 구현
////            //데이터 저장. 별명이없는자는 일단 apple로그인 때문.
////            self.ref.child("board").child("create").child(self.commentAutokey).setValue(["comment" : commenttext as Any,
////                                        "recordTime" : ServerValue.timestamp(),
////                                                                                         "uid" : self.user.uid,
////                                        "nickName" : self.fbusernickName
////                                                    ?? "별명이없는자",
////                                                                                     "writeDate" : writedatecomment
////                                                        ])
////        } else {
////            print("값이 비어있다.")
////        }
////    }
////}
