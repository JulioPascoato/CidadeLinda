//
//  OcorrenciasFormViewController.swift
//  CidadeLinda
//
//  Created by Julio Pascoato on 27/04/24.
//

import UIKit
import MapKit

class OcorrenciasFormViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var imageViewEvent: UIImageView!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var buttonAddEdit: UIButton!
    @IBOutlet weak var textViewDescriptions: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var locationManager = CLLocationManager()
    
    var ocorrencia: Ocorrencia?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        requestAuthorization()
        
        if let ocorrencia = ocorrencia{
            title = "Edição"
            
            textFieldTitle.text = ocorrencia.name
           
            if let image = ocorrencia.image{
                imageViewEvent.image = UIImage(data: image)
            }
            textViewDescriptions.text = ocorrencia.descriptions
            buttonAddEdit.setTitle("Alterar", for: .normal)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {return}
        
        let bottomMargin = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomMargin
        scrollView.verticalScrollIndicatorInsets.bottom = bottomMargin
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    
    func requestAuthorization(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        if ocorrencia == nil{
            ocorrencia = Ocorrencia(context: context)
        }
        
        
        print(mapView.userLocation.location?.coordinate.latitude as Any)
        
       
        
        ocorrencia?.name = textFieldTitle.text
        ocorrencia?.descriptions = textViewDescriptions.text
        ocorrencia?.image = imageViewEvent.image?.jpegData(compressionQuality: 0.9)
        
        if let latitude = mapView.userLocation.location?.coordinate.latitude {
            ocorrencia?.latitude = latitude
            
        }
        
        if let longitude = mapView.userLocation.location?.coordinate.longitude {
            ocorrencia?.longitude = longitude
            
        }
        
        try? context.save()
        navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func selectEventImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você deseja escolher a imagem da ocorrência?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self.selectPicture(sourceType: .camera)
            }
            
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { _ in
            // Aqui vai o código
            self.selectPicture(sourceType: .photoLibrary)
        }
        
        alert.addAction(libraryAction)
        
        let albumAction = UIAlertAction(title: "Álbum de fotos", style: .default) { _ in
            // Aqui vai o código
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        
        alert.addAction(albumAction)
        
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


extension OcorrenciasFormViewController: MKMapViewDelegate{}


extension OcorrenciasFormViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewEvent.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
