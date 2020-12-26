//
//  ViewController.swift
//  201226AFTest
//
//  Created by swahn on 2020/12/26.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    var row = [Row]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"CustomTableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://openapi.seoul.go.kr:8088/6d4d776b466c656533356a4b4b5872/json/bikeList/1/99"
        decode(url: url) {[weak self] (userData) in
            print(userData.rentBikeStatus.row)
            self?.row = userData.rentBikeStatus.row
            
        }
        
        // Do any additional setup after loading the view.
    }
    // AF로 요청해서 데이터 받는 메소드입니다.
    func decode(url: String, handler: @escaping (SeoulAPI) -> Void) {
        let resp = AF.request(url)
        resp.responseDecodable(of: SeoulAPI.self) { resp in
            switch resp.result {
            case .success(let userDatas):
                handler(userDatas)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController : UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.row.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"CustomTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell()}
        
        cell.row = self.row[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

// 저희가 필요한 리스트만 Struct에 파싱해 오기 위해 만들었습니다.
struct SeoulAPI: Codable {
    let rentBikeStatus: RentBikeStatus
}
struct RentBikeStatus: Codable {
    let row: [Row]
}
struct Row: Codable {
    let rackTotCnt: String
    let stationName: String
    let parkingBikeTotCnt: String
}


class CustomTableViewCell : UITableViewCell {
    
    var row : Row? {
        willSet{
            guard let item = newValue else { return }
            self.label1.text = item.rackTotCnt
            self.label2.text = item.parkingBikeTotCnt
            self.label3.text = item.stationName
        }
    }
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
