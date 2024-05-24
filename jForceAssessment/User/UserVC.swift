import UIKit
import CoreData

class UserVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var candidates = ["Candidate 1", "Candidate 2", "Candidate 3", "Candidate 4"]
    var selectedCandidate: String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTVC", bundle: .main), forCellReuseIdentifier: "UserTVC")
        setupInitialData()
    }
    
    func setupInitialData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Candidate> = Candidate.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                for candidate in candidates {
                    let newCandidate = Candidate(context: context)
                    newCandidate.name = candidate
                    newCandidate.votes = 0
                }
                appDelegate.saveContext()
            }
        } catch {
            print("Failed to fetch candidates: \(error)")
        }
    }
    
    @IBAction func voteBtn(_ sender: UIButton) {
        guard let selectedCandidate = selectedCandidate else {
            showAlert(message: "Please select a candidate to vote for.")
            return
        }
        
        if hasUserAlreadyVoted(username: username) {
            showAlert(message: "You have already voted.")
        } else {
            saveVote(for: selectedCandidate)
        }
    }
    
    func hasUserAlreadyVoted(username: String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserVote> = UserVote.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to fetch user vote: \(error)")
            return false
        }
    }
    
    func saveVote(for candidate: String) {
        let context = appDelegate.persistentContainer.viewContext
        
        let userVote = UserVote(context: context)
        userVote.username = username
        userVote.votedFor = candidate
        
        let fetchRequest: NSFetchRequest<Candidate> = Candidate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", candidate)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let candidate = results.first {
                candidate.votes += 1
                appDelegate.saveContext()
                showAlert(message: "Vote submitted for \(candidate.name!)")
                
                
                tableView.reloadData()
            }
        } catch {
            print("Failed to fetch or update candidate: \(error)")
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}

extension UserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC", for: indexPath) as! UserTVC
        let candidate = candidates[indexPath.row]
        cell.circleimg.image = UIImage(named: candidate == selectedCandidate ? "circlefilled" : "circle")
        cell.namelabel.text = candidate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCandidate = candidates[indexPath.row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
