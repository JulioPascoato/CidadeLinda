//
//  OcorrenciasTableViewController.swift
//  CidadeLinda
//
//  Created by Julio Pascoato on 27/04/24.
//

import UIKit
import CoreData

class OcorrenciasTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Ocorrencia>!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ocorrenciaViewController = segue.destination as? OcorrenciasViewController,
            let indexPath = tableView.indexPathForSelectedRow{
            ocorrenciaViewController.ocorrencia = fetchedResultsController.object(at: indexPath)
        }
        
    }
    

    func loadEvents(){
        let fetchRequest: NSFetchRequest<Ocorrencia> = Ocorrencia.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OcorrenciasTableViewCell else {
       
        return UITableViewCell()
        }
        
        let ocorrencia  = fetchedResultsController.object(at: indexPath)

        cell.configureWith(ocorrencia)
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let  ocorrencia = fetchedResultsController.object(at: indexPath)
            context.delete(ocorrencia)
            try? context.save()
        }
    }
    
    

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension OcorrenciasTableViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
}
