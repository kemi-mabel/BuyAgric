//
//  itemsTableViewController.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 24/12/2020.
//

import UIKit


class itemsTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil{
            loadItems()
            
        }
    }
    //MARK  VARS
    var category : Category?
//    var item : Item
    var itemArray : [Item] = []

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell

        cell.generateCell(itemArray[indexPath.row])
        return cell
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
        
    }
    
//     MARK: - Navigation

//   In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemToAddItemSeg" {

            let vc = segue.destination as! AdditemViewController
            vc.category = category!
        }
    }
    
    private func showItemView(_ item: Item){
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemView") as! ItemViewController
        itemVC.item = item
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
//
    //MARK: Load Items
    private func loadItems() {
        downloadItemsFromFirebase(category!.id) { (allItems) in
            self.itemArray = allItems
            self.tableView.reloadData()
        }
    }
}




    
    


