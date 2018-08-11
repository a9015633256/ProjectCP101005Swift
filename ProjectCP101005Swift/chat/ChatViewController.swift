//
//  ChatViewController.swift
//  ProjectCP101005Swift
//
//  Created by 林沂諺 on 2018/8/10.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatInput: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var receiver: String?
    var account: String?
    var socket: CommonWebSocketClient?
    var messageself = [String]()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
         account = UserDefaults.standard.string(forKey: "account")
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendMessageBtn(_ sender: Any) {
        
        
        messageself.append("123")
        chatTableView.reloadData()
        print("字串陣列: \(messageself)")
        
        let message = Sendmessage(type: "chat", message: "123", sender: account, receiver: receiver)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init()
        guard let data = try? encoder.encode(message) else {
            assertionFailure("轉不成功")
            return
        }
        guard let jsonString = String(data: data, encoding: .utf8) else{
            assertionFailure("還是轉不成功")
            return
        }
        loginsocket?.sendmessagetext(text: jsonString )
        print("jsonString:\(jsonString)")
        
    }
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageself.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        
        cell.messageself.text = messageself[indexPath.row]
        return cell
    }
    
    
}

extension ChatViewController: UITableViewDelegate{
    
}
