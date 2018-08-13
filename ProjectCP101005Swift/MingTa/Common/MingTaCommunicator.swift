//
//  CommunicatorMingTa.swift
//  iContact
//
//  Created by Ming-Ta Yang on 2018/7/20.
//  Copyright © 2018年 Ming-Ta Yang. All rights reserved.
//

import UIKit

//typealias HomeworkDownloadDoneHandler = (Error?, [HomeworkIsDone]?) -> Void
typealias downloadDoneHandler = (Error?, Data?) -> Void

struct PropertyKeysForConnection {
    static let urlHomeworkServlet = "http://127.0.0.1:8080/iContact/HomeworkServlet"
    static let urlStudentServlet = "http://127.0.0.1:8080/iContact/StudentInfoServlet"
    static let urlExamServlet = "http://127.0.0.1:8080/iContact/ExamServlet"
    static let BoHanServlet = "http://127.0.0.1:8080/PleaseLoginHen/LoginHelp"
    
    
}

class CommunicatorMingTa{
    var targetURL: URL
    init(targetURL: URL) {
        self.targetURL = targetURL
    }
    
    func download(from data: Data, doneHandler: @escaping downloadDoneHandler) {
        
        var request = URLRequest(url: targetURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        if let collection = String(data: data, encoding: .utf8) {
            print("Connect server: " + collection)
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.uploadTask(with: request, from: data, completionHandler: { (data, response, error) in
            
            if let error = error {
                print("\(#function) - error: \(error)")
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
                return
            }
            
            // 確認server回應狀況
            guard let response = response as? HTTPURLResponse else {
                assertionFailure()
                DispatchQueue.main.async {
                    doneHandler(nil, nil)
                }
                return
            }
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "server response error: \(response.statusCode)", code: 0, userInfo: [:])
                print(error.domain)
                DispatchQueue.main.async {
                    doneHandler(error, nil)
                }
                return
            }
            
            guard let data = data else {
                assertionFailure("\(#function)- data is nil")
                return
            }
            
            DispatchQueue.main.async {
                doneHandler(nil, data)
            }
        })
        
        task.resume()
        
        
    }
    
}
