//  ChampInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2021/12/14.
//

import Foundation
import UIKit

//모든데이터
struct MainData: Codable {
    let data: [String: ChampData]
}
   
// MARK: - ChampData
struct ChampData: Codable {
    let id, key, name: String
}

