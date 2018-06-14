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
    func didReciveMessages(messages:Message)
}

    protocol SocketManagerСonversationDelegate {
        func conversationStopped()
}

class SocketManager: UIViewController, WebSocketDelegate {
   
    static let sharedInstanse = SocketManager()
    
    var socket: WebSocket!
    var delegate: SocketManagerDelegate?
    var delegateConversation: SocketManagerСonversationDelegate?
    
    var receiver : String? = nil
    var answerStatusUser: String? = nil
    var dialogResponse: String? = nil
    var initiatorDialog: String = ""
    var initiatorDialogName: String? = nil
    
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
    
    func intro(){
        guard let token = APIService.sharedInstance.token else {return}
        
        let intro = "{\"action\":\"intro\",\"data\":{\"token\":\"" + String(describing: token) + "\"}}"
        
        self.socket.write(string: intro)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {

        guard let data = text.data(using: .utf16) else {return}
        do{
            let decoder = JSONDecoder()
			let dataRespose = try? decoder.decode(CommonResponseModel.self, from: data)
            
			switch dataRespose?.type {
			case .incomingMessage?:
                let parsMessage = try? decoder.decode(MessageData.self, from: data)
                self.recievedMessage(message: parsMessage)
            case .conversationRequest?:
                let conversationRequest = try? decoder.decode(CommonConversationRequest.self, from: data)
                self.initiatorDialog = conversationRequest?.message.initiator ?? ""
                self.initiatorDialogName = conversationRequest?.message.name ?? ""
                let userInfo :  [String:Any] = ["initiatorID": self.initiatorDialog, "nameInitiator": self.initiatorDialogName]
				
                NotificationCenter.default.post(name: Notification.Name("QuitConversation"), object: nil, userInfo: userInfo)
            case .userOffline?:
                let userOffLinline = try? decoder.decode(UserStatus.self, from: data)
                
                guard let idClient = userOffLinline?.clientid else {return}
                
                let userInfo :  [String:Any] = ["clientId": idClient, "isOnline" : false]

                NotificationCenter.default.post(name: Notification.Name("ChangeStatusOnLine"), object: nil, userInfo: userInfo)

			case .messagePushed?:
				break
            case .quitConversation?:
//                let parsQuitConversation = try? decoder.decode(CommonResponseModel.self, from: data)
                self.delegateConversation?.conversationStopped()
                
                
            case .userOnline?:
                let userOnline = try? decoder.decode(UserStatus.self, from: data)
                
                guard let id = userOnline?.clientid else {return}
                
                let userInfo : [String : Any] = ["clientId": id, "isOnline" : true]
                
                NotificationCenter.default.post(name: Notification.Name("ChangeStatusOnLine"), object: nil, userInfo: userInfo)
                
            case .cancelConversationRequest?:
                let cencelConversationRec = try? decoder.decode(DialogData.self, from: data)
                NotificationCenter.default.post(name: Notification.Name("CencelDialogRequest"), object: nil, userInfo: nil)

            case .conversationRequestResponse?:
                let parsDialogResponce = try? decoder.decode(DialogData.self, from: data)
                
                guard let myAnswer = parsDialogResponce?.message.answer, let receiver = parsDialogResponce?.message.receiver else {return}
                
                self.dialogResponse = myAnswer
                
                guard let nameInitiator = parsDialogResponce?.message.name else {return}
                
                let answerDict = ["answer": myAnswer, "receiverID":receiver, "nameInitiator": nameInitiator]
                
                NotificationCenter.default.post(name: Notification.Name("StartDialog"), object: nil, userInfo: answerDict)
                
            case .introduceActionRequired?:
                self.intro()
                break
            case .connectionTimeout?:
                self.socketsConnecting()
			default:
				break
			}
        } catch let err {
            print(err.localizedDescription)
        }

    }
        

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }

    // MARK: Messages
    
    func sendMessage(message:Message) {
        
        guard let token = APIService.sharedInstance.token else { return }
        
        let jsonPushMassage = "{\"action\":\"push_message\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing: message.receiverId) + "\",\"message\":\"" +  "\( message.text)" + "\",\"language\":\"ru-RU\"}}"
        self.socket.write(string: jsonPushMassage)
        delegate?.didReciveMessages(messages: message)

    }
    
    func startDialog(receiver: String) {
        
        guard let token = APIService.sharedInstance.token else { return }

        let jsonStartDialog = "{\"action\":\"conversation_request\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing: receiver) + "\"}}"
        
        self.socket.write(string: jsonStartDialog)

    }
	
	//	MARK: private
    
	private func recievedMessage(message: MessageData?) {
		if let dataMessage = message?.message {
			let message = Message(message: dataMessage )
			
			APIService.sharedInstance.translate(q: message.text, completion: { [weak self] (translationData, err)  in
				guard let `self` = self else { return }
				message.text = (translationData?.translatedText)!
				self.delegate?.didReciveMessages(messages: message)
               
                let strDict = ["message": message.text]
                
                NotificationCenter.default.post(name: Notification.Name("ReadTextNotification"), object: nil, userInfo: strDict)
			})
		}

	}
    
    
    func logOutOfTheConversation(receiver : String){
        
        guard let token = APIService.sharedInstance.token else { return }

            let jsonLogOutOfTheConversation = "{\"action\":\"quit_conversation\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing:receiver ) + "\"}}"
        
                self.socket.write(string: jsonLogOutOfTheConversation)

    }
	
    
    func cancelConversationRequest(receiver : String){
        guard let token = APIService.sharedInstance.token else { return }
        
        let cancelConversationRequest = "{\"action\":\"cancel_conversation_request\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing:receiver ) + "\"}}"
        
        self.socket.write(string: cancelConversationRequest)
    }
    
    
    func selfAnswerrForADialogStart( answer: String){
        
        guard let token = APIService.sharedInstance.token else { return }
        let receiver = self.initiatorDialog 

        let selfAnswerrForADialogStart = "{\"action\":\"conversation_request_response\",\"data\":{\"token\":\"" + String(describing: token) + "\",\"receiver\":\"" + String(describing:receiver ) + "\" ,\"answer\":\"" + String(describing:answer ) + "\"}}"
        
        self.socket.write(string: selfAnswerrForADialogStart)
    }

    
}
