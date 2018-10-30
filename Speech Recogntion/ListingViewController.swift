//
//  ListingViewController.swift
//  Speech Recogntion
//
//  Created by Niks on 06/10/18.
//  Copyright © 2018 SwarajyaIT India All rights reserved.
//

import UIKit

class ListingViewController: UIViewController {

    @IBOutlet weak var textLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func GotoSpeech(_ sender: UIButton) {
        
        let speechViewVC = self.storyboard?.instantiateViewController(withIdentifier: "SpeechViewController") as! SpeechViewController
        speechViewVC.delegate = self
        self.present(speechViewVC, animated: true, completion: nil)
        
    }

}
