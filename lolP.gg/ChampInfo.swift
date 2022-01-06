//  ChampInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/14.
//

import Foundation
import UIKit

//클로저
func getName(datas: champData) -> [String] {
    return [datas.name]
}

func printAnd(string: String) -> Int {
    print(string)
    return string.count
}

func getID(ids: champData) -> [String] {
//    //http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/Aatrox.png
//    //http://ddragon.leagueoflegends.com/cdn/11.24.1/img/champion/\(id).png
    return [ids.id]
}

func getDict(names: champData, ids: champData) -> [String:String] {
    return [ids.id: names.name]
    
//    func findDic(dict: [String: String]){
//        for (key, value) in dict{
//        print("\(key) : \(value)")
//      }
//    }
    
}

struct mainData: Codable {
    let type: TypeEnum
    let format: String
    let version: String
    let data: [String: champData]
}
    
   
// MARK: - champData
    struct champData: Codable {
        let version: String
        let id, key, name, title: String
        let blurb: String
        let info: Info
        let image: Image
        let tags: [Tag]
        let partype: Partype
        let stats: [String: Double]
    }

    // MARK: - Image
    struct Image: Codable {
        let full: String
        let sprite: String
        let group: TypeEnum
        let x, y, w, h: Int
    }

    enum TypeEnum: String, Codable {
        case champion = "champion"
    }

    enum Sprite: String, Codable {
        case champion0PNG = "champion0.png"
        case champion1PNG = "champion1.png"
        case champion2PNG = "champion2.png"
        case champion3PNG = "champion3.png"
        case champion4PNG = "champion4.png"
        case champion5PNG = "champion5.png"
    }

    // MARK: - Info
    struct Info: Codable {
        let attack, defense, magic, difficulty: Int
    }

    enum Partype: String, Codable {
        case 기력 = "기력"
        case 기류 = "기류"
        case 마나 = "마나"
        case 보호막 = "보호막 "
        case 분노 = "분노"
        case 없음 = "없음"
        case 열기 = "열기"
        case 용기 = "용기"
        case 투지 = "투지"
        case 피의샘 = "피의 샘"
        case 핏빛격노 = "핏빛 격노"
        case 흉포 = "흉포"
    }

    enum Tag: String, Codable {
        case assassin = "Assassin"
        case fighter = "Fighter"
        case mage = "Mage"
        case marksman = "Marksman"
        case support = "Support"
        case tank = "Tank"
    }
    
    






//// MARK: - ChampList
//struct NameList: Codable {
//    let type, format, version: String
//    let data: DataClass
//}
//
//// MARK: - DataClass
//struct DataClass: Codable {
//    let aatrox, ahri, akali: Aatrox
//
//    enum CodingKeys: String, CodingKey {
//        case aatrox = "Aatrox"
//        case ahri = "Ahri"
//        case akali = "Akali"
//    }
//}
//
//// MARK: - Aatrox
//struct Aatrox: Codable {
//    let version, id, key, name: String
//    let title, blurb: String
//    let info: Info
//    let image: Image
//    let tags: [String]
//    let partype: String
//    let stats: [String: Double]
//}
//
//// MARK: - Image
//struct Image: Codable {
//    let full, sprite, group: String
//    let x, y, w, h: Int
//}
//
//// MARK: - Info
//struct Info: Codable {
//    let attack, defense, magic, difficulty: Int
//}
//



//if let dataJson = data {
//    do {
//    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
//        //print(json)
//        let articles = json["data"] as! Array<Dictionary<String, Any>>
//        self.newsData = articles
//        //메인에서 일을하게 만들어야한다. 외워야 하는 문법
//        DispatchQueue.main.async {
//        self.TableViewMain.reloadData()
//        }
//    }
//}

//func getinfo() {
//
//    var idArr = [String]()
//    var dataArr = [AnyObject]()
//
//    let url = "http://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion.json"
//
//    AF.request(url).responseJSON { response in
//
//        if let value = response.value as? [String: AnyObject] {
//            //모든값
//            print(value)
//           // print(value.count)
//            //type, format, version를 제외하고 data안에 있는 모든 값
//            if let datas = value["data"] as? [String : AnyObject] {
//                //print(datas)
//                //print(datas.count)
//                //데이타 정렬
//
//                //Array(datas.keys)
//                let keys = Array(datas.keys) //.sorted(by: <)
//                //print(keys.count)
//                let values = Array(datas.values)
//                //print(values.count)
//
//                var vv = [String: String]()
//
//                let aa = ["1" : "one", "2" : "two"]
//
//                for(key, value) in aa {
//                    print(key, value)
//                }
//                    for (key,value) in values {
//                            print(key, value)
//                    }
//                    if case let vv[String[i]] = values["id"] as? [String: String] {
//                        print(vv)
//                    }
//                    for (name, path) in values {
//                       print("The path to '\(name)' is '\(path)'.")
//                    let dataskey = datas.keys.sorted(by: <) // aatrox brand camil....
//                    for i in dataskey {
//                        self.nameArr.append(i)
//                    }
//                    for j in datas.values {
//                        dataArr.append(j)
//                    }
//                    print(dataArr.count) //그냥 뭉탱이로 취급해서 1인건가.
//                    if let ids = dataArr["name"] as? [String : AnyObject] {
//                        print(ids)
//                    }
//                    //자. nameArr는 이름만 가지고 있어. 그렇기 떄문에 key값에 이걸 사용하면 될거같은데..
//                    //예를들어 let champdata:Dctionary = [
                //다른 방식으로 접근. 이건 다음단계에서 사용하면 좋을거 같은데...
//                    let name2 = [String](datas.keys)
//                    let etcdata2 = [AnyObject](datas.values)
//                    print(etcdata2)
//                    var newArr = [name2:etcdata2]
//                    print(newArr)
//                    for j in datas {
//                        idArr.append(j["id"] as! String)
//                        krnameArr.append(j["name"] as! String)
//                    }
                
//                    if let namedata = datas["Aatrox"] as? [String : AnyObject] {
//                        //print(namedata)
//                    }
//            }
//            DispatchQueue.main.async {
//                //이것이 4번 통보하는 법. reloadData
//                self.CollectionViewMain.reloadData()
//            }
            //print(self.nameArr)
            //print(idArr)
            //print(krnameArr)
//            for (key, value) in value {
//                print(key)
//            }
            //정렬인데.. 못써먹을듯.
//            let order = value.keys.sorted(by: <)
//            print(order)
//            let order = value.values.sorted(by: <)
//            print(order)
//            let order = value.sorted(by: <)
