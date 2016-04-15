//
//  RestaurantDetailViewController.swift
//  FISU
//
//  Created by Aurelien Licette on 11/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    
    var restaurantSelected : Restaurant?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var LabelNomRestaurant: UILabel!
    @IBOutlet weak var LabelRueRestaurant: UILabel!
    @IBOutlet weak var LabelCPVilleRestaurant: UILabel!
    @IBOutlet weak var LabelTelephoneRestaurant: UILabel!
    @IBOutlet weak var LabelType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        guard let restaurant = self.restaurantSelected else{
            return
        }
        guard let restaurantNom = restaurant.nom else {
            return
        }
        guard let restaurantNumRue = restaurant.numRue else {
            return
        }
        guard let restaurantNomRue = restaurant.nomRue else {
            return
        }
        guard let restaurantCP = restaurant.codePostal else {
            return
        }
        guard let restaurantVille = restaurant.ville else {
            return
        }
        guard let restaurantLatitude = restaurant.latitude else {
            return
        }
        guard let restaurantLongitude = restaurant.longitude else {
            return
        }
        guard let restaurantTel = restaurant.telephone else {
            return
        }
        guard let restaurantType = restaurant.type else {
            return
        }
        
        self.LabelNomRestaurant.text = restaurantNom
        self.LabelRueRestaurant.text = restaurantNumRue+" "+restaurantNomRue
        self.LabelCPVilleRestaurant.text = restaurantCP+" "+restaurantVille
        self.LabelTelephoneRestaurant.text = restaurantTel
        self.LabelType.text = restaurantType
        
        
        
        // Do any additional setup after loading the view.
        let initialLocation = CLLocation(latitude: Double(restaurantLatitude), longitude: Double(restaurantLongitude))
        
        centerMapOnLocation(initialLocation)
        
        let artwork = Artwork(title: restaurantNom,
            locationName: restaurantNumRue+" "+restaurantNomRue,
            coordinate: CLLocationCoordinate2D(latitude: Double(restaurantLatitude), longitude: Double(restaurantLongitude)))
        
        mapView.addAnnotation(artwork)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

   
}
