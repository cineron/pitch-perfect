//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Cineron on 4/17/15.
//  Copyright (c) 2015 Cineron. All rights reserved.
//

import UIKit
//import AV Library
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
        //Show the record label
        recordingInProgress.hidden = false
        recordingInProgress.text = "Tap to Record"
        recordingInProgress.textColor = UIColor(red: 0.066, green: 0.282, blue: 0.431, alpha: 1.0)
    }

    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        //recordingInProgress text and color. No need for .hidden = false
        recordingInProgress.text = "Recording..."
        recordingInProgress.textColor = UIColor.redColor()
        recordButton.enabled = false
        //record user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        //from initial setup
        println("in recordAudio")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            //step 1 - save the recorded audio.
            //call the initializer for RecordedAudio
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)

            //step 2 - segue to the next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful.")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data 
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        //Stop recording user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

