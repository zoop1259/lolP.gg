//
//  CommuTableViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/11/30.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CommuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var ref: DatabaseReference!
    var titleList = [String]()
    
    var paramTitle: String?
    var paramNickname: String?
    var param: Int?
    var paramKeyValue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        //셀의 높이를 정하자, 오토매틱디멘션을 쓰면 알아서 정해줌.
//        self.commuTableView.rowHeight = UITableView.automaticDimension
        
        //디멘션만 걸어도 되는데 높이를 예측해보기 위한 코드
//        self.commuTableView.estimatedRowHeight = 120
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref.child("board").observeSingleEvent(of: .value) { snapshot in
            print("--> \(snapshot.value)")
        }
    }
    
    
    //로그인이 되었는지 확인하고 로그인이 되었으면 글쓰기 화면으로.
    @IBAction func tapWriteBtn(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            self.showCommuCreateViewController()
        } else {
            let confirm = UIAlertController(title: "로그인이 필요합니다.", message: "로그인 해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {_ in
                self.dismiss(animated: true, completion: nil)
            }
            confirm.addAction(okAction)
            self.present(confirm, animated: false, completion: nil)
        }
    }
    
    private func showCommuCreateViewController() {
        let mystoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let createViewController = mystoryboard.instantiateViewController(identifier: "ShowCommuCreateViewController")
        //이방법은 로그인창까지 겹쳐서 올라옴.
        self.show(createViewController, sender: self)
        //로그인창을 닫으면서 정보창 띄우기.
//        guard let pvc = self.presentingViewController else { return }
//        self.dismiss(animated: true) {
//            pvc.present(DetailViewController, animated: true, completion: nil)
//        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityCell else {
            return UITableViewCell()
        }
        
        //cell.titleLabel.text = titleList[indexPath.row]
        cell.titleLabel.text = titleList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CommuDetailViewController") as? CommuDetailViewController else { return }
        
        viewController.detailTitle = titleList[indexPath.row]
        
        //이동! = 얘는 이동을 수동으로 시켜줘야함.
        show(viewController, sender: nil)
    }
    
    //게시글 가져오기.
//    func getBoardData() {
//        ref.child("board").observeSingleEvent(of: .value) { snapshot in
//            guard let userData = snapshot.value as? [String:Any] else { return }
//
//            let userdata = try! JSONSerialization.data(withJSONObject: Array(userData.values), options: [])
//
//            do {
//                let decoder = JSONDecoder()
//                let usingData = try decoder.decode([FBUser].self, from: userdata)
//                self.fbuser = usingData
//                print("저장된 FBUser: \(self.fbuser)")
//
//                for i in usingData {
//                    self.fbusernickName = i.nickName
//                    print("이름이 이상해...\(self.fbusernickName)")
//                }
//
//            } catch let error {
//                print("유저닉 에러 \(error.localizedDescription)")
//            }
//
//    }
    
}

class CommunityCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
        
}
