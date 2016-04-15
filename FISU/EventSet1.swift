//
//  EventSet1.swift
//  FISU
//
//  Created by Aurelien Licette on 18/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit


class EventSet1 {
 
    var tabEvents=[Event]()
    
    private var pvNom : String?
    var nom: String? {
        get {
            return self.pvNom        }
        set {
            guard let monNom = newValue where !monNom.isEmpty else
            {
                self.pvNom = nil
                return
            }
            self.pvNom = newValue
        }
    }
    
    
    init(nom:String?){
        self.tabEvents = []
        self.nom = nom
    }
    
    /*
    Permet de vérifier si un event est présent ou non dans la liste afin d'éviter les doublons lors de l'insertion
    */
    func exist (event : Event) -> Bool {
        let taille = tabEvents.count
        var resultat = false
        var i = 0
        
        while (i<taille && !resultat){
            if ((tabEvents[i].nom==event.nom)) {
                resultat = true
            }
            i++
        }
        
        return resultat
    }
    
    /*
    Ajoute un event à la liste existante des events. Lors de l'ajout les events sont classés par ordre alphabétique
    */
    func AddSpeaker(event : Event) {
        if (!exist(event)) {
            self.tabEvents.append(event)
            tabEvents.sortInPlace {(event1: Event, event2: Event) -> Bool in
                event1.nom < event2.nom
            }
        }
    }
    
    
    /*
    Permet de récupérer un event en renseignant l'index auquel il se trouve
    */
    func getEventByIndex(index :Int)->Event?{
        if (index <= -1 || index >= self.tabEvents.count)
        {
            return nil
        }
        else
        {
            return tabEvents[index]
        }
    }
    
    
    /*
    Permet de récupérer l'index auquel se trouve un event en le passant en paramètre de cette fonction
    */
    func getIndexByEvent(event :Event)->Int {
        var indice : Int = 0
        if (!exist(event))
        {
            return -1
        }
        else
        {
            while(!(tabEvents[indice].nom == event.nom))
            {
                indice++
            }
            return indice
        }
    }
    
    
    /*
    Cette fonction retourne le nombre d'events présent dans la liste des events
    */
    func numberEvent()->Int{
        return self.tabEvents.count
    }
    
    
    /*
    Permet de supprimer un event de la liste en renseignant l'index auquel il se trouve dans la liste
    */
    func deleteEvent(index :Int){
        if (index < -1 || index < self.tabEvents.count)
        {
            tabEvents.removeAtIndex(index)
        }
    }
   
}


