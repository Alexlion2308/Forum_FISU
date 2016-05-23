//
//  EmergencysViewController.swift
//  FISU
//
//  Created by Reda M on 23/05/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit

class EmergencysViewController: UIViewController {
    
    @IBOutlet weak var imageDoctor: UIImageView!
    @IBOutlet weak var imageOrganisateurs: UIImageView!
    @IBOutlet weak var imageAmbulance: UIImageView!
    @IBOutlet weak var imagePoison: UIImageView!
    @IBOutlet weak var imageFire: UIImageView!
    @IBOutlet weak var imagePolice: UIImageView!
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewDoc = imageDoctor
        let imageViewOrga = imageOrganisateurs
        let imageViewAmb = imageAmbulance
        let imageViewPoison = imagePoison
        let imageViewFire = imageFire
        let imageViewPolice = imagePolice
        
        let tapGestureRecognizerDoc = UITapGestureRecognizer(target:self, action:#selector(EmergencysViewController.doctorImageTapped(_:)))
        imageViewDoc.userInteractionEnabled = true
        imageViewDoc.addGestureRecognizer(tapGestureRecognizerDoc)
        let tapGestureRecognizerOrga = UITapGestureRecognizer(target:self, action:#selector(EmergencysViewController.orgaImageTapped(_:)))
        imageViewOrga.userInteractionEnabled = true
        imageViewOrga.addGestureRecognizer(tapGestureRecognizerOrga)
        let tapGestureRecognizerAmb = UITapGestureRecognizer(target:self, action:#selector(EmergencysViewController.ambulanceImageTapped(_:)))
        imageViewAmb.userInteractionEnabled = true
        imageViewAmb.addGestureRecognizer(tapGestureRecognizerAmb)
        let tapGestureRecognizerPoison = UITapGestureRecognizer(target:self, action:#selector(EmergencysViewController.poisonImageTapped(_:)))
        imageViewPoison.userInteractionEnabled = true
        imageViewPoison.addGestureRecognizer(tapGestureRecognizerPoison)
        let tapGestureRecognizerFire = UITapGestureRecognizer(target:self, action:#selector(EmergencysViewController.fireImageTapped(_:)))
        imageViewFire.userInteractionEnabled = true
        imageViewFire.addGestureRecognizer(tapGestureRecognizerFire)
        let tapGestureRecognizerPolice = UITapGestureRecognizer(target:self, action:#selector(EmergencysViewController.policeImageTapped(_:)))
        imageViewPolice.userInteractionEnabled = true
        imageViewPolice.addGestureRecognizer(tapGestureRecognizerPolice)
    }
    
    func policeImageTapped(img: AnyObject)
    {
        print("police")
        callNumber("0651278982")
    }
    func ambulanceImageTapped(img: AnyObject)
    {
        print("amb")
        callNumber("0651278982")
    }
    func fireImageTapped(img: AnyObject)
    {
        print("fire")
        callNumber("0651278982")
    }
    func orgaImageTapped(img: AnyObject)
    {
        print("orga")
        callNumber("0651278982")
    }
    func doctorImageTapped(img: AnyObject)
    {
        print("doctor")
        callNumber("0651278982")
    }
    func poisonImageTapped(img: AnyObject)
    {
        print("poison")
        callNumber("0651278982")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
