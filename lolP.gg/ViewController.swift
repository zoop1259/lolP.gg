import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let nameList = ["가렌", "갈리오", "갱플랭크","갱플랭크","갱플랭크","갱플랭크"]
    

    @IBOutlet var CollectionViewMain: UICollectionView!

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return nameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = CollectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
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
        
    }


}

class ChampList: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
