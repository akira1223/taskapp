//
//  InputViewController.swift
//  taskapp
//
//  Created by 小島 彬 on 2018/05/26.
//  Copyright © 2018年 小島 彬. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class InputViewController: UIViewController {

    // MARK: - アウトレット
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Task!
    let realm = try! Realm()
    
    // MARK: - ライフサイクル
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 内容欄の枠線
        self.contentsTextView.layer.cornerRadius = 5
        self.contentsTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentsTextView.layer.borderWidth = 1.0
        
        // 背景をタップ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeybord))
        self.view.addGestureRecognizer(tapGesture)
        
        self.categoryField.text = task.category
        self.titleTextField.text = task.title
        self.contentsTextView.text = task.contents
        self.datePicker.date = task.date
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - アクション
    
    /// 登録ボタン押下
    ///
    /// - Parameter sender: 登録ボタン
    @IBAction func onCreate(_ sender: UIButton) {
        try! realm.write {
            self.task.category = self.categoryField.text!
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        
        self.setNotification(task: task)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - privateMethod
    /// キーボードを閉じる
    @objc
    func dismissKeybord() {
        view.endEditing(true)
    }
    
    /// タスクのローカル通知
    ///
    /// - Parameter task: <#task description#>
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        if (task.title == "") {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        
        if (task.contents == "") {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
    // MARK: -
}
