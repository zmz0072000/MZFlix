//
//  ViewController.swift
//  MZFlix
//
//  Created by Muzhi Zhang on 2/12/21.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        let scoreDouble = movie["vote_average"] as! Double
        let score = Int(scoreDouble)

        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: (baseUrl + posterPath))
        
        cell.titleLabel!.text = title
        cell.synopsisLabel!.text = synopsis
        cell.scoreLabel!.text = "\(score)"
        cell.posterView.af_setImage(withURL: posterUrl!)
        
    
        
        
        return cell
    
    }
    

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //Properties of app
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // TODO: Get the array of movies
        // Pull the movie data from api. Credit: CodePath
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

            // TODO: Store the movies in a property to use elsewhere
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            
            
              // TODO: Reload your table view data
            self.tableView.reloadData()

           }
        }
        task.resume()
        
    }


}

