//
//  TableViewController.swift
//  MobileAppPortfolioFarras
//
//  Created by Farras on 22/09/23.
//

import UIKit

protocol TableViewViewProtocol: AnyObject {
    var presenter: TableViewPresenterProtocol? { get set }
    
    // MARK: Presenter to View
    func showTitle(with title: String)
}

class TableViewController: UITableViewController {
    
    var presenter: TableViewPresenterProtocol?
    
    var data: DonutChartData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad(data: data)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.data.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        
        if let data = data?.data[indexPath.row] {
            var content = cell.defaultContentConfiguration()
            content.text = data.nominal.asIdr
            content.secondaryText = data.trxDate
            
            cell.contentConfiguration = content
        }
        
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController: TableViewViewProtocol {
    func showTitle(with title: String) {
        self.title = title
    }
}
