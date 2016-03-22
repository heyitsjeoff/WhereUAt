import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField! //text field for username
    @IBOutlet weak var passwordTF: UITextField! //text field for password
    @IBOutlet weak var sign_In_ref: UIButton! //sign in button reference
    @IBOutlet weak var create_an_account_ref: UIButton! //create an account button reference
    @IBOutlet weak var password2TF: UITextField! //text field for password2
    var signingIn = true //boolean state to determine if the user is signing in or creating an account
    let variables = Variables.self // declaration of static variables class
    
    ///Will either attempt to sign the user in or create an account, based on the current status
    @IBAction func signInBTN(sender: UIButton) {
        if(signingIn){
            signIn(usernameTF.text!, password: passwordTF.text!, theView: self)
        }//sign in action
        else{
            if(passwordTF.text != password2TF.text){//if passwords don't match
                let alert = UIAlertController(title: "Did Not Create Account",
                    message: "Passwords do not match",
                    preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK",
                    style: .Default) { (action: UIAlertAction) -> Void in
                }
                
                alert.addAction(okAction)
                
                presentViewController(alert,
                    animated: true,
                    completion: nil)
            }else{
                createAccount(usernameTF.text!,password:  passwordTF.text!, theView: self)
            }
        }//create account action
        
    }
    
    /// Modifies the current window from signing in to creating an account
    @IBAction func createAccountBTN(sender: UIButton) {
        if(signingIn == true){
            signingIn = false
            password2TF.hidden = false;
            create_an_account_ref.setTitle("Cancel", forState: .Normal)
            sign_In_ref.setTitle("Create Account", forState: .Normal)
        }//switch to create account view
        else{
            signingIn = true
            password2TF.hidden = true;
            create_an_account_ref.setTitle("Create an Account", forState: .Normal)
            sign_In_ref.setTitle("Sign In", forState: .Normal)
        }//switch to sign in view
    }
    
    
    
    func alertLogin(success: String){
        if(success == "true"){
            let alert = UIAlertController(title: "Where U At",
                message: "Welcome to the motherland!",
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Wavy",
                style: UIAlertActionStyle.Default) {
                    UIALertAction in
                    self.performSegueWithIdentifier("MessageThreads", sender: nil)
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
        }
        else if(success == "false"){
            let alert = UIAlertController(title: "Where U At",
                message: "Username/password combination is incorrect!",
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Cry",
                style: .Default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
        }
    }
    
    
    func alertCreateAnAcouunt(success: String){
        if(success == "true"){
            let alert = UIAlertController(title: "Where U At",
                message: "Your accound has been created!",
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Thanks",
                style: UIAlertActionStyle.Default) {
                    UIALertAction in
                    self.performSegueWithIdentifier("MessageThreads", sender: nil)
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
        }
        else if(success == "false"){
            let alert = UIAlertController(title: "Where U At",
                message: "That username is already taken",
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Cry",
                style: .Default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password2TF.hidden = true;
        usernameTF.alpha = 0.5
        passwordTF.alpha = 0.5
        password2TF.alpha = 0.5
    }

}

