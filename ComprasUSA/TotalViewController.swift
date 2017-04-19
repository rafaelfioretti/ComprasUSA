//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Rafael Fioretti on 4/18/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit

class TotalViewController: UIViewController {

    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    var cotacao : Double!
    var iof : Double!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cotacao = Double(UserDefaults.standard.string(forKey: SettingsType.cotacaoDolar.rawValue)!)
        iof = Double(UserDefaults.standard.string(forKey: SettingsType.vlIOF.rawValue)!)
        loadLabels();
    
    }

    
    func loadLabels(){
        var dolar = 1.0
        var real = (dolar * cotacao * iof)
        lbTotalDolar.text = "\(dolar)"
        lbTotalReal.text = "\(real)"

    }
   
}
