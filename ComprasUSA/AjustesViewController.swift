//
//  AjustesViewController.swift
//  ComprasUSA
//
//  Created by Rafael Fioretti on 4/16/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit
import CoreData

enum SettingsType: String {
    case cotacaoDolar = "cotacao_dolar"
    case vlIOF = "vl_iof"
}

enum CategoryAlertType {
    case add
    case edit
}

class AjustesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var etCotacao: UITextField!
    @IBOutlet weak var etIOF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var dataSource: [Estado] = []
    var fetchedResultController: NSFetchedResultsController<Estado>!
    var label : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Lista de estados vazia"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        loadEstados()
        
        etCotacao.delegate = self
        etIOF.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func addEstado(_ sender: Any) {
        showAlert(type: .add, estado: nil)
    
    }
    
    func showAlert(type: CategoryAlertType, estado: Estado? ){
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (tfName: UITextField) in
            tfName.placeholder = "Nome do estado"
            if let name = estado?.name {
                tfName.text = name
            }
        }
        alert.addTextField { (tfImposto: UITextField) in
            tfImposto.placeholder = "Imposto"
            if let imposto = estado?.vl_imposto {
                tfImposto.text = "\(imposto)"
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (UIAlertAction) in
            let estado = estado ?? Estado(context: self.context)
            estado.name = alert.textFields?.first?.text
            estado.vl_imposto = (Double((alert.textFields?[1].text)!))!
            do{
                try self.context.save()
                self.loadEstados()
            } catch {
                print (error.localizedDescription)
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowed = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowed.isSuperset(of: characterSet)
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
    
    func loadEstados(){
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //fetchedResultController.delegate = self
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
            
        } catch{
            print(error.localizedDescription)
        }
    
    
    }
    
}


extension AjustesViewController: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}

extension AjustesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let estado = dataSource[indexPath.row]
        showAlert(type: .edit, estado: estado)

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let estado = self.dataSource[indexPath.row]
            self.context.delete(estado)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [deleteAction]
    }
    
}

extension AjustesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataSource.count == 0{
            self.tableView.backgroundView = label
            self.tableView.separatorStyle = .none

        }else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine

        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let estado = dataSource[indexPath.row]
        cell.textLabel?.text = estado.name
        cell.detailTextLabel?.text = "\(estado.vl_imposto)"
    
        return cell
    }
    

    
    }





