

// This code snippet demonstrates adding a
// full-screen Autocomplete UI control

import UIKit
import GoogleMaps

class GoogleApiViewController: UIViewController {
    
    var placesClient: GMSPlacesClient?
    var placePicker: GMSPlacePicker?

    @IBOutlet weak var phonePlace: UITextView!
    @IBOutlet weak var priceRange: UITextView!
    @IBOutlet weak var rating: UITextView!
    @IBOutlet weak var horairePlace: UITextView!
    @IBOutlet weak var titlePlace: UITextView!
    @IBOutlet weak var imagePlace: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
    }
    // TODO: Add a button to Main.storyboard to invoke onLaunchClicked.
    
    @IBAction func mapButton(sender: AnyObject) {
        onLaunchClicked(sender)
    }
    
    @IBAction func pickPlaces(sender: AnyObject) {
        let center = CLLocationCoordinate2DMake(43.61077, 3.87672)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        guard let placePicked = placePicker else{
            print("no place picked")
            return
        }
        placePicked.pickPlaceWithCallback({ (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            guard let placeSelectedByClient = self.placesClient else{
                print("no client place picked")
                return
            }
            guard let laPlace = place else{
                print("pas de place")
                return
            }
            placeSelectedByClient.lookUpPlaceID(laPlace.placeID, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                if let place = place {
                    self.phonePlace.text = place.phoneNumber
                    print(place.openNowStatus)
                    self.titlePlace.text = place.name
                    placeSelectedByClient.lookUpPhotosForPlaceID(place.placeID, callback: { (photoMetaData, error) in
                        guard let metaPhoto = photoMetaData else{
                            return
                        }
                        if(metaPhoto.results.count > 0){
                            placeSelectedByClient.loadPlacePhoto(metaPhoto.results[0], callback: { (placeImage, error) -> Void in
                                if let error = error {
                                    print("lookup place id query error: \(error.localizedDescription)")
                                    return
                                }
                                self.imagePlace.image = placeImage
                            })
                        }
                        else{
                            self.imagePlace.image = from
                        }
                    })
                    self.horairePlace.text = place.formattedAddress
                    self.rating.text = "Rating: " + String(place.rating) + "/5"
                    self.priceRange.text = "Price range: " + String(place.priceLevel.rawValue) + "/4"
                } else {
                    print("No place details for \(laPlace.placeID)")
                }
            })
        })

        print("OK")

    }


    
    @IBOutlet weak var pickPlace: UIButton!
    
    // Present the Autocompleteta view controller when the button is pressed.
    @IBAction func onLaunchClicked(sender: AnyObject) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.presentViewController(acController, animated: true, completion: nil)
    }
    
}

extension GoogleApiViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(viewController: GMSAutocompleteViewController!, didAutocompleteWithPlace place: GMSPlace!) {
        print("Place name: \(place.name)")
        //nameText.text = place.name
        print("Place address: \(place.formattedAddress)")
        //newText.text = place.formattedAddress
        print("Place attributions: \(place.attributions)")
        self.dismissViewControllerAnimated(true, completion: nil)
        print("viewController")
    }
    
    func viewController(viewController: GMSAutocompleteViewController!, didFailAutocompleteWithError error: NSError!) {
        // TODO: handle the error.
        print("Error: \(error.description)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(viewController: GMSAutocompleteViewController!) {
        print("Autocomplete was cancelled.")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

