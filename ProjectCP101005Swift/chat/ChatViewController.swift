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
    var sender: String?
    var account: String?
    var socket: CommonWebSocketClient?
    var messageself = [String]()
    let communicator = Communicator()
    
    var oldmessage = [OldMessage]()
    var newMessage = Sendmessage()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(decodeJson), name: Notification.Name.init("GetMessage"), object: nil)
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        sender = UserDefaults.standard.string(forKey: "name")
        account = UserDefaults.standard.string(forKey: "account")
        
        print("sender: \(sender ?? "my")")
        
        let action = GetMessage(action: "getmessage", sender: sender, receiver: receiver)
        let encoder = JSONEncoder()
        guard let uploaddata = try? encoder.encode(action) else {
            assertionFailure("encode失敗")
            return
        }
        communicator.dopost(url: LOGIN_URL, data: uploaddata) { (error, result) in
            guard let result = result else {
                assertionFailure("上傳失敗")
                return
            }
            guard let output = try? JSONDecoder().decode([OldMessage].self, from: result) else {
                assertionFailure("get output fail")
                return
            }
            self.oldmessage = output
        
            self.chatTableView.reloadData()
            self.chatTableView.scrollTOBottom()
        }
        
        // Do any additional setup after loading the view.\
        
    }
    @objc
    func decodeJson(_ notification: Notification) {
        guard let json = notification.userInfo?["JsonString"] as? String else {
            return
        }
        
        guard let jsondata = json.data(using: .utf8)  else {
            assertionFailure("幹")
            return
        }
        
        guard let result = try? JSONDecoder().decode(Sendmessage.self, from: jsondata) else {
            assertionFailure("解析失敗")
            return
        }
        newMessage = result
        
        guard let sender = result.sender, let receiver = result.receiver, let message = result.message else {
            assertionFailure("失敗")
            return
        }
        
        var convert = OldMessage(sender: sender, receiver: receiver, message: message)
        oldmessage.append(convert)
        chatTableView.reloadData()
        chatTableView.scrollTOBottom()
        print("\(result)")
        
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
    @IBAction func sendMessageBtn(_ sender1: Any) {
        
        guard let chatinput = chatInput.text else {
            return
        }
        guard let sender = sender else {
            return
        }
        guard let receiver = receiver else {
            return
        }
        var newMessage = OldMessage(sender: sender, receiver: receiver, message: chatinput)
        
        
//        messageself.append(chatinput)
        oldmessage.append(newMessage)
        
        chatTableView.reloadData()
        
        chatTableView.scrollTOBottom()
        
        let message = Sendmessage(type: "chat", message: chatinput, sender: sender, receiver: receiver)
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
        return messageself.count + oldmessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if oldmessage[indexPath.row].sender == sender {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! ChatTableViewCell
 
            cell.senderName.text = ":\(sender ?? "self")"
            cell.messageself.text = oldmessage[indexPath.row].message
//            cell.messageself.text = messageself[indexPath.row]
//             tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            return cell
            
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherCell", for: indexPath)as! OtherChatTableViewCell
            cell.receiveName.text = "\(receiver ?? "who"):"
            cell.receiverMessage.text = oldmessage[indexPath.row].message
//            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            return cell
        }
        
        
    }
    
    
}

extension ChatViewController: UITableViewDelegate{
    
}

extension UITableView {
    //跑到最下面～～～～～
    func scrollTOBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1, section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
