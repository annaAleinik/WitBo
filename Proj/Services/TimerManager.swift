//
//  TimerManager.swift
//  Proj
//
//  Created by Admin on 21.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

//MARK: -- TimerManagerDelegate

protocol TimerManagerDelegate {
    func handleOutOfTime()
    func updateUI(sec: String) 
}

class TimerManager {
    
    static let timerManager = TimerManager()
    
    var delegate : TimerManagerDelegate? = nil
    
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
       // print(seconds)
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
		timer.invalidate()
	}
    
  
    
}

extension TimerManager {
    private func timeString(time:Int) -> String {
        let minutes = (time % 3600) / 60
        let seconds = (time % 3600) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}



