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
        
        //        챔피언 이미지 밑에 챔피언명을 출력해야함.
        cell.nameLabel.text = nameList[(indexPath as NSIndexPath).item]

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

//    @IBAction func profileButton(_ sender: Any) {
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let popupview = storyBoard.instantiateViewController(withIdentifier: "popupView")
//        popupview.modalPresentationStyle = .overFullScreen
//        present(popupview, animated: false, completion: nil)
//
//    }
    
}

class ChampList: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

