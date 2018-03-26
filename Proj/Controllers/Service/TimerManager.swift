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
    func updateUI(sec: Int) 
}

class TimerManager {
    
    static let timerManager = TimerManager()
    
    var delegate : TimerManagerDelegate? = nil
    
    var minutes = 1 //This variable will hold a starting value of
    var seconds = 10
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
        minutes -= 1
        print(seconds)
        if seconds == 0 {
            delegate?.handleOutOfTime()
			timer.invalidate()
        }
        
        DispatchQueue.main.async {
            self.delegate?.updateUI(sec: self.seconds)
        }
    }
	
	func pauseTimer() {
		timer.invalidate()
	}
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    
}










