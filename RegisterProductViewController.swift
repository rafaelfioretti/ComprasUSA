//
//  RegisterProductViewController.swift
//  ComprasUSA
//
//  Created by Heitor Souza on 4/16/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit

class RegisterProductViewController: UIViewController {
    
    
    @IBOutlet weak var giftImage: UIImageView!
   
    var smallImage: UIImage!
    
    var pickerView: UIPickerView!
    
    
    @IBOutlet weak var txtProductName: UITextField!
    
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var txtPrice: UITextField!
    

    var dataSource = [
        "California",
        "New York"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolBar.items = [btCancel,btSpace,btDone]
        
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        
        present(imagePicker, animated:true, completion: nil)
        imagePicker.delegate = self
    }
    
    
    @IBAction func postGiftImage(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selectionar postar", message: "Escolher o poste do filme", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraAction = UIAlertAction(title: "Câmera", style: .default){
                (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            
            alert.addAction(cameraAction)
        }
        
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default){
            (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        
        alert.addAction(libraryAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
    @IBAction func saveProduct(_ sender: UIButton) {
    
    self.navigationController?.popToRootViewController(animated: true)
    }
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func cancel() {
        tfState.resignFirstResponder()
    }
    
    func done() {
        tfState.text = dataSource[pickerView.selectedRow(inComponent: 0)]
        cancel()
    }

}

extension RegisterProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        giftImage.image = image
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        giftImage.image = smallImage
        
        dismiss(animated: true, completion: nil)
        
        
    
    }
}


extension RegisterProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfState.text = dataSource[row]
    }
}

extension RegisterProductViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
}

