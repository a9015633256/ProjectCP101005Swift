
//
//  Communicator.swift
//  ProjectCP101005Swift
//
//  Created by 涂文鴻 on 2018/8/1.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation

class Communicator{
    
    typealias DataHandler = (Error?,Data?) -> Void
    
    func dopost(url: String, data: Data, datahandler: @escaping DataHandler) {
        guard let url = URL(string: url) else {
            assertionFailure("url fail")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.uploadTask(with: request, from: data) { (output, response, error) in
            
            if let error = error {
//                assertionFailure("error :\(error)")
                DispatchQueue.main.async {
                    datahandler(error,nil)
                    
                }
                return
            }
            
            
            guard let response = response as? HTTPURLResponse,(200...299).contains(response.statusCode) else {
//                assertionFailure("server error")
                DispatchQueue.main.async {
                    datahandler(nil,nil)

                }

                return
            }
            DispatchQueue.main.async {
                datahandler(error,output)
            }
        }
        task.resume()
    }
}
