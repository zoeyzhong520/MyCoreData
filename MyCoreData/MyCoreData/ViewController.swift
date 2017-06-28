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
    
    lazy var appDelegate:AppDelegate = {
        let tempAppDelegate = UIApplication.shared.delegate as! AppDelegate
        return tempAppDelegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UI
    func createPage() {
        self.view.backgroundColor = UIColor.white
        self.title = "CoreData"
        
        let right = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addData))
        self.navigationItem.rightBarButtonItem = right
        
        let left = UIBarButtonItem.init(title: "长按修改", style: .plain, target: self, action: #selector(change))
        self.navigationItem.leftBarButtonItem = left
        
        self.view.addSubview(self.tableView)
    }
    
    func addData() {
        //添加数据
        let context = getObjectContext()
        let description = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let person = Person(entity: description!, insertInto: context)
        person.name = "Joe"
        let age = arc4random()%30+1
        person.age = "\(age)"
        
        self.dataSource.add(person)//添加数据源
        let indexPath:IndexPath = NSIndexPath(row: self.dataSource.count-1, section: 0) as IndexPath
        self.tableView.insertRows(at: [indexPath], with: .left)//table插入数据
        self.appDelegate.saveContext()
    }
    
    func change() {
        
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
                self.dataSource.add(result)//添加到数据
            }
        } catch {
            let nserror = error as NSError
            print("查询失败:\(nserror), \(nserror.description)")
        }
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if (cell == nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        }
        
        //获取数据
        let person = self.dataSource[indexPath.row] as! Person
        cell?.textLabel?.text = "name:\(person.name!), age:\(person.age!)"
        
        // 添加长按手势操作
        let longPressgesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(tap:)))
        cell?.addGestureRecognizer(longPressgesture)
        
        return cell!
    }
    
    func cellLongPress(tap : UILongPressGestureRecognizer) {
        let index:CGPoint = tap.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: index)
        let cell = tap.view as! UITableViewCell
        
        let person = self.dataSource[indexPath!.row] as! Person
        person.name = "修改后的闪闪发光"
        cell.textLabel?.textColor = UIColor.orange
        self.tableView.reloadRows(at: [indexPath!], with: .fade)
        //保存数据
        self.appDelegate.saveContext()
    }
    
    //删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //1.获取数据源
            let person:Person = self.dataSource[indexPath.row] as! Person
            //2.删除数据数据源
            self.dataSource.remove(person)
            //3.删除单元格
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //4.删除数据管理器中的数据
            let context = getObjectContext()
            context.delete(person)
            //5.保存
            self.appDelegate.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        let person = self.dataSource[indexPath.row] as! Person
//        vc.title = "name: \(person.name!), age:\(person.age!)"
//        
//        let r = CGFloat(arc4random()%255)*1.0;
//        let g = CGFloat(arc4random()%255)*1.0;
//        let b = CGFloat(arc4random()%255)*1.0;
//        vc.view.backgroundColor = UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//        //取消选中状态
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
