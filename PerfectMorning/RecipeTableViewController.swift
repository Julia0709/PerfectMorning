//
//  RecipeTableViewController.swift
//  PerfectMorning
//
//  Created by 岡田暁 on 2017-09-28.
//  Copyright © 2017 岡田暁. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RecipeTableViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {
    @IBOutlet var mainTableView: UITableView!
    var recipes: [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recipe"

        mainTableView.rowHeight = 350
        mainTableView.frame = view.frame
        view.addSubview(mainTableView)
        mainTableView.dataSource = self
        
        // Nib for RecipeTableViewCell
        let nib = UINib(nibName: "RecipeTableViewCell", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "RecipeTableViewCell")
        
        getRecipes()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Display custom cell
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as! RecipeTableViewCell
        recipeCell.update(recipe: recipes[indexPath.row])
        return recipeCell
    }

    func getRecipes() {
        let url = "http://food2fork.com/api/search?key=\(Constants.food2ForkApiKey)&q=shredded%20"
        let keyword = "chicken"
        Alamofire.request(url + keyword)
            .responseJSON { response in
                guard let object = response.result.value else {
                    return
                }
                
                let body = JSON(object)
                var recipes: [Recipe] = []
                for (_, recipe): (String, JSON) in body["recipes"] {
                    recipes.append(Recipe(recipeId: recipe["recipe_id"].string!,
                                          socialRank: recipe["social_rank"].int!,
                                          f2fUrl: recipe["f2f_url"].string!,
                                          title: recipe["title"].string!,
                                          imageUrl: recipe["image_url"].string!,
                                          publisher: recipe["publisher"].string!,
                                          publisherUrl: recipe["publisher_url"].string!,
                                          sourceUrl: recipe["source_url"].string!
                    ))
                }
                self.recipes = recipes
                self.mainTableView.reloadData()
        }
    }

}