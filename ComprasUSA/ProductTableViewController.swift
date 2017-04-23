//
//  ProductTableViewController.swift
//  ComprasUSA
//
//  Created by Heitor Souza on 4/16/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController {
    
    var label : UILabel!
    
    var dataSource: [Produto] = []
    var produto: Produto!
    var fetchedResultController: NSFetchedResultsController<Produto>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        label.text = "Sua Lista está vazia!"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProduct()
        
        checkDataSourceIsEmpty()
    }
    
    func checkDataSourceIsEmpty(){
        if dataSource.count == 0 {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView = label
        } else{
             self.tableView.backgroundView = nil
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterProductViewController{
            //vc.product = dataSource[tableView.indexPathForSelectedRow!]
            if tableView.indexPathForSelectedRow != nil{
                vc.product = dataSource[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "prod", sender: indexPath)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        
        let product = dataSource[indexPath.row]
        
        // Configure the cell...
        if let image = product.imagem as? UIImage {
            cell.imageIcon.image = image
        } else{
            cell.imageIcon.image = UIImage(named: "gift_placeholder")
        }
        cell.productName.text = product.name
        cell.price.text = String(product.valor)
        cell.state.text = product.estados?.name!
        
        return cell
    }
    
    
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
           let product = self.dataSource[indexPath.row]
            self.context.delete(product)
            do {
                try self.context.save()
                self.dataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                checkDataSourceIsEmpty()
            } catch {
                print(error.localizedDescription)
            }
        }
    }*/
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let produto = self.dataSource[indexPath.row]
            self.context.delete(produto)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            self.checkDataSourceIsEmpty()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        
        
        return [deleteAction]
    }
    
    func loadProduct(){
        
        let fetchRequest: NSFetchRequest<Produto> = Produto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
            
        } catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension ProductTableViewController: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
}
