//
//  CommuTableViewController.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/11/30.
//

import UIKit

class CommuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    
    let titleList = ["안녕", "오늘","정말","좋은","하루","야","그렇지","?","^^"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        super.viewWillAppear(animated)
        
        //titleList.reloadData()
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
        
        cell.titleLabel.text = titleList[indexPath.row]
        
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CommuDetailViewController") as? CommuDetailViewController else { return }
        
        viewController.detailTitle = titleList[indexPath.row]
        
        //이동! = 얘는 이동을 수동으로 시켜줘야함.
        show(viewController, sender: nil)
    }

}

class CommunityCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
}
