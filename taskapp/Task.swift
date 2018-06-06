//
//  Task.swift
//  taskapp
//
//  Created by 小島 彬 on 2018/05/27.
//  Copyright © 2018年 小島 彬. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用 ID
    @objc
    dynamic var id = 0
    
    // カテゴリ
    @objc
    dynamic var category = ""
    
    // タイトル
    @objc
    dynamic var title = ""
    
    //　内容
    @objc dynamic var contents = ""
    
    // 日時
    @objc dynamic var date = Date()
    
    
    /// id をキーとして設定
    ///
    /// - Returns: <#return value description#>
    override static func primaryKey() -> String? {
        return "id"
    }
}
