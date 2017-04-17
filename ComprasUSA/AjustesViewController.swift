//
//  AjustesViewController.swift
//  ComprasUSA
//
//  Created by Rafael Fioretti on 4/16/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit

enum SettingsType: String {
    case cotacaoDolar = "cotacao_dolar"
    case vlIOF = "vl_iof"
}

class AjustesViewController: UIViewController {
    
    @IBOutlet weak var etCotacao: UITextField!
    @IBOutlet weak var etIOF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        etCotacao.text = UserDefaults.standard.string(forKey: SettingsType.cotacaoDolar.rawValue)
        etIOF.text = UserDefaults.standard.string(forKey: SettingsType.vlIOF.rawValue)
    }
    
    @IBAction func cotacaoChange(_ sender: Any) {
              UserDefaults.standard.set(etCotacao.text, forKey: SettingsType.cotacaoDolar.rawValue)
    }

    
    @IBAction func iofChange(_ sender: Any) {
                  UserDefaults.standard.set(etIOF.text, forKey: SettingsType.vlIOF.rawValue)
    }
    
    
    
}
