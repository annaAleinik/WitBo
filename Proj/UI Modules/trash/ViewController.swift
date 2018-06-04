//
//  ViewController.swift
//  Proj
//
//  Created by Admin on 19.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Speech

class SpeachViewController: UIViewController, TimerManagerDelegate {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lableMassage: UILabel!
    @IBOutlet weak var recordButton: UIButton!
	
	let timerManager = TimerManager()


	//MARK: Life cycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		timerManager.delegate = self
		timerManager.runTimer()
   }
	
	override  func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timerManager.pauseTimer()
        
	}
    
    //MARK: --TimerManagerDelegate
    func handleOutOfTime() {
        print("minuts and sec == 0")
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController //add alert
        vc.view.backgroundColor = UIColor.black .withAlphaComponent(0.6)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        
        self.recordButton.isEnabled = false // block button after 10 sec
    }
    
    func updateUI(sec: Int) {
            self.timeLabel.text = String(sec)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordButton.isEnabled = false
		
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
    
    func startRecording() {
        
        if recognitionTask != nil {  // 1
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance() // 2
        do { // 3
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
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
                self.lableMassage.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal { // 11
                self.audioEngene.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
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
    
    
}
        
extension SpeachViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
    
    

}
