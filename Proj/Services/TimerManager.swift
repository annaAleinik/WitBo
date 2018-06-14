//
//  TimerManager.swift
//  Proj
//
//  Created by Admin on 21.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: -- TimerManagerDelegate

protocol TimerManagerDelegate {
    func handleOutOfTime()
    func updateUI(sec: String) 
}

protocol TimeIntervalDelegate {
    func sendTimeInServer()
}

class TimerManager {
    
    static let timerManager = TimerManager()
    
    var delegate : TimerManagerDelegate? = nil
    var delegateTimeInterval : TimeIntervalDelegate? = nil

    var seconds = 1800
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    func runTimer() {
		guard seconds != 0 else {return}
		
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
        
    }

    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        
        if seconds == 0 {
            delegate?.handleOutOfTime()
			timer.invalidate()
        }
       
        let res = self.timeString(time: seconds)
        DispatchQueue.main.async {
            self.delegate?.updateUI(sec: res)
        }
    }
	
	func pauseTimer() {
        
       // let baseUserModel  = BaseUserModel()
        
        let timeFromStr:Int? = Int(seconds)
        
        guard let timeLeft = timeFromStr else {return}
        guard let token = APIService.sharedInstance.token else { return }
        guard let secret = APIService.sharedInstance.secret else { return }
        guard let name = APIService.sharedInstance.userName else { return }
        guard let email = APIService.sharedInstance.userEmail else { return }
        guard let lang = APIService.sharedInstance.userLang else { return }
        
        APIService.sharedInstance.spendedtime(token: token, time: timeLeft)
        
		timer.invalidate()
        
        let manager = WBRealmManager()
        manager.updateTime(forToken: token, secet: secret, email: email, name: name, lang: lang, timeLeft: timeLeft)

	}
}

extension TimerManager {
    private func timeString(time:Int) -> String {
        let minutes = (time % 3600) / 60
        let seconds = (time % 3600) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}



