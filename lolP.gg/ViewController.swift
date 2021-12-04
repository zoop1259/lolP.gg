import UIKit
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let nameList = ["가렌", "갈리오", "갱플랭크","갱플랭크","갱플랭크","갱플랭크"]
    

    @IBOutlet var CollectionViewMain: UICollectionView!
    
    var champData :Array<Dictionary<String, Any>>?
    
    func getChamps() {
        //이게 1번
        let task = URLSession.shared.dataTask(with: URL(string: "https://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion.json")!) { data, response, error in
            //첫번째 문법이 나온다. 옵셔널 바인딩
            
            //이게 2번
            if let dataJson = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options:[]) as! Dictionary<String, Any>
                    //스위프트에선 Dictionary라고 한다.
                    let names = json["freeChampionIds"] as! Array<Dictionary<String, Any>>
                    //여기서 self가 빠지면 위치를 모른다. 그렇기 떄문에 self를 사용한다.
                    self.champData = names
                
                    //메인에서 일을하게 만들어야한다. 외워야 하는 문법
                    DispatchQueue.main.async {
                        //이것이 4번 통보하는 법. reloadData
                        self.CollectionViewMain.reloadData()
                    }
                }
                catch {}
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let champs = champData {
            return champs.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CollectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
        
        let idx = indexPath.row
        //newsData가 비어있지 않으면
        if let names = champData {
            //news의 indexPath의 row의 만큼 뉴스를 가져와서
            let row = names[idx]
            //그 news의 정보가 dictionary형태면
            if let r = row as? Dictionary<String, Any> {
                //거기서 title을 가져와라.
                if let title = r["freeChampionIds"] as? String {
                cell.nameLabel.text = title
                }
            }
        }
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemSpacing: CGFloat = 5 // 가로에서 cell과 cell 사이의 거리
//        let textAreaHeight: CGFloat = 20 // textLabel이 차지하는 높이
//        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
//        let height: CGFloat = width * 10/7 + textAreaHeight //셀 하나의 높이
//
//        return CGSize(width: width, height: height)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getChamps()
        
    }


}

class ChampList: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
