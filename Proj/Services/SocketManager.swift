//
//  SSocketManagerClass.swift
//  Proj
//
//  Created by Developer on 04.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Starscream

protocol SocketManagerDelegate {
    func didReciveMessages(messages:Message, clientId:String)
}

class SocketManager: UIViewController, WebSocketDelegate {
   
    static let sharedInstanse = SocketManager()
    
    var socket: WebSocket!
    var delegate: SocketManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
}
    
    func socketsConnecting(){
        var request = URLRequest(url: URL(string: "ws://35.226.224.13:9090")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    //MARK: -- WEBSOCKETS
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        
        socket.write(string: "{\"action\":\"intro\",\"data\":{\"token\":\"" + APIService.sharedInstance.token! + "\"}}")

    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
        
        // this catc massage
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }

    // MARK: Messages
    
    func sendMessage(message:Message) {
        
        guard let token = APIService.sharedInstance.token else { return }
        
        let jsonPushMassage = "{\"action\":\"push_message\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing: message.receiverId) + "\",\"message\":\"" +  "\( message.text)" + "\",\"language\":\"ru-RU\"}}"
        
        self.socket.write(string: jsonPushMassage)
        delegate?.didReciveMessages(messages: message, clientId: message.receiverId)
        
        
        
    }
    
    
    
    
}
