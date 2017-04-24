//
//  RegisterProductViewController.swift
//  ComprasUSA
//
//  Created by Heitor Souza on 4/16/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit
import CoreData


class RegisterProductViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var giftImage: UIImageView!
   
    var smallImage: UIImage!
    
    var pickerView: UIPickerView!
    
    @IBOutlet weak var txtProductName: UITextField!
    
    
    @IBOutlet weak var tfState: UITextField!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var switchCredictCard: UISwitch!
    
    
    @IBOutlet weak var btnSave: UIButton!
    
    var product : Produto!
 
    var dataSourceState: [Estado] = []
    
    var fetchedResultController: NSFetchedResultsController<Estado>!
    
    var selectState : Estado!
    
    
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
        
        if product != nil{
            txtProductName.text = product.name
            txtPrice.text = String(product.valor)
            tfState.text = product.estados?.name!
            switchCredictCard.isOn = product.cartao
            if let image = product.imagem as? UIImage {
                giftImage.image = image
            }
            btnSave.setTitle("Atualizar", for: .normal)
        }else{
            btnSave.setTitle("Cadastrar", for: .normal)
        }
        
       
        txtPrice.delegate = self
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowed = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowed.isSuperset(of: characterSet)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadStates()
    }
    
    func loadStates(){
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultController.delegate = self
        do {
            dataSourceState = try context.fetch(fetchRequest)
            print("aaa")
            
        } catch{
            print(error.localizedDescription)
        }
        
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
        
        
        if txtPrice.text != nil && txtProductName.text != nil && tfState != nil {
            
            if product == nil{
                product = Produto(context: context)
                btnSave.setTitle("Cadastrar", for: .normal)
            } else{
                btnSave.setTitle("Atualizar", for: .normal)
            }
            
            product.name = txtProductName.text!
            product.valor = Double( txtPrice.text!)!
            
            if selectState != nil{
                product.estados = selectState
            }
            
            product.cartao = switchCredictCard.isOn
            product.imagem = giftImage.image
            
            
            do{
                try self.context.save()
            } catch {
                print (error.localizedDescription)
            }
            self.navigationController?.popToRootViewController(animated: true)
        
        } else{
            let alert = UIAlertController(title: "Validação", message: "Os campos Nome, Valor e Estado são obrigatórios", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
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
        if dataSourceState.count > 0{
            selectState = dataSourceState[pickerView.selectedRow(inComponent: 0)]
            tfState.text = dataSourceState[pickerView.selectedRow(inComponent: 0)].name
        }
        
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
        return dataSourceState[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectState = dataSourceState[row]
        tfState.text = dataSourceState[row].name
    }
}

extension RegisterProductViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceState.count
    }
    
}

extension RegisterProductViewController: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       
    }
    
}

