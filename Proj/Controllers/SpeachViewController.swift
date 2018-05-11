//
//  ViewController.swift
//  Proj
//
//  Created by Admin on 19.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import Starscream

class SpeachViewController: UIViewController, TimerManagerDelegate, AVSpeechSynthesizerDelegate, WBChatViewControllerDelegate, SocketManagerСonversationDelegate, QuitConversationAlertDelegate {
    
    
    @objc func reproductionOfSpeech(notification: NSNotification){
        self.readMessage(messages: SocketManager.sharedInstanse.textMessage!)
    }

    @objc func readMessage(messages: String) {
        let prefferedLanguage = Locale.preferredLanguages[0] as String

        let utterance = AVSpeechUtterance(string: messages)
        utterance.voice = AVSpeechSynthesisVoice(language: prefferedLanguage)
        utterance.postUtteranceDelay = 3.0
        
        let readSound = AVSpeechSynthesizer()
        readSound.delegate = self
        readSound.speak(utterance)
    }
    
    
    @IBOutlet weak var nameUserChatLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lableMassage: UILabel!
    
    @IBOutlet weak var ansverMassageLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
	let timerManager = TimerManager()
    var STRMassage : String?
    let extraTime = 600
    
    var receiverFromContacts : String?
    
	//MARK: Life cycle
    
    class func viewController() -> SpeachViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return  storyboard.instantiateViewController(withIdentifier: String(describing: SpeachViewController.self)) as! SpeachViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SocketManager.sharedInstanse.delegateConversation = self
        recordButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self,
                                        selector:#selector(reproductionOfSpeech(notification:)),
                                               name: Notification.Name("ReadTextNotification"),
                                               object: nil)
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization {
            status in
            var buttonState = false // 4
            
            switch status { // 5
            case .authorized:
                buttonState = true
                print("Разрешение получено")
            case .denied:
                buttonState = false
                print("Пользователь не дал разрешения на использование распознавания речи")
            case .notDetermined:
                buttonState = false
                print("Распознавание речи еще не разрешено пользователем")
            case .restricted:
                buttonState = false
                print("Распознавание речи не поддерживается на этом устройстве")
            }
            
            DispatchQueue.main.async { // 6
                self.recordButton.isEnabled = buttonState // 7
            }
        }
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		timerManager.delegate = self
		timerManager.runTimer()
        if self.timerManager.seconds == 0 {
            self.presentAlertController()
        }
        addChatViewController()
        
        self.nameUserChatLabel.text = receiverFromContacts

   }
	
	override  func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timerManager.pauseTimer()
        
        guard let rec = self.receiverFromContacts else {return}
        
        SocketManager.sharedInstanse.logOutOfTheConversation(receiver:rec)
        
        self.nameUserChatLabel.text = nil
	}
    
    // handler closed ads
    func adHadBeenWatched(watched:Bool) {
        if watched {
            self.timerManager.seconds = self.extraTime
            self.timerManager.delegate = self
            self.timerManager.runTimer()
            self.recordButton.isEnabled = true
        }else {
            self.tabBarController?.selectedIndex = TabBarControllers.TabBarControllersDialogs.rawValue
        }
    }
    
    
    //MARK: --TimerManagerDelegate
    func handleOutOfTime() {
        self.presentAlertController()
        self.recordButton.isEnabled = false // block button after 10 sec
    }
    
    func updateUI(sec: String) {
        guard (self.timeLabel != nil) else {return}
        self.timeLabel.text = sec
    }
	
    //MARK:-- Speach
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if audioEngene.isRunning {
            audioEngene.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            recordButton.setTitle("Начать запись", for: .normal)
        } else {
            startRecording()
            recordButton.setTitle("Остановить запись", for: .normal)
        }
    }
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngene = AVAudioEngine()
    
    func startRecording() {
        
        if recognitionTask != nil {  // 1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance() // 2
        do { // 3
           try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("Не удалось настроить аудиосессию")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest() // 4
        
         let inputNode = audioEngene.inputNode
        
        guard let recognitionRequest = recognitionRequest else { // 6
            fatalError("Не могу создать экземпляр запроса")
        }
        
        recognitionRequest.shouldReportPartialResults = true // 7
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { // 8
            result, error in
            
            var isFinal = false // 9
            
            if result != nil { // 10
                self.STRMassage = result?.bestTranscription.formattedString
                
                isFinal = (result?.isFinal)!

            }
            
            if error != nil || isFinal { // 11
                self.audioEngene.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                
                let res = result?.bestTranscription.formattedString
                
                guard let receiver = self.receiverFromContacts else {return}
                guard let resultStr = res  else {return}
                
                let message = Message()
                message.text = resultStr
                message.receiverId = receiver
                
                SocketManager.sharedInstanse.sendMessage(message: message)
                
            }
        }
        
        let format = inputNode.outputFormat(forBus: 0) // 12
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { // 13
            buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngene.prepare() //14
        
        do {  // 15
            try audioEngene.start()
        } catch {
            print("Не удается стартонуть движок")
        }
    }
    
    //MARK : Action
    
    // TODO : Delete this test method
    @IBAction func send(_ sender: Any) {
        let message = Message()
        message.text = "TEST MESSAGE"
        message.receiverId = "1ty287iughriufhjk"
        
        SocketManager.sharedInstanse.sendMessage(message: message)
    }
    
    
    //MARK--AVSpeechSynthesizer

    //MARK: WBChatViewControllerDelegate
    func sendMessage(msg: Message) {
        
    }
    
    func addChatViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: String(describing:WBChatViewController.self))
        
        self.addChildViewController(chatVC)
        self.containerView.addSubview(chatVC.view)
        chatVC.didMove(toParentViewController: self)
        
        chatVC.view.frame = self.containerView.bounds
        chatVC.view.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
    }
    
    //MARK: --SocketManagerСonversationDelegate
    
    func conversationStopped() {

        // Register Nib
        let storyboard = UIStoryboard(name: "CustomControllers", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuitConversationAlert") as? QuitConversationAlert
        controller?.delegateQC = self
        if self.nameUserChatLabel.text != nil {
            self.present(controller!, animated: true, completion: nil)
        }
    }
    
    func quitConversation() {
        self.tabBarController?.selectedIndex = 0        
    }

}
        
extension SpeachViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
    
    private func presentAlertController () {
        let vc = CustomAlertViewController.viewController()
        vc.presentedVC = self
        self.present(vc, animated: false, completion: nil)
    }
    

}
