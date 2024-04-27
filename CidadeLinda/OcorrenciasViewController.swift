//
//  OcorrenciasViewController.swift
//  CidadeLinda
//
//  Created by Julio Pascoato on 27/04/24.
//

import UIKit
import MapKit
import CoreLocation

class OcorrenciasViewController: UIViewController {
    
    var ocorrencia: Ocorrencia?
    
    
    @IBOutlet weak var imageViewEvent: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var textViewDescriptions: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ocorrenciasFormViewController = segue.destination as? OcorrenciasFormViewController {
            ocorrenciasFormViewController.ocorrencia = ocorrencia
        }
        
    }
    
    func prepareScreen(){
        if let ocorrencia = ocorrencia{
            if let image = ocorrencia.image {
                imageViewEvent.image = UIImage(data: image)
            }
            
            
            labelTitle.text = ocorrencia.name
            textViewDescriptions.text = ocorrencia.descriptions
            
            let address = CLGeocoder.init()
            address.reverseGeocodeLocation(CLLocation.init(latitude: ocorrencia.latitude, longitude:ocorrencia.longitude)) { (places, error) in
                    if error == nil{
                        if let place = places{
                            //here you can get all the info by combining that you can make address
                            let endereço = place.first?.name
                            let city = place.first?.locality
                            let country = place.first?.country
                            
                            self.labelLocation.text = "\(endereço!) - \(city!) - \(country!)"
                        }
                    }
                }
            
 
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
