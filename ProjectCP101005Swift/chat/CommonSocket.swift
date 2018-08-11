//
//  CommonSocket.swift
//  ProjectCP101005Swift
//
//  Created by 林沂諺 on 2018/8/10.
//  Copyright © 2018年 楊文興. All rights reserved.
//

import Foundation
import Starscream


class CommonWebSocketClient: WebSocketDelegate {
    var url: URL
    var socket: WebSocketClient
    init(url: String) {
        self.url = URL(string: url)!
        self.socket = WebSocket(url: self.url)
    }
    
    func startWebSocket() {
        socket.delegate = self
        socket.connect()
    }
    
    func stopWebSocket() {
        socket.disconnect()
        //        socket.delegate = nil
    }
    
    func sendMessage(data: Data) {
        socket.write(data: data)
    }
    func sendmessagetext(text: String){
        socket.write(string: text)
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("socket連線惹")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("socket斷線惹")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        //..
        print(text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        //...
    }
    
    
}
