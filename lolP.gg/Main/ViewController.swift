import UIKit
import FirebaseAuth

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var champion: [ChampData] = []
    var champ = [String:String]()
    var newVersion = String()
    
    //필터링을 위한 배열
    var filteredArr: [String] = []
    var filteredChamp = [ChampData]()

    //챔피언컬렉션뷰
    @IBOutlet var collectionViewMain: UICollectionView!
    
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        champData()
    }

    //MARK: -- 컬렉션뷰 델리게이트
    //셀 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredChamp.count : self.champion.count
    }
    
    //셀 정보 - 어떻게 보여줄 것인가.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "champList", for: indexPath) as? ChampList else {
            return UICollectionViewCell()
        }
        
        let champions: ChampData
        if isFiltering {
            champions = filteredChamp[indexPath.row]
        } else {
            champions = champion[indexPath.row]
        }
       
        //이미지를 빠르게 그리기 위해서 global로 돌린다.
        DispatchQueue.global().async {
            let url: URL! = URL(string: "http://ddragon.leagueoflegends.com/cdn/\(self.newVersion)/img/champion/\(champions.id).png")
            // 이미지를 읽어와 Data객체에 저장
            let imageData = try! Data(contentsOf: url)
            //ui는 main에서 돌려야 하기 떄문에.
            DispatchQueue.main.async {
                cell.nameLabel.text = champions.name
                // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
                cell.imgView.image = UIImage(data: imageData)
            }
        }
        return cell
    }
    
    //MARK: -- 데이터 넘겨주기.
    //셀 눌렀을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item + 1)번째 셀의 챔피언")
        //메인 스토리 보드를 찾고 그 스토리보드안에 지정한 ID를 가진 뷰컨트롤러를 찾아서 controller에 저장.
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "champDetailView") as! ChampDetailView

        let championSkill: ChampData
        if isFiltering {
          championSkill = filteredChamp[indexPath.row]
            if let VCName = filteredChamp[indexPath.row].name as? String {
                controller.VCName = VCName
                print("챔프디테일에 넘겨주는 name : \(VCName)")
            }
            
            if let VCImg = filteredChamp[indexPath.row].id as? String {
                controller.VCImg = VCImg
                print("챔프디테일에 넘겨주는 img값 : \(VCImg)")
            }
        } else {
            championSkill = champion[indexPath.row]
            if let VCName = champion[indexPath.row].name as? String {
                controller.VCName = VCName
                print("챔프디테일에 넘겨주는 name : \(VCName)")
            }
            
            if let VCImg = champion[indexPath.row].id as? String {
                controller.VCImg = VCImg
                print("챔프디테일에 넘겨주는 img값 : \(VCImg)")
            }
        }
        
        if let VCVersion = newVersion as? String {
            controller.VCVersion = VCVersion
            print("챔프디테일에 넘겨주는 버전: \(VCVersion)")
        }
        //이동
        show(controller, sender: nil)
    }
  
    //MARK: - 데이터파싱
    func champData() {
        
        if let urls = URL(string: "https://ddragon.leagueoflegends.com/api/versions.json") {
            var request = URLRequest.init(url: urls)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else { return }
                // 버전 구하기.
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    
                    let newversion = json[0]
                    print("최신버전 : \(newversion)")
                    
                    if let url = URL(string:  "http://ddragon.leagueoflegends.com/cdn/\(newversion)/data/ko_KR/champion.json") {
        
                        print("최신버전의 url : \(url)")
                        
                        var request = URLRequest.init(url: url)
                        request.httpMethod = "GET"
                        URLSession.shared.dataTask(with: request) { (data, response, error) in
                            guard let data = data else { return }
                            print("데이터 크기 : \(data)") //데이터 크기
                            var result: MainData?
                            do {
                                result = try JSONDecoder().decode(MainData.self, from: data)
                            }
                            catch {
                                print("Failed to decode with error: \(error)")
                            }
                            guard let final = result else {
                                return
                            }
                            for (_, datas) in final.data {
                                //데이터 담기
                                self.champion.append(ChampData(id: datas.id, key: datas.key, name: datas.name))
                                //정렬하기
                                self.champion.sort(by: {$0.name < $1.name})
                            }
                            //버전도 담기
                            self.newVersion = newversion
                            //async하여 데이터 메인에서 돌게
//                            OperationQueue.main.addOperation {
//                                self.collectionViewMain.reloadData()
//                            }
                            DispatchQueue.main.async {
                                self.collectionViewMain.reloadData()
                            }
                            print("챔피언 수 : \(self.champion.count)") //챔피언 수 파악
                            print("newVersion : \(self.newVersion)") //버전 확인
                            //print(self.champion)                     //담은 데이터 출력 . 방대한 양이므로 주석처리
                        }.resume()
                    }
                }
            }.resume()
        }
    }
    
    //MARK: - 로그인창.
    @IBAction func profileBtn(_ sender: Any) {
        self.showLoginPopupViewController()
//        if Auth.auth().currentUser != nil {
//            print("유저정보화면")
//            self.showDetailViewController()
//        } else {
//            print("로그인화면")
//            self.showLoginPopupViewController()
//        }
    }
    
    private func showDetailViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginDetailView") as! LoginDetailView
        present(vc, animated: true, completion: nil)
    }
    
    private func showLoginPopupViewController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPopupViewController") as! LoginPopupViewController
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - Filter methods
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        //서치바 설정
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "챔피언 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.backgroundColor = .link
        searchController.searchBar.searchTextField.backgroundColor = UIColor.white
        searchController.searchBar.tintColor = .white
        //스크롤시에도 서치바 유지되게 하기.
        self.navigationItem.hidesSearchBarWhenScrolling = false
        //텍스트 업데이트 확인하기
        searchController.searchResultsUpdater = self
        
        //먼 훗날 scopebar 사용해보자.
    }
      
    //필터링 파악
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    func searchBarIsEmpty() -> Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
      
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
      filteredChamp = champion.filter({( champion : ChampData) -> Bool in
        return champion.name.lowercased().contains(searchText.lowercased())
      })
      collectionViewMain.reloadData()
    }
}

//필터링
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredChamp = champion.filter({ (data:ChampData) -> Bool in
            return data.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        dump(filteredChamp)
        self.collectionViewMain.reloadData()
    }
}

//MARK: - Cell Model
class ChampList: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}
