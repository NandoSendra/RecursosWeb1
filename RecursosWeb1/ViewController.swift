//
//  ViewController.swift
//  RecursosWeb1
//
//  Created by Fernando Sendra on 8/3/16.
//  Copyright © 2016 Fernando Sendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var isbn: UITextField!
    
    @IBOutlet weak var contenidoTextView: UITextView!
    let paginaWeb = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    var texto : String = ""
    
    
    func asincrono(cadena: String) {
        
        var alertaText:NSString = ""
        let url = NSURL( string: cadena)
        let sesion = NSURLSession.sharedSession()
        let bloque = { (datos: NSData?, resp : NSURLResponse?, error : NSError?) -> Void in
            
            if let httpResponse = resp as? NSHTTPURLResponse {
                if (httpResponse.statusCode != 200) {
                    alertaText = "The URL isn't go. " + String (httpResponse.statusCode)
                }
            }
            else
            {
                if(error != nil) {
                    alertaText = "Error. " + error!.localizedDescription
                }
            }
            
            
            
            
            if (alertaText.length<1) {
                self.texto = String(NSString(data: datos!, encoding: NSUTF8StringEncoding))
            }
                dispatch_async(dispatch_get_main_queue())
                    {
                        
                        
                        if (alertaText.length > 0)
                        {
                            let alertController = UIAlertController(title: String(alertaText), message: "", preferredStyle: .Alert)
                            
                            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                             }
                            alertController.addAction(OKAction)
                            self.presentViewController(alertController, animated: true, completion:nil)
                            self.texto = ""
                        }
                        if (self.texto == "Optional({})") {
                            self.texto = "No hay resultados"
                        }
                        self.contenidoTextView.text = self.texto
                        
                    
            }
            
            
        }

        if (url != nil) {
            let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
        }
        else {
        
            let alertController = UIAlertController(title: "Url incorrect", message: "", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:nil)
            self.contenidoTextView.text = self.texto
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        contenidoTextView.text = self.texto
    }

    
    override func viewWillAppear(animated: Bool) {
        contenidoTextView.text = self.texto
    }
    @IBAction func finEdicion(sender: UITextField) {
        let cadena:String = paginaWeb + isbn.text!
        asincrono(cadena)
    }
    
    



}

