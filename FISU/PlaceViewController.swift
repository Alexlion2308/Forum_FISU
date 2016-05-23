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
    
    var jsonPlaces: JSON? = nil
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var labelNomPlace: UILabel!
    @IBOutlet weak var labelRuePlace: UILabel!
    @IBOutlet weak var labelVille: UILabel!
    
    
    //Remplissage des différents champs à partir du jour sélectionné
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        

        guard let jsonPlacesToLoop = self.jsonPlaces else{
            print("guard jsonEventsToLoop")
            return
        }
        for (_, places) in jsonPlacesToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            //print("Numéro con: " + events["numeroEvent"].toString()) // TRACE
            //print("Selectionné: " + String(selection)) // TRACE
                guard let latitude = Double(places["LatitudePlace"].toString()) else{
                    print("pas de latitude guard")
                    return
                }
                guard let longitude = Double(places["LongitudePlace"].toString()) else{
                    print("pas de longitude guard")
                    return
                }
                let nomPlace = places["NomPlace"].toString()
                let ruePlace = places["NomRuePlace"].toString()
                let numRuePlace = places["NumRuePlace"].toString()
                let villePlace = places["VillePlace"].toString()

                self.labelNomPlace.text = nomPlace
                self.labelRuePlace.text = ruePlace
                self.labelVille.text = villePlace

                // Initialisation de la map en affichant la zone correspondant à la latitude et la longitude de l'endroit
                let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
                
                //Solicitation de la fonction centerMapOnLocation afin d'effectuer un zoom sur la zone correspondante
                centerMapOnLocation(initialLocation)
                
                //Création du pin affichant avec précision l'endroit sélectionné, nom plus adresse renseigné permettant d'afficher ces informations lorsque l'utilisateur clique sur le pin
                let artwork = Artwork(title: nomPlace,
                                      locationName: numRuePlace+" "+ruePlace,
                                      coordinate: CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude)))
                
                //Ajout du pin
                mapView.addAnnotation(artwork)
        }
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
