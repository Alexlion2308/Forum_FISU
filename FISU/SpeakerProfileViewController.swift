//
//  SpeakerProfileViewController.swift
//  FISU
//
//  Created by Reda M on 26/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class SpeakerProfileViewController: UIViewController {
    
    var speakerSelected : NSNumber?
    var jsonSpeaker: JSON?
    
    
    @IBOutlet weak var ProfilImageSpeaker: UIImageView!
    
    @IBOutlet weak var DescriptionLabelSpeaker: UITextView!
    
    @IBOutlet weak var ProfessionLabelSpeaker: UILabel!
    
    @IBOutlet weak var ProvenanceLabelSpeaker: UILabel!
    
    @IBOutlet weak var SurnameLabelSpeaker: UILabel!
    
    @IBOutlet weak var NameLabelSpeaker: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.jsonSpeaker)
        guard let speaker = self.jsonSpeaker else{
            print("guard jsonSpeakerToLoop")
            return
        }
        //for (key, speaker) in jsonSpeakerToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            print(self.speakerSelected)
            print(self.jsonSpeaker?["nameSpeaker"].toString())
            
            guard let selection = self.speakerSelected else{
                return
            }
            //if(speaker["numeroSpeaker"].toString() == String(selection)){
            guard let profileImageUrl = NSURL(string:speaker["imageSpeaker"].toString()) else{
                return
            }
            guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
                return
            }
            //print(speaker["descriptionSpeaker"].toString())
            let myImage =  UIImage(data: profileImageData)
            self.NameLabelSpeaker.text = speaker["nameSpeaker"].toString()
            self.SurnameLabelSpeaker.text = speaker["surnameSpeaker"].toString()
            self.ProvenanceLabelSpeaker.text = speaker["nationaliteSpeaker"].toString()
            self.ProfessionLabelSpeaker.text = speaker["professionSpeaker"].toString()
            self.DescriptionLabelSpeaker.text = speaker["descriptionSpeaker"].toString()
            self.ProfilImageSpeaker.image = myImage
            
            
            
            //   }
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
