//
//  ChampDetailView.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/11.
//

import UIKit

public class ChampDetailView : UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet var detailImg: UIImageView! //VC의 챔피언 이미지
    @IBOutlet var detailName: UILabel! //VC의 챔피언 이름

    var spell : [Spell] = []
    
    var VCImg : String? //vc에서 넘겨받은 챔피언 썸네일
    var VCName : String? //vc에서 넘겨받은 챔피언 이름
    var VCVersion : String? // vc에서 넘겨받은 최신버전

    var urlString = "url정보담을 변수"

    //인디케이터 생성
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        return activityIndicator
    } ()

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureContentsTextView()
        //인디케이터 추가
        self.view.addSubview(self.activityIndicator)
        
        //vc는 ViewController의 약자
        if let vcname = VCName {
            //본문을 보여준다.
            self.detailName.text = vcname
            print("챔프디테일에서의 vcname값 : \(vcname)")
        }
        
        self.activityIndicator.startAnimating()
        
        //챔프 썸네일과 스킬이미지 url 생성
        if let vcimg = VCImg {
            if let vcversion = VCVersion {
               if let data = try? Data(contentsOf: URL(string:  "http://ddragon.leagueoflegends.com/cdn/\(vcversion)/img/champion/\(vcimg).png")!) {
                   DispatchQueue.main.async {
                       self.detailImg.image = UIImage(data: data)
                       print("챔프디테일에서의 vcimg값 : \(vcimg)")
                       self.urlString =     "https://ddragon.leagueoflegends.com/cdn/\(vcversion)/data/ko_KR/champion/\(vcimg).json"
                       self.getSkill()
                       print("champskill url : \(self.urlString)")
                   }
               }
            }
        }
        detailTableView.rowHeight  = UITableView.automaticDimension
    }
    
    //MARK: - UIConfigure
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        //layer관련 색상을 변경할때에는 .cgColor를 해주어야 한다.
        self.detailView.layer.borderColor = borderColor.cgColor
        self.detailView.layer.borderWidth = 0.5
        self.detailView.layer.cornerRadius = 5.0
    }
    
    //MARK: - 스킬받아오기
    func getSkill() {
 
        //챔피언의 이름을 받아서 urlString을 완성시켜야함.
        guard let url = URL(string: self.urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [self]data, _, error in
            guard let data = data, error == nil else {
                return
            }
            var result: MainSkillData?
            do {
                result = try JSONDecoder().decode(MainSkillData.self, from: data)
            }
            catch {
                print("Failed to decode with error: \(error)")
            }
            guard let final = result else {
                return
            }
//            스킬의 이름, 정보, 이미지 관련 데이터를 배열에 저장.
            for (skillKey, skillValue) in final.data {
                let spells = skillValue.spells
                self.spell = spells
            }
//            메인에서 일을 시킴. reloadData를 사용하기 떄문에 맨 마지막에 사용
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        })
        task.resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //스킬수만큼 카운트
        return self.spell.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: "champSkill", for: indexPath) as! ChampSkill
        //스킬이름
        cell.skillName.text = self.spell[indexPath.row].name
        //스킬설명
        cell.skillDesc.text = self.spell[indexPath.row].description
        //스킬이미지
        // 섬네일 경로를 인자값으로 하는 URL객체를 생성
        if let vcversion = VCVersion {
            let url: URL! = URL(string: "https://ddragon.leagueoflegends.com/cdn/\(vcversion)/img/spell/\(self.spell[indexPath.row].id).png")
            // 이미지를 읽어와 Data객체에 저장
            let imageData = try! Data(contentsOf: url)
            // UIImage객체를 생성하여 아울렛 변수의 image 속성에 대입
            cell.skillImg.image = UIImage(data: imageData)
        }
        return cell
    }
}

//MARK: - Cell Model
class ChampSkill: UITableViewCell {
    @IBOutlet var skillImg: UIImageView!
    @IBOutlet var skillName: UILabel!
    @IBOutlet var skillDesc: UILabel!
}
