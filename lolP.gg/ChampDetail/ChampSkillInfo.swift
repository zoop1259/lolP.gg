//
//  ChampSkillInfo.swift
//  lolP.gg
//
//  Created by 강대민 on 2022/01/17.
//

import UIKit

// MARK: - mainSkillData
struct MainSkillData: Codable {
    let data: [String: SkillData]
}

// MARK: - skillData
struct SkillData: Codable {
    let id, key, name: String
    let spells: [Spell]
}

// MARK: - Spell
struct Spell: Codable {
    let id, name, description: String
}
