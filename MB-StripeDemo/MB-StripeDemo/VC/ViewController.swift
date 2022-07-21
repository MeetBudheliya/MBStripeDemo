//
//  ViewController.swift
//  MB-StripeDemo
//
//  Created by Meet's MAC on 19/07/22.
//

import UIKit
import Stripe
import Alamofire

class ViewController: UIViewController {

    private var types = [["type": "Gold", "amount":  65, "desc": "buy this ticket to become golden ticket member in show"],
                         ["type": "Silver", "amount": 35, "desc": "buy this ticket to become silver ticket member in show"],
                         ["type": "Bronze", "amount": 10, "desc": "buy this ticket to become bronze ticket member in show"]]

    private var amount = 65

    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var tblPaymentAmounts: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //UI setup
        self.title = "Payable Amount : \(self.amount)"


        payButton.setTitle("Pay now", for: .normal)
        payButton.backgroundColor = .systemIndigo
        payButton.layer.cornerRadius = 5
        payButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        payButton.addTarget(self, action: #selector(pay), for: .touchUpInside)
        payButton.isEnabled = true

        tableSetup()
        tblPaymentAmounts.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)


    }

    @objc
    func pay() {
        
//        createCustomer()
        self.createPaymentIntent()

    }


    //MARK: - Create Payment Intent
    func createPaymentIntent(){
        let params = ["currency": "inr",
                      "amount":amount*100,
                      "payment_method_types": ["card"]] as [String : Any]
        AF.request(URL(string: api_payment_intents)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).response { response in

            switch response.result{
            case .success(_):
                let json = response.data?.convertToDictionary()
                print(json as Any)
                if let cs = json?.value(forKey: "client_secret") as? String{
                    UserDefaults.standard.set(cs, forKey: "client_secret")
                    client_secret = UserDefaults.standard.string(forKey: "client_secret")
                    print("Created PaymentIntent")


                    guard let paymentIntentClientSecret = client_secret else {
                        return
                    }

                    var configuration = PaymentSheet.Configuration()
                    configuration.merchantDisplayName = "MB Solution, Inc."
                   configuration.returnURL = "mbdemo://stripe-redirect"

                    configuration.applePay = .init(
                        merchantId: "com.foo.example", merchantCountryCode: "US")
//                    configuration.customer = .init(
//                        id: Customer_ID ?? "", ephemeralKeySecret: ephemeral_key ?? "-")
//                    configuration.returnURL = "payments-example://stripe-redirect"
//                     Set allowsDelayedPaymentMethods to true if your business can handle payment methods that complete payment after a delay, like SEPA Debit and Sofort.
//                    configuration.allowsDelayedPaymentMethods = true

                    let paymentSheet = PaymentSheet(
                        paymentIntentClientSecret: paymentIntentClientSecret,
                        configuration: configuration)

                    paymentSheet.present(from: self) { [weak self] (paymentResult) in
                        switch paymentResult {
                        case .completed:
                            self?.alert(msg: "Payment complete!")
                        case .canceled:
                            print("Payment canceled!")
                        case .failed(let error):
                            self?.alert(msg: error.localizedDescription)
                        }
                    }

//                    DispatchQueue.main.async {
//                        self.payButton.isEnabled = true
//                    }
                    print("client_secret : \(client_secret ?? "-")")
                }else{
                    self.alert(msg: "client secret not found!!!")
                }
            case .failure(_):
                self.alert(msg: "ERROR : \(response.error?.localizedDescription ?? "-")")
            }
        }
    }

        //MARK: - Create Customer
        func createCustomer(){
            let params = ["name":"meet",
                          "email":"meet@gmail.com",
                          "balance":1250,
                          "description":"This amount is joining amount..."] as [String : Any]
            AF.request(URL(string: api_customers)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).response { response in

                switch response.result{
                case .success(_):
                    let json = response.data?.convertToDictionary()
                    print(json as Any)
                    if let id = json?.value(forKey: "id") as? String{
                        UserDefaults.standard.set(id, forKey: "CustID")
                        Customer_ID = UserDefaults.standard.string(forKey: "CustID")
                        self.generateEphemeralKey()
                    }else{
                        self.alert(msg: "Customer ID not found!!!")
                    }
                case .failure(_):
                    self.alert(msg: "ERROR : \(response.error?.localizedDescription ?? "-")")
                }
            }
        }

        //MARK: - Get Ephemeral key
        func generateEphemeralKey(){

            guard let cust_id = Customer_ID else {
                self.createCustomer()
                return
            }
            print("Customer_ID : \(cust_id)")

            let params = ["customer": cust_id] as [String : Any]
            let newHeader:HTTPHeaders = ["Authorization": "Bearer \(Secret_Key)",
                                         "Stripe-Version": "2020-08-27"]

            AF.request(URL(string: api_ephemeral_keys)!, method: .post, parameters: params, encoding: URLEncoding.default, headers: newHeader).response { response in

                switch response.result{
                case .success(_):
                    let json = response.data?.convertToDictionary()
                    print(json as Any)
                    if let id = json?.value(forKey: "secret") as? String{
                        UserDefaults.standard.set(id, forKey: "ephemeral_key")
                        ephemeral_key = UserDefaults.standard.string(forKey: "ephemeral_key")
                        self.createPaymentIntent()
                    }else{
                        self.alert(msg: "Ephemeral Key not found!!!")
                    }
                case .failure(_):
                    self.alert(msg: "ERROR : \(response.error?.localizedDescription ?? "-")")
                }
            }
        }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{

    func tableSetup(){
        tblPaymentAmounts.delegate = self
        tblPaymentAmounts.dataSource = self
        tblPaymentAmounts.register(UINib(nibName: "TypeTableViewCell", bundle: nil), forCellReuseIdentifier: "TypeTableViewCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPaymentAmounts.dequeueReusableCell(withIdentifier: "TypeTableViewCell") as! TypeTableViewCell
        let type = types[indexPath.row] as NSDictionary
        cell.lblTitle.text = type.value(forKey: "type") as? String
        cell.lblDesc.text = type.value(forKey: "desc") as? String
        cell.lblAmount.text = "\(type.value(forKey: "amount") as? Int ?? 0)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = types[indexPath.row] as NSDictionary
        self.amount = type.value(forKey: "amount") as? Int ?? 0

        self.title = "Payable Amount : \(self.amount)"
    }

}
