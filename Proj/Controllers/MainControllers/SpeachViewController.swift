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

class SpeachViewController: UIViewController, TimerManagerDelegate, AVSpeechSynthesizerDelegate, WBChatViewControllerDelegate, SocketManagerСonversationDelegate, QuitConversationAlertDelegate, TimeIntervalDelegate {
    @IBOutlet weak var clickAndSpeacLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var nameUserChatLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lableMassage: UILabel!
    @IBOutlet weak var ansverMassageLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
	let timerManager = TimerManager()
    var timer: Timer!

    var STRMassage : String?
    let extraTime = 600
    
    var receiverFromContacts : String?
    
	//MARK: Life cycle
    
    class func viewController(receiverID: String) -> SpeachViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: SpeachViewController.self)) as! SpeachViewController
        viewController.receiverFromContacts = receiverID
        return viewController
    }

    let defaults = UserDefaults.standard

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
        
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        //Localized
        
        let strClickAndSpeac = NSLocalizedString("STR_RECORDTOUCH", comment: "")
        clickAndSpeacLabel.text = strClickAndSpeac
        
        let strLastMessage = NSLocalizedString("STR_LASTMASSAGE", comment: "")
        lastMessageLabel.text = strLastMessage
        
        let strBack = NSLocalizedString("STR_BACK", comment: "")
        backButton.setTitle(strBack, for: .normal)


    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		timerManager.delegate = self
        
        let respDialog = SocketManager.sharedInstanse.dialogResponse
        
        if respDialog == "1"{
            timerManager.runTimer()
        }
        
        timerManager.delegateTimeInterval = self
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
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReadTextNotification"), object: nil)

        
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
	
    //MARK: -- TimeIntervalDelegate
    
    @objc func runTimedCode() {
        // send to server time from lable
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
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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


    //MARK: Notifications methods
extension SpeachViewController {
    
    @objc func reproductionOfSpeech(notification: NSNotification){
        guard let message = notification.userInfo!["message"] as? String else {return}
        self.readMessage(messages: message )
    }
    
    @objc func readMessage(messages: String) {
       // let prefferedLanguage = Locale.preferredLanguages[0] as String
        
        let lang = APIService.sharedInstance.userLang
        
        if defaults.value(forKey: "switchON") != nil{
            let switchON: Bool = defaults.value(forKey: "switchON")  as! Bool
            if switchON == true{
        
        let utterance = AVSpeechUtterance(string: messages)
        utterance.voice = AVSpeechSynthesisVoice(language: lang)
        utterance.postUtteranceDelay = 3.0
        
        let readSound = AVSpeechSynthesizer()
        readSound.delegate = self
        readSound.speak(utterance)
            }
        }
    }
    
}