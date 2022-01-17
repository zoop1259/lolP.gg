//
//  ChampSkillInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/17.
//

import Foundation
import UIKit

// 챔피언 json
// https://ddragon.leagueoflegends.com/cdn/11.23.1/data/ko_KR/champion/Aatrox.json
// 챔피언 skill img UI
// https://ddragon.leagueoflegends.com/cdn/11.24.1/img/spell/AatroxQ.png


// MARK: - mainSkillData
struct mainSkillData: Codable {
    let data: [String: skillData]
}
// MARK: - champData
struct skillData: Codable {
    let id, name, description: String
    let image: skillImage
}

// MARK: - skillImage
struct skillImage: Codable {
    let full: String
}




