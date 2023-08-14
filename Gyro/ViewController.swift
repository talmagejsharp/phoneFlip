//
//  ViewController.swift
//  Gyro
//
//  Created by Talmage Sharp on 8/8/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var gyrox: UILabel!
    @IBOutlet weak var gyroy: UILabel!
    @IBOutlet weak var gyroz: UILabel!
    @IBOutlet weak var trickList: UILabel!
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var flipTracker: UILabel!
    @IBOutlet weak var accela: UILabel!
    @IBOutlet weak var accely: UILabel!
    @IBOutlet weak var accelz: UILabel!
    
    var motion = CMMotionManager()
    var xRotation = 0
    var yRotation = 0
    var zRotation = 0
    var scoreNum = 0
    var xMax = 0
    var yMax = 0
    var zMax = 0
    var isFlipping = false
    var flipMetrics = [[Int]] ()
    var timer:Timer = Timer()
    var count:Int = 15
    var timerCounting:Bool = false
    var tricksDone = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // flipTracker.textColor = UIColor(red: 0, green: 100, blue: 0, alpha: 0)
        MyGyro()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startTapped(_ sender: Any) {
        if(timerCounting){
            timerCounting = false
            timer.invalidate()
            StartButton.setTitle("RESTART", for: .normal)
            let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you want to reset the game?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                self.timerCounting = true
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.Reset()
                            }))
            self.present(alert, animated: true, completion : nil)
        }
        else {
            timerCounting = true
            StartButton.setTitle("RESTART", for: .normal)
            StartButton.tintColor = UIColor.systemRed
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() -> Void {
        count = count - 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(seconds: time)
        TimerLabel.text = timeString
        if (count == 0){
            self.timerCounting = false
            self.timer.invalidate()
            let alert = UIAlertController(title: "Game Over", message: "Your score is: \(scoreNum) would you like to play again?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (_) in
                self.Reset()
                self.timerCounting = false
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.Reset()
            //    self.StartButton.setTitle("START", for: .normal)
            //    self.StartButton.setTitleColor(UIColor.blue, for: .normal)
            }))
            self.present(alert, animated: true, completion : nil)
        }
    }
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int) {
        return (seconds % 60 ) % 60
    }
    func makeTimeString(seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", seconds)
        return timeString
        
    }
    
    func MyGyro(){
//        AddTrick(trick: "full")
//        AddTrick(trick: "kickflip")
        motion.gyroUpdateInterval = 0.0001
        motion.startGyroUpdates(to: OperationQueue.current!){(data, error)in
            if let trueData = data{
                self.score.text = "Score: \(self.scoreNum)"
                self.xRotation += Int(trueData.rotationRate.x)
                self.yRotation += Int(trueData.rotationRate.y)
                self.zRotation += Int(trueData.rotationRate.z)
                
//                if ((self.xRotation > 360) || ((self.xRotation < -275) && (self.xRotation > -420)) || (self.yRotation > 360) || (self.yRotation < -275 && self.yRotation > -360) || (self.zRotation > 360) || ((self.zRotation < -275) && (self.zRotation > -420)) ){
//                    self.CheckTrick(xMax: self.xRotation, yMax: self.yRotation, zMax: self.zRotation)
//                }
                if ((self.xRotation > 5 || self.yRotation > 5 || self.zRotation > 5) && !self.isFlipping) {
                    self.isFlipping = true
                }
                if (self.isFlipping){
                    self.flipMetrics.append([self.xRotation, self.yRotation, self.zRotation])
                }
                if (self.isFlipping && self.xRotation == 0 && self.yRotation == 0 && self.zRotation == 0){
                    if (self.timerCounting) {
                        self.CheckTrick(trickStats:self.flipMetrics)
                    }
                    self.isFlipping = false
                }
//                if ((self.xRotation == 0 && self.yRotation == 0 && self.zRotation == 0) && (self.xMax != 0 || self.yMax != 0 || self.zMax != 0)){
//                    self.CheckTrick(xMax: self.xMax,yMax: self.yMax,zMax: self.zMax)
//                } else {
//                    if (self.xRotation > self.xMax){
//                        self.xMax = self.xRotation
//                    }
//                    if (self.yRotation > self.yMax){
//                        self.yMax = self.yRotation
//                    }
//                    if (self.zRotation > self.zMax){
//                            self.zMax = self.zRotation
//                    }
//                }
                if self.xRotation != 0 || self.yRotation != 0 || self.zRotation != 0 {
                    //print("x: \(self.xRotation)" + "  y: \(self.yRotation)" + "   z\(self.zRotation)")
                }

//                self.gyrox.text="X: \(self.xRotation)"
//                self.gyroy.text="Y:\(self.yRotation)"
//                self.gyroz.text="Z:\(self.zRotation)"
//                
                
                
                if trueData.rotationRate.x < 1 && trueData.rotationRate.y < 1 && trueData.rotationRate.z < 1 {
                   self.xRotation = 0
                   self.yRotation = 0
                   self.zRotation = 0
                    //self.flipTracker.text = "Flip?"
                }
            }
            
        }
        
    }
    func KickFlip(type: String){
        if (type == "normal"){
            self.flipTracker.text = "kickflip"
            AddTrick(trick: "kickflip")
            self.scoreNum += 25
        } else {
            self.flipTracker.text = "heelflip"
            AddTrick(trick: "heelflip")
            self.scoreNum += 50
        }
        self.yRotation = 0
        
        print(type + " kickflip")
    }
    func FrontFlip(){
        self.flipTracker.text = "frontflip"
        self.scoreNum += 100
        AddTrick(trick: "frontflip")
        print("frontflip")
        self.xRotation = 0
    }
    func Full(){
        self.flipTracker.text="full"
        self.scoreNum+=100
        AddTrick(trick: "Full")
        print("full")
        self.xRotation=0
        self.yRotation=0
        self.zRotation=0
    }
    func InwardFull(){
        self.flipTracker.text="Inward full"
        self.scoreNum+=100
        AddTrick(trick: "Inward Full")
        print("Inward full")
        self.xRotation=0
        self.yRotation=0
        self.zRotation=0
    }
    func FlatSpin(type: String){
        if(type == "clockwise"){
            self.flipTracker.text = "360"
            
        } else {
            self.flipTracker.text = "reverse 360"
        }
        self.zRotation=0
        self.scoreNum += 25
        self.score.text = "Score: \(self.scoreNum)"
        print(type + " 360")
    }
    
    @IBAction func Reset() {
        self.flipTracker.text = "Do a Flip!"
        self.xRotation = 0
        self.yRotation=0
        self.zRotation=0
        self.scoreNum = 0
        self.score.text = "Score: \(self.scoreNum)"
        self.count = 15
//        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
//        self.timerCounting = true
        self.TimerLabel.text = self.makeTimeString(seconds: 15)
        self.StartButton.setTitleColor(UIColor.systemBackground, for: .normal)
        self.StartButton.tintColor = UIColor.systemBlue
        self.StartButton.setTitle("START", for: .normal)
        
    }
//    func CheckTrick(xMax : Int, yMax : Int, zMax : Int){
//        print("Maximums!! x:\(xMax) y:\(yMax) z: \(zMax)")
//        if xMax > 360 || xMax < -360{
//            self.FrontFlip()
//        }
//        if yMax > 360 {
//            self.KickFlip(type:"normal")
//        }
//        if yMax > -360 && yMax < -275 {
//            self.KickFlip(type: "reverse")
//        }
//        if zMax > 360 {
//            self.FlatSpin(type: "reverse")
//        } else if zMax > -300 && zMax < -200  {
//            self.FlatSpin(type: "clockwise")
//        }
//        self.xMax = 0
//        self.yMax = 0
//        self.zMax = 0
//    }
    func CheckTrick(trickStats: [[Int]]){
        var max = [0,0,0]
        var min = [0,0,0]
        var y = 0
        for x: [Int] in trickStats {
            print(x)
            while (y<3){
                if (x[y] > max[y]){
                    max[y] = x[y]
                }
                if (x[y] < min[y]){
                    min[y] = x[y]
                }
                y+=1
            }
            y=0
            
            
        }
        print("The maximum & min rotation of this flip were: \(max) and min: \(min)")
        WhatTrick(max: max, min: min)
        self.flipMetrics.removeAll()
    }
    //this function takes the minimums and maximums of the last flip and sends determines what flip was preformed
    func WhatTrick(max:[Int], min:[Int]){
        if(min[1] < -300 && max[0] > 100 && max[2] > 100){
            Full()
        } else if(max[1] > 600 && max[0] > 100 && max[2] > 100){
            InwardFull()
        } else if (max[1] >  600){
            KickFlip(type: "normal")
        } else if (min[1] < -250){
            KickFlip(type: "reverse")
        } else if(max[2] > 400){
            FlatSpin(type:"reverse")
        } else if(min[2] < -210){
            FlatSpin(type:"clockwise")
        }
        // I need to add frontflip and backflip here.
        
    }
    func AddTrick(trick :String){
        tricksDone.append(trick)
        trickList.text = trickList.text! + "\n" + trick
    }
    

    
    /*
     What I need to do:
     1. Trick recognition:
        Ideas:
        - measure the rotational statistics between zeros. Like whether the phone is moving for a long time or not
        - Add sensitivity controls
        -
     2. Home Screen:
        - be able to select game mode, edit settings ect.
     3. Game Modes:
        - High score in x seconds
        - Follow the leader? (it gives a list of tricks you have to do in that order)
     4. Game Settings
        - Left/Right handed modes
        - Trick names, Skateboard, flips, other.
     */
    

}

