//
//  BasketViewController.swift
//  BuyAgro
//
//  Created by Oluwakemi Onajinrin on 01/01/2021.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if MUser.currentUser() != nil {
            loadBasketFromFirestore()
        } else {
            
            self.updateTotalLabels(true)
        }
        
    }
    // IBOUTLETS
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var totalItemsLabel: UILabel!
    
    @IBOutlet weak var checkoutButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: VARS
    
    var basket : Basket?
    var allItems : [Item] = []
    var purchasedItemIds : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    // IB ACTIONS
    @IBAction func checkoutButtonpressed(_ sender: Any) {
        
        if MUser.currentUser()!.onBoard {
                    
                    tempFunction()
                    
                    addItemsToPurchaseHistory(self.purchasedItemIds)
                    emptyTheBasket()

                } else {
                    
                    self.hud.textLabel.text = "Please complete you profile!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
    }
    
    // MARK: LOAD BASKET
    private func loadBasketFromFirestore(){
        downloadBasketFromFirestore(MUser.currentId()) { (basket) in
            self.basket = basket
            self.getbasketItems()
            
        }
    }
    private func getbasketItems(){
        if basket != nil {
            downloaditems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: helper functions
    
    func tempFunction() {
           for item in allItems {
               print("we have ", item.id)
               purchasedItemIds.append(item.id)
           }
       }

    
    private func updateTotalLabels(_ isEmpty: Bool) {
         
         if isEmpty {
            totalItemsLabel.text = "0"
            totalLabel.text = returnBasketTotalPrice()
            
         }
         else {
            totalItemsLabel.text = "\(allItems.count)"
            totalLabel.text = returnBasketTotalPrice()
         }
         //TODO: Update the button status

     }
    
    
     private func returnBasketTotalPrice() -> String {
         
         var totalPrice = 0.0
         
         for item in allItems {
             totalPrice += item.price
         }
         
         return "Total price: " + convertToCurrency(totalPrice)
     }
    
    private func emptyTheBasket() {
            
            purchasedItemIds.removeAll()
            allItems.removeAll()
            tableView.reloadData()
            
            basket!.itemIds = []
            

            updatebasketToFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds]) { (error) in
                
                if error != nil {
                    print("Error updating basket ", error!.localizedDescription)
                }
                
                self.getbasketItems()
            }
            
        }
    
    private func addItemsToPurchaseHistory(_ itemIds: [String]) {
            
            if MUser.currentUser() != nil {
                
                print("item ids , ", itemIds)
                let newItemIds = MUser.currentUser()!.purchasedItemIds + itemIds
                
                updateCurrentUserInFirestore(withValues: [kPURCHASEDITEMIDS : newItemIds]) { (error) in
                    
                    if error != nil {
                        print("Error adding purchased items ", error!.localizedDescription)
                    }
                }
            }
            
        }

    
    //MARK: NAVIGATION
    private func showItemView(withItem: Item) {
            let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemView") as! ItemViewController
            itemVC.item = withItem
        
            self.navigationController?.pushViewController(itemVC, animated: true)
        }
//MARK: CHECKOUTBUTTONSTATUSUPDATE
    private func checkoutButtonStatusUpdate(){
        checkoutButtonOutlet.isEnabled = allItems.count > 0
        if checkoutButtonOutlet.isEnabled{
            checkoutButtonOutlet.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        else{
            
        }
    }
    private func disableCheckoututton(){
        checkoutButtonOutlet.isEnabled = false
        checkoutButtonOutlet.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    private func removeItemFromBasket(itemId: String){
        for i in 0..<basket!.itemIds.count {
            if itemId == basket?.itemIds[i] {
                basket!.itemIds.remove(at: i)
                
                return
            }
        }
    }
}

extension BasketViewController :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! itemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        return cell
    }
    // MARK: UI TABLEVIEW DELEGATE
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            removeItemFromBasket(itemId: itemToDelete.id)
            
            updatebasketToFirestore(basket!, withValues: [kITEMIDS : basket!.itemIds!]) { (error) in
                if error != nil {
                    print("error updating the basket", error!.localizedDescription)
                }
                self.getbasketItems()
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
    }
}
