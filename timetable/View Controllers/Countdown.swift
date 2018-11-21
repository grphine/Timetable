//
//  Countdown Timer.swift
//  timetable
//
//  Created by Juheb on 21/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class Countdown: UIViewController {


    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!

    var seconds = 60
    var timer = Timer()
    
    var isTimerRunning = false
    var resumeTapped = false
    
    //FIXME: Allow editing timer. Reset button not working as expected, wholly broken
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(Countdown.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time up
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            timerLabel.text = String(seconds)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    //MARK: Buttons
    @IBAction func startButton(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
        }
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("Pause",for: .normal)
        }

    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60
        timerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
