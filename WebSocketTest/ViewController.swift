//
//  ViewController.swift
//  WebSocketTest
//
//  Created by AmyLin on 2022/5/1.
//

import UIKit

class ViewController: UIViewController,URLSessionWebSocketDelegate {
   
    @IBOutlet weak var m_btnConnect: UIButton!
    @IBOutlet weak var m_myTableView: UITableView!
    
    private var webSocket : URLSessionWebSocketTask?
    private var m_data:[String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        m_btnConnect.addTarget(self, action: #selector(closeSession), for: .touchUpInside)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://stream.yshyqxx.com/stream?streams=btcusdt@trade")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
        initTableView()
    }
    
    func initTableView() {
        m_myTableView.delegate = self
        m_myTableView.dataSource = self
        m_myTableView.separatorStyle = .none
        m_myTableView.allowsSelection = false
        m_myTableView.allowsMultipleSelection = false

    }
    
    //MARK: Receive
    func receive(){
        let workItem = DispatchWorkItem{ [weak self] in
            self?.webSocket?.receive(completionHandler: { result in
                switch result {
                case .success(let message):
                    switch message {
                    case .data(let data):
                        print("Data received \(data)")
                        
                    case .string(let strMessgae):
                    print("String received \(strMessgae)")
                        self?.m_data.append(strMessgae)
                        
                        DispatchQueue.main.async {
                            self?.m_myTableView.reloadData()
                        }
                        
                    default:
                        break
                    }
                
                case .failure(let error):
                    print("Error Receiving \(error)")
                }
                self?.receive()
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
    
    }
    
    //MARK: Send
    func send(){
        let workItem = DispatchWorkItem{
            
            self.webSocket?.send(URLSessionWebSocketTask.Message.string("Hello"), completionHandler: { error in
                
                if error == nil {
                    self.send()
                }else{
                    print(error)
                }
            })
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
    }
    
    //MARK: Close Session
    @objc func closeSession(){
        webSocket?.cancel(with: .goingAway, reason: "You've Closed The Connection".data(using: .utf8))
        
    }
    
    
    //MARK: URLSESSION Protocols
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        self.receive()
        self.send()
    }
    
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(String(describing: reason))")
    }

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? HeaderTableViewCell{
                cell.m_lbTime.text = "時間"
                cell.m_lbPrice.text = "價錢"
                cell.m_lbCount.text = "數量"
                return cell
            }
        }
        else if (m_data.count > 0 && indexPath.row != 0 ) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DataTableViewCell{
                cell.m_lbTime.text = ""
                cell.m_lbPrice.text = m_data[0]
                cell.m_lbCount.text = ""
                return cell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
}
