//
//  FeedViewController.swift
//  Knila Task
//
//  Created by Pavan Kumar Mathala on 06/03/21.
//

import UIKit
import Alamofire
import Kingfisher
import CoreData

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var inputDataItems = [InputDataObject]()
    var usersData: [NSManagedObject] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
              //  self.removeLoader()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isConnectedToNetwork() == true
        {
            self.getData {
                self.fetchData()
            }
        }
        else {
            DispatchQueue.main.async {
                self.showAlertWith(title: "Error", message: "Please Check the Internet Connection")
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    //MARK:- Fetching response from API
    func getData(completion: @escaping (() -> Void)) {
        self.showLoader()
        AF.request(baseUrl).responseJSON { (response) in
            if let result = response.value {
                guard let json = result as? [String:Any] else { return }
                if let data = json["data"] as? [[String:Any]] {
                    self.inputDataItems = data.map{
                        var details = InputDataObject()
                        details.firstName = $0["first_name"] as? String
                        details.lastName = $0["last_name"] as? String
                        details.emailID = $0["email"] as? String
                        details.image = $0["avatar"] as? String
                        details.userId = $0["id"] as? Int16
                        return details
                        
                    }
                    self.deleteAllRecords()
                    for i in self.inputDataItems {
                        self.saveData(firstName: i.firstName ?? "", lastName: i.lastName ?? "", avatar: i.image ?? "", email: i.emailID ?? "", id: i.userId ?? 0)
                    }
                    
                }
                completion()
                self.removeLoader()
            }
        }
    }
    //MARK:- Saving API Data to CoreData
    private func saveData(firstName: String, lastName: String, avatar:String, email: String, id: Int16){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedObjContext) else {return}
        let users = NSManagedObject(entity: userEntity, insertInto: managedObjContext)
        users.setValue(firstName, forKey: "firstName")
        users.setValue(lastName, forKey: "lastName")
        users.setValue(avatar, forKey: "avatar")
        users.setValue(email, forKey: "emailId")
        users.setValue(id, forKey: "id")
        do{
            try managedObjContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    //MARK:- Fetching saved Data
    private func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do{
            let result = try managedObjContext.fetch(fetchRequest)
            self.usersData = result.map {$0 as! NSManagedObject}
        }catch{
            print(error.localizedDescription)
        }
    }
    //MARK:- Deleting the data from CoreData
    private func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}
//MARK:- TableView Datasource & Delegate Methods
extension FeedViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedTableViewCell.self), for: indexPath) as? FeedTableViewCell {
            let object = self.usersData[indexPath.row]
            let firstName = object.value(forKey: "firstName") as? String ?? ""
            let lastName = object.value(forKey: "lastName") as? String ?? ""
            cell.nameLabel.text = "\(String(firstName )) \(String(lastName ))"
            cell.emailLabel.text = object.value(forKey: "emailId") as? String ?? ""
            if let trimmed = object.value(forKey: "avatar") {
                cell.displayImage.kf.setImage(with: URL(string: trimmed as? String ?? ""))
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailVC = self.storyboard?.instantiateViewController(identifier: String(describing: DetailViewController.self)) as? DetailViewController {
            let object = self.usersData[indexPath.row]
            let firstName = object.value(forKey: "firstName") as? String ?? ""
            let lastName = object.value(forKey: "lastName") as? String ?? ""
            detailVC.name = "\(String(firstName )) \(String(lastName ))"
            detailVC.emailId = object.value(forKey: "emailId") as? String ?? ""
            detailVC.img = object.value(forKey: "avatar") as? String ?? ""
            detailVC.userId = String(object.value(forKey: "id") as? Int16 ?? 0)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
}
