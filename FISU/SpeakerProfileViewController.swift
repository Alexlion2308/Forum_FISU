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
        guard let speaker = self.jsonSpeaker else{
            print("guard json speaker detail profile")
            return
        }
        guard let profileImageUrl = NSURL(string:speaker["imageSpeaker"].toString()) else{
            return
        }
        guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
            return
        }
        let myImage =  UIImage(data: profileImageData)
        self.NameLabelSpeaker.text = speaker["nameSpeaker"].toString()
        self.SurnameLabelSpeaker.text = speaker["surnameSpeaker"].toString()
        self.ProvenanceLabelSpeaker.text = speaker["nationaliteSpeaker"].toString()
        self.ProfessionLabelSpeaker.text = speaker["professionSpeaker"].toString()
        self.DescriptionLabelSpeaker.text = speaker["descriptionSpeaker"].toString()
        self.ProfilImageSpeaker.image = myImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
