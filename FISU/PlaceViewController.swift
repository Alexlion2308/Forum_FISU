//
//  PlaceViewController.swift
//  FISU
//
//  Created by Aurelien Licette on 08/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {
    
    var placeSelected : Place?
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var labelNomPlace: UILabel!
    @IBOutlet weak var labelRuePlace: UILabel!
    @IBOutlet weak var labelVille: UILabel!
    
    
    //Remplissage des différents champs à partir du jour sélectionné
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        guard let place = self.placeSelected else{
            return
        }
        guard let placeNom = place.nom else {
            return
        }
        guard let placeNumRue = place.numRue else {
            return
        }
        guard let placeNomRue = place.nomRue else {
            return
        }
        guard let placeCP = place.codePostal else {
            return
        }
        guard let placeVille = place.ville else {
            return
        }
        guard let placeLatitude = place.latitude else {
            return
        }
        guard let placeLongitude = place.longitude else {
            return
        }
        
        self.labelNomPlace.text = placeNom
        self.labelRuePlace.text = placeNumRue+" "+placeNomRue
        self.labelVille.text = placeCP+" "+placeVille
        
        


        // Initialisation de la map en affichant la zone correspondant à la latitude et la longitude de l'endroit
        let initialLocation = CLLocation(latitude: Double(placeLatitude), longitude: Double(placeLongitude))
        
        //Solicitation de la fonction centerMapOnLocation afin d'effectuer un zoom sur la zone correspondante
        centerMapOnLocation(initialLocation)
        
        //Création du pin affichant avec précision l'endroit sélectionné, nom plus adresse renseigné permettant d'afficher ces informations lorsque l'utilisateur clique sur le pin
        let artwork = Artwork(title: placeNom,
            locationName: placeNumRue+" "+placeNomRue,
            coordinate: CLLocationCoordinate2D(latitude: Double(placeLatitude), longitude: Double(placeLongitude)))
        
        //Ajout du pin
        mapView.addAnnotation(artwork)
        
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
