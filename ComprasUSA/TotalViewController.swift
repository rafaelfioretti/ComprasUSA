//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Rafael Fioretti on 4/18/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    var cotacao : Double!
    var iof : Double!
    var totalDolar : Double =  0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cotacao = Double(UserDefaults.standard.string(forKey: SettingsType.cotacaoDolar.rawValue)!)
        iof = Double(UserDefaults.standard.string(forKey: SettingsType.vlIOF.rawValue)!)
        getSumProducts();
        loadLabels();
    
    }

    func getSumProducts(){
        
        var fetchedResultController: NSFetchedResultsController<Produto>!
        let fetchRequest: NSFetchRequest<Produto>  = Produto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try fetchedResultController.performFetch()
            for produto in fetchedResultController.fetchedObjects! {
                totalDolar = produto.valor + totalDolar
            }
        }catch{
            print(error.localizedDescription)
            
        }
        
    }
    
    
    func loadLabels(){
        let real = (totalDolar * cotacao * iof)
        lbTotalDolar.text = "\(totalDolar)"
        lbTotalReal.text = "\(real)"

    }
   
}
