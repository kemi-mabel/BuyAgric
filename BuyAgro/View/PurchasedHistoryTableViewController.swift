//
//  PurchasedHistoryTableViewController.swift
//  BuyAgro
//
//  Created by mohammed sani hassan on 09/01/2021.
//

import UIKit

class PurchasedHistoryTableViewController: UITableViewController {

    //MARK: - Vars
        var itemArray : [Item] = []

        
        //MARK: - View Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.tableFooterView = UIView()
        
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            loadItems()
        }

        // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return itemArray.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell
            
            cell.generateCell(itemArray[indexPath.row])

            return cell
        }
        
        
        //MARK: - Load items
        
        private func loadItems() {
            
            downloaditems(MUser.currentUser()!.purchasedItemIds) { (allItems) in
                
                self.itemArray = allItems
                print("we have \(allItems.count) purchased items")
                self.tableView.reloadData()
            }
        }


    }
