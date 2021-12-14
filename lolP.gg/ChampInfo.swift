//
//  ChampInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/14.
//

import Foundation

// MARK: - ChampList
struct NameList: Codable {
    let type, format, version: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let aatrox, ahri, akali: Aatrox

    enum CodingKeys: String, CodingKey {
        case aatrox = "Aatrox"
        case ahri = "Ahri"
        case akali = "Akali"
    }
}

// MARK: - Aatrox
struct Aatrox: Codable {
    let version, id, key, name: String
    let title, blurb: String
    let info: Info
    let image: Image
    let tags: [String]
    let partype: String
    let stats: [String: Double]
}

// MARK: - Image
struct Image: Codable {
    let full, sprite, group: String
    let x, y, w, h: Int
}

// MARK: - Info
struct Info: Codable {
    let attack, defense, magic, difficulty: Int
}




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
