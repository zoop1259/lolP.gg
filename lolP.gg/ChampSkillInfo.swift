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

func getskillName(skills: SkillData) -> [String] {
    return [skills.id]
}

func getskillInfo(infos: Spell) -> [String] {
    return [infos.name]
}
//let prac1 = SkillData.passive( ... )


// MARK: - mainSkillData
struct MainSkillData: Codable {
    let type: String
    let format: String
    let version: String
    let data: [String: SkillData]
}
// MARK: - skillData
struct SkillData: Codable {
    let id, key, name: String
    let spells: [Spell]
}

// MARK: - Spell
struct Spell: Codable {
    let id, name, spellDescription: String
    let image: SkillImage

    enum CodingKeys: String, CodingKey {
        case id, name
        case spellDescription = "description"
        case image
    }
}

struct SkillImage: Codable {
    let full: String
}
