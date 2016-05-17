//
//  SpeakersCollectionViewController.swift
//  FISU
//
//  Created by Reda M on 10/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit


class SpeakersCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    
    
    let reuseIdentifier: String = "speakersCollectionCell"
    var jsonSpeaker: JSON?
    var numberOfSpeakers: Int = 0
    
    func downloadAndUpdate() {
        jsonSpeaker = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeSpeaker.php")
        if let obj = jsonSpeaker { // Je récupere le json de la page
            self.jsonSpeaker = JSON(obj)
            guard let laCollection = self.collectionView else{
                print("guard laCollection")
                return
            }
            guard let jsonSpeakerToLoop = self.jsonSpeaker else{
            print("guard jsonSpeakerToLoop")
                return
            }
            laCollection.reloadData()
            var currentNumber: NSNumber = 0
            for (key, speaker) in jsonSpeakerToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                currentNumber = key as! NSNumber
            }
            self.numberOfSpeakers = Int(currentNumber) + 1
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.downloadAndUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSpeakers
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpeakersCollectionViewCell
        guard let theNameLabel = cell.nameLabel else{
            print("guard theNameLabel")
            return cell
        }
        guard let theProfilePicture = cell.profilePicture else{
            print("guard theProfilePicture")
            return cell
        }
        guard let jsonSpeakerToLoop = self.jsonSpeaker else{
            print("guard jsonSpeakerToLoop")
            return cell
        }
        for (key, speaker) in jsonSpeakerToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            let currentKey = key as! NSNumber
            if(currentKey == indexPath.row){
                theNameLabel.text = speaker["surnameSpeaker"].toString()
                guard let profileImageUrl = NSURL(string:speaker["imageSpeaker"].toString()) else{
                    return cell
                }
                guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
                    return cell
                }
                //print(speaker["descriptionSpeaker"].toString())
                let myImage =  UIImage(data: profileImageData)
                theProfilePicture.image = myImage
            }
        }
        
        
        return cell;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ProfileSpeakerDetailSegue") {
            guard let laCollectioView = collectionView else{
                return
            }
            guard let SpeakerIndex = laCollectioView.indexPathForCell(sender as! UICollectionViewCell) else{
                return
            }
            let detailVC = segue.destinationViewController as! SpeakerProfileViewController
            detailVC.speakerSelected = SpeakerIndex.row + 1
            detailVC.jsonSpeaker = self.jsonSpeaker
        }
    }
    
}
