import UIKit
import CoreData

class AdminVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var candidates: [Candidate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCandidateData()
    }
    
    func fetchCandidateData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Candidate> = Candidate.fetchRequest()
        
        do {
            candidates = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch candidates: \(error)")
        }
    }
    @IBAction func logoutBtn(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension AdminVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminTVC", for: indexPath) as! adminTVC
        let candidate = candidates[indexPath.row]
        cell.displayLabel.text = "\(candidate.name ?? "") - Votes: \(candidate.votes)"
        return cell
    }
}
