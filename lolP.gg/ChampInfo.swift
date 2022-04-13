//  ChampInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/14.
//

import Foundation
import UIKit

struct MainData: Codable {
    //let version: String
    let data: [String: ChampData]
}
   
// MARK: - ChampData
    struct ChampData: Codable {
//        let version: String
        let id, key, name: String
//        let image: Image
    }

//    // MARK: - Image
//    struct Image: Codable {
//        let full: String
//        let sprite: String
//        let group: TypeEnum
//        let x, y, w, h: Int
//    }

