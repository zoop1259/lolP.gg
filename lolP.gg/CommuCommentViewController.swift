////
////  CommuCommentViewController.swift
////  lolP.gg
////
////  Created by 강대민 on 2022/05/12.
////
//
//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//
//class CommuCommentViewController: UITableViewController {
//
//    @IBOutlet var commenttableview: UITableView!
//    var detailAutokey : String?
//    var ref: DatabaseReference!
//    var commentsboard : [CommentsBoard] = []
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        ref = Database.database().reference()
//
//        //테이블뷰설정
//        commenttableview.dataSource = self
//        commenttableview.delegate = self
//        commenttableview.estimatedRowHeight = 100.0
//        commenttableview.register(CommuCommentCell.self, forCellReuseIdentifier: "CommuCommentCell")
//        commenttableview.register(CreateCommentCell.self, forCellReuseIdentifier: "CreateCommentCell")
//
////        getDetailBoard()
//    }
//
//    // MARK: - 댓글 가져오기
//    func getDetailBoard() {
//        //키값으로 게시글 찾기.
//        if let detailAutokey = detailAutokey {
//            print("받은 커뮤키값 : \(detailAutokey)")
//
//            ref.child("board").child("create").child(detailAutokey).observeSingleEvent(of: .value) { snapshot in
//                guard let value = snapshot.value as? [String:Any] else { return }
//
//                let commentsdata = try! JSONSerialization.data(withJSONObject:    Array(value.values), options: [])
//                //print("게시글 데이터 ---> \(value.values)")
//                do {
//                    let decoder = JSONDecoder()
//                    let usingcommentsdata = try decoder.decode([CommentsBoard].self, from: commentsdata)
//
//                    print(usingcommentsdata)
//                    //self.detailBoard = usingcommudetailData
//
//                    DispatchQueue.main.async {
//                        self.commenttableview.reloadData()
//                    }
//
//                    print("--->댓글 : \(self.commenttableview)")
//                } catch let error {
//                    print("댓글 로드 에러 : \(error.localizedDescription)")
//                    print("정확한 에러 원인 : \(String(describing: error))")
//                }
//            }
//        }
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return self.commentsboard.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 2
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "commuCommentCell", for: indexPath)
////
////        cell.textLabel?.text = commentsBoard[indexPath.row].title
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commuCommentCell", for: indexPath) as? CommuCommentCell else { return UITableViewCell() }
//
//        cell.commentsLabel.text = self.commentsboard[indexPath.row].text
//
//        /*
//         // 달라진 방식(iOS 14.0 이상)
//         if #available(iOS 14.0, *) {
//             var content = cell.defaultContentConfiguration()
//             content.text = self.comments[indexPath.row].message
//             cell.contentConfiguration = content
//         } else {
//         // 기존과 동일(iOS 14.0 까지만 지원)
//             cell.textLabel?.text = self.comments[indexPath.row].message
//         }
//         */
//        return cell
//    }
//
//    //셀 오토사이징
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
//
//
//class CommuCommentCell: UITableViewCell {
//
//    @IBOutlet weak var commentsLabel: UILabel!
//    @IBOutlet weak var commentsnickNameLabel: UILabel!
//    @IBOutlet weak var commentswritedateLabel: UILabel!
//
//}
//
//class CreateCommentCell: UITableViewCell {
//
//    @IBOutlet weak var textfield: UITextField!
//
//    var myobj : (() -> Void)? = nil
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    @IBAction func didTapButton(sender: UIButton) {
//        if let didTapButton = self.myobj {
//            didTapButton()
//        }
//    }
//}
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
