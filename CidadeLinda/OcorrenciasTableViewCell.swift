//
//  OcorrenciasTableViewCell.swift
//  CidadeLinda
//
//  Created by Julio Pascoato on 27/04/24.
//

import UIKit
import MapKit
import CoreLocation

class OcorrenciasTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewEvent: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDescriptions: UILabel!
    
    @IBOutlet weak var labelLocation: UILabel!
    
    
    @IBOutlet weak var card: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureWith(_ ocorrencia: Ocorrencia){
       
              
        labelTitle.text = ocorrencia.name
        labelDescriptions.text = ocorrencia.descriptions
        
        if let image = ocorrencia.image{
            imageViewEvent.image = UIImage(data: image)
        }
        
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: ocorrencia.latitude, longitude:ocorrencia.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        //here you can get all the info by combining that you can make address
                        let endereço = place.first?.name
                        let city = place.first?.locality
                        
                        self.labelLocation.text = "\(endereço!) - \(city!)"
                    }
                }
            }
        
        
        card.clipsToBounds = false
        card.layer.cornerRadius = 5
        //card.backgroundColor = UIColor.white
        
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        card.layer.shadowOpacity = 1.0
        card.layer.masksToBounds = false
                
        
        
        
    
    }
    
  
}

extension OcorrenciasTableViewCell: MKMapViewDelegate{
      
}


