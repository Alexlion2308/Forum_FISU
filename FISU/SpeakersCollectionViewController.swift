//
//  SpeakersCollectionViewController.swift
//  FISU
//
//  Created by Reda M on 10/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit


class SpeakersCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    
    var selctedSpeaker = Speaker()
    var dataSource: [Speaker]?
    let reuseIdentifier: String = "speakersCollectionCell"
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = Speaker.getAllSpeakers()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfSpeakers: Int = 0
        if self.searchBarActive {
            guard let resultSpeakers = self.dataSourceForSearchResult else{
                return 0
            }
            numberOfSpeakers = resultSpeakers.count;
        }
        else{
            guard let speakers = self.dataSource else{
                return 0
            }
            numberOfSpeakers = speakers.count
        }
        return numberOfSpeakers
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpeakersCollectionViewCell
       
        guard let theNameLabel = cell.nameLabel else{
            return cell
        }
        guard let theProfilePicture = cell.profilePicture else{
            return cell
        }
        guard let speakers = self.dataSource else{
            return cell
        }
        if (self.searchBarActive) {
            guard let resultSpeakers = self.dataSourceForSearchResult else{
                return cell
            }
            theNameLabel.text = resultSpeakers[indexPath.row]
        }else{
            theNameLabel.text = speakers[indexPath.row].prenom
            guard let profilePictureData = speakers[indexPath.row].profilePicture else{
                return cell
            }
            guard let profilePicture = UIImage(data: profilePictureData) else{
                return cell
            }
            theProfilePicture.image = profilePicture
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
            guard let speakers = self.dataSource else{
                return
            }
            detailVC.speakerSelected = speakers[SpeakerIndex.row]
        }
    }

}
