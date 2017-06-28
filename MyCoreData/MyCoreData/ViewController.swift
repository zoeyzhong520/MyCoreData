//
//  ViewController.swift
//  MyCoreData
//
//  Created by JOE on 2017/6/28.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //MARK: - lazy
    lazy var tableView:UITableView = {
        let tbView = UITableView(frame: self.view.bounds, style: .plain)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.rowHeight = 50
        return tbView
    }()
    
    lazy var dataSource:NSMutableArray = {
        let tempArray = NSMutableArray()
        return tempArray
    }()
    
    var appdelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - 返回NSManagerContext
    func getObjectContext() -> NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        return context
    }

    //MARK: - 查询数据
    func fetchData() {
        //创建NSFetchRequest对象
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        //排序
        let sort = NSSortDescriptor(key: "age", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let context = getObjectContext()
            let fetchResults = try context.fetch(fetchRequest)
            for result in fetchResults {
                
            }
        } catch {
            
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
}
