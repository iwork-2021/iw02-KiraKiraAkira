//
//  ToDoTableViewController.swift
//  MyTodo
//
//  Created by KiraKiraAkira on 2021/10/27.
//

import UIKit

class ToDoTableViewController: UITableViewController{
    
    var items:[TodoItem]=[
        TodoItem(title: "homework", isChecked: false),
        TodoItem(title: "walk dog", isChecked: true),
        TodoItem(title: "dota", isChecked: true)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadItems()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        let item = items[indexPath.row]
        

        // Configure the cell...
        cell.title.text!=item.title
        if item.isChecked{
            cell.status.text!="✅"
        }else{
            cell.status.text!="☑️"
        }
        cell.backgroundColor=UIColor .clear
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addItem"{
            let addItemViewController = segue.destination as! ItemViewController
            addItemViewController.addItemDelegate=self
            
        }else if segue.identifier=="editItem"{
            let editItemViewController = segue.destination as! ItemViewController
            let cell=sender as! TodoTableViewCell
            var isChecked:Bool
            if cell.status.text!=="✅"{
                isChecked=true
            }else{
                isChecked=false
            }
            let item = TodoItem(title: cell.title.text!, isChecked: isChecked)
            editItemViewController.itemToEdit=item
            editItemViewController.itemIndex=tableView.indexPath(for: cell)!.row
            editItemViewController.editItemDelegate=self
            
        }
    }
    
    

}
extension ToDoTableViewController:AddItemDelegate{
    func addItem(item:TodoItem)  {
        self.items.append(item)
        self.tableView.reloadData()
    }
}
extension ToDoTableViewController:EditItemDelegate{
    func editItem(newItem: TodoItem, itemIndex: Int) {
        self.items[itemIndex]=newItem
        self.tableView.reloadData()
    }
}
extension ToDoTableViewController{
    func dataFilePath() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path!.appendingPathComponent("ToDoItems.json")
    }
    func saveAllItems()  {
        do{
            let data = try JSONEncoder().encode(items)
            try data.write(to:dataFilePath(),options:.atomic)
        }catch{
            print("can't save items.")
        }
    }
    func loadItems()  {
        let path=dataFilePath()
        if let data = try? Data(contentsOf: path){
            do{
                items=try JSONDecoder().decode([TodoItem].self, from: data)
            }catch{
                print("can't load from disk.")
            }
        }
    }
}
