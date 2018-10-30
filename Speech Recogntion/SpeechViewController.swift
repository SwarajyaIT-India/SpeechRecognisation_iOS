//
//  SpeechViewController.swift
//  Speech Recogntion
//
//  Created by Niks on 06/10/18.
//  Copyright © 2018 SwarajyaIT India All rights reserved.
//

import UIKit
import Speech


protocol SpeechViewControllerDelegate
{
    func speechViewControllerWillDismiss(searchText: String)
}

class SpeechViewController: UIViewController,SFSpeechRecognizerDelegate {
    @IBOutlet weak var searchText: UILabel!
    @IBOutlet weak var SpeechButton:UIButton!
    
    var speechTimer :Timer?
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var recognitionTask: SFSpeechRecognitionTask?
    var delegate: SpeechViewControllerDelegate!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SpeechButton.isSelected = false
        searchText.text = "Press Button to Start"
        SpeechButton.setImage(UIImage(named: "microphonestop"), for: .selected)
        SpeechButton.setImage(UIImage(named: "microphone"), for: .normal)
        
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.4)
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            askSpeechPermission()
        case .authorized: break
            
        case .denied, .restricted: break
            // Do any additional setup after loading the view.
        }
        
    }
    func askSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { status in
            OperationQueue.main.addOperation {
                switch status {
                case .authorized: break
                default: break
                }
            }
        }
    }
    @IBAction func RecordButtonAction(_ sender: UIButton) {
        
        SpeechButton.isSelected = !(SpeechButton.isSelected)
        if SpeechButton.isSelected {
            recordAndRecognizeSpeech()
            if speechTimer != nil {
                speechTimer?.invalidate()
                speechTimer = nil
                
            }
            speechTimer = Timer.scheduledTimer(timeInterval: 4.0, target:self, selector: #selector(finishSpeech), userInfo: nil, repeats: false)
        }
        else{
            stopSpeech()
        }
    }
    @objc  func finishSpeech(){
        if (self.searchText.text?.count)! > 3 && (self.searchText.text != "Speak Now") && (self.searchText.text != "Press Button to Start") {
            print("search text2", self.searchText.text!)
            
            delegate.speechViewControllerWillDismiss(searchText: searchText.text!)
            
            self.stopSpeech()
            self.dismiss(animated: true, completion: nil)
            
        }
        else{
            stopSpeech()
            SpeechButton.isSelected = false
            
            
        }
    }
    func recordAndRecognizeSpeech()
    {
        // Setup audio engine and speech recognizer
        self.searchText.text = "Speak Now"
        let node = audioEngine.inputNode
        let request = SFSpeechAudioBufferRecognitionRequest()
        
        let recordingFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            
            request.append(buffer)
        }
        // Prepare and start recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
            
        } catch {
            return print(error)
        }
        // Analyze the speech
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                self.searchText.isHidden = false
                let beststring = result.bestTranscription.formattedString
                self.searchText.text = beststring
                print("search text", self.searchText.text!)
                
                
            }
            else if let error = error {
                print(error)
            }
        })
        
    }
    func stopSpeech(){
        
        
        self.audioEngine.stop()
        searchText.text = "Press Button to Start"
        audioEngine.inputNode.removeTap(onBus: 0)
        
        self.recognitionTask = nil
        
    }
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.stopSpeech()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK:- ViewControllers Extensions

extension ListingViewController: SpeechViewControllerDelegate
{
    func speechViewControllerWillDismiss(searchText: String) {
        self.textLabel.text = searchText
    }
    
}

