

// This code snippet demonstrates adding a
// full-screen Autocomplete UI control

import UIKit
import GoogleMaps

class GoogleApiViewController: UIViewController {
    
    // TODO: Add a button to Main.storyboard to invoke onLaunchClicked.
    
    @IBAction func mapButton(sender: AnyObject) {
        onLaunchClicked(sender)
    }
    
    @IBOutlet weak var nameText: UITextView!
    
    @IBOutlet weak var newText: UITextView!
    
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
        nameText.text = place.name
        print("Place address: \(place.formattedAddress)")
        newText.text = place.formattedAddress
        print("Place attributions: \(place.attributions)")
        self.dismissViewControllerAnimated(true, completion: nil)
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

