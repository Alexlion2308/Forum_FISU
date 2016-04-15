//
//  SpeakerProfileViewController.swift
//  FISU
//
//  Created by Reda M on 26/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class SpeakerProfileViewController: UIViewController {
    
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var speakerSelected : Speaker?
    
    @IBOutlet weak var ProfilImageSpeaker: UIImageView!
    
    @IBOutlet weak var DescriptionLabelSpeaker: UITextView!
    
    @IBOutlet weak var ProfessionLabelSpeaker: UILabel!
    
    @IBOutlet weak var ProvenanceLabelSpeaker: UILabel!
    
    @IBOutlet weak var SurnameLabelSpeaker: UILabel!
    
    @IBOutlet weak var NameLabelSpeaker: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let speaker = self.speakerSelected else{
            return
        }
        guard let speakerNom = speaker.nom else{
            return
        }
        guard let speakerNationalite = speaker.nationalite else{
            return
        }
        guard let speakerProfession = speaker.profession else{
            return
        }
        guard let speakerDescription = speaker.desc else{
            return
        }
        guard let speakerPrenom = speaker.prenom else{
            return
        }
        guard let photo = speaker.profilePicture else{
            return
        }
        guard let imageProfile = UIImage(data: photo) else{
            return
        }
        
        self.NameLabelSpeaker.text = speakerNom
        self.SurnameLabelSpeaker.text = speakerPrenom
        self.ProvenanceLabelSpeaker.text = speakerNationalite
        self.ProfessionLabelSpeaker.text = speakerProfession
        self.DescriptionLabelSpeaker.text = speakerDescription
        self.ProfilImageSpeaker.image = imageProfile
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
