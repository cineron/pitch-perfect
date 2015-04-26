//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Cineron on 4/20/15.
//  Copyright (c) 2015 Cineron. All rights reserved.
//

import UIKit

import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    //Chipmunk Step 1a: create global object for AVAudioEngine
    var audioEngine:AVAudioEngine!
    
    //Chipmunk Step 8b: Convert NSURL to AVAudioFile 
    //by creating global variable.
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        //Chipmunk Step 1b: initialize global variable inside viewDidLoad class
        audioEngine = AVAudioEngine()
        
        //Chipmunk Step 8c: Initialized global variable inside viewDidLoad class
        //by using receivedAudio to create file
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create a function to stop audio.
    func audioStop(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //Create a function for audio settings.
    func audioSettings() {
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func PlaySlow(sender: UIButton) {
        audioStop()
        audioPlayer.rate = 0.5
        audioSettings()
    }

    @IBAction func PlayFast(sender: UIButton) {
        audioStop()
        audioPlayer.rate = 2.0
        audioSettings()
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioStop()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //call pitch function
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthAudio(sender: UIButton) {
        //call pitch function
        playAudioWithVariablePitch(-1000)
    }
    
    //Chipmunk Step 2a: Define New playAudioWithVariablePitch Function
    func playAudioWithVariablePitch(pitch: Float){
        //stop any audio that is playing
        audioStop()
        
        //Chipmunk Step 2b: Create an object for AVAudioPlayerNode
        var audioPlayerNode = AVAudioPlayerNode()
        
        //Chipmunk Step 3:  Attach audioPlayerNode to AVAudioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        //Chipmunk Step 4: create an object of AVAudioUnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        
        //Chipmunk Step 4b: Update effect's pitch to argument this function takes
        changePitchEffect.pitch = pitch
        
        //Chipmunk Step 5: Attach pitch effect to AVAudioEngine
        audioEngine.attachNode(changePitchEffect)
        
        //Chipmunk Step 6: Connect AVAudioEngineNode to AVAudioEngine:
        //by connecting player node to pitch effect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        //Chipmunk Step 7: Connect pitch effect to output/speakers
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //Chipmunk Step 8a: Play the audio
        //Chipmunk Step 8d: by using the audioFile variable initialized above.
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        //Chipmunk Step 8e: Start audioengine
        audioEngine.startAndReturnError(nil)
        
        //Chipmunk Step 8f: Play audio player
        audioPlayerNode.play()
    }

}
