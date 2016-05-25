import UIKit
import CoreData

/**
 The view controller for the SignInView
 
 - Author:
 Jeoff Villanueva
 
 - version:
 1.0
 
 The sign in view will allow the user to either create an account or sign in. Once either
 of those two actions are performed, the user will be signed in
 */
class SignInViewController: UIViewController{

    @IBOutlet weak var usernameTF: UITextField! //text field for username
    @IBOutlet weak var passwordTF: UITextField! //text field for password
    @IBOutlet weak var sign_In_ref: UIButton! //sign in button reference
    @IBOutlet weak var create_an_account_ref: UIButton! //create an account button reference
    @IBOutlet weak var password2TF: UITextField! //text field for password2
    var signingIn = true //boolean state to determine if the user is signing in or creating an account
    let variables = Variables.self // declaration of static variables class
    var managedContext: NSManagedObjectContext!
    
    // MARK: View loads
    
    /**
     Notifies the view controller that its view was added to a view hierarchy and calls
     check if signed in
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - animated: If true, the view was added to the window using an animation
     
     - version:
     1.0
     */
    override func viewDidAppear(animated: Bool) {
        checkIfSignedIn()
    }
    
    /**
     hides the second password textfield and changes the transparency for all three text fields
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        password2TF.hidden = true;
        usernameTF.alpha = 0.5
        passwordTF.alpha = 0.5
        password2TF.alpha = 0.5
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        checkIfSignedIn()
    }
    
    // MARK: Buttons
    
    /**
     Called when the Sign In Button is selected
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - sender: the UIButton being pressed
     
     - version:
     1.0
     
     This function can sign a user in or create an account. The view is reused and the text labels are changed based on the status.
     */
    @IBAction func signInBTN(sender: UIButton) {
        if(signingIn){
            signIn(usernameTF.text!, password: passwordTF.text!, theView: self)
        }//sign in action
        else{
            if(passwordTF.text != password2TF.text){
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
            }//passwords don't match
            else{
                createAccount(usernameTF.text!,password:  passwordTF.text!, theView: self)
            }//passwords do match
        }//create account action
    }
    
    /**
     Called when the Create Account Button is selected. Changes the current view from a signing in view to a create an account view
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - sender: the UIButton being pressed
     
     - version:
     1.0
     
     The view is reused and the text labels are changed based on the status. It will either modify the view to allow sign in or creation of an account
     */
    @IBAction func createAccountBTN(sender: UIButton) {
        if(signingIn == true){
            signingIn = false
            password2TF.hidden = false; //unhides the second password textfield
            create_an_account_ref.setTitle("Cancel", forState: .Normal) //sets title of the Create An Account button to Cancel
            sign_In_ref.setTitle("Create Account", forState: .Normal) //sets the title of the Sign In button to Create Account
        }//switch to create account view
        else{
            signingIn = true
            password2TF.hidden = true; //hides the second password textfield
            create_an_account_ref.setTitle("Create an Account", forState: .Normal) //sets the title of the Cancel button to Create An Account
            sign_In_ref.setTitle("Sign In", forState: .Normal) //sets the title of the Create Account button to Sign In
        }//switch to sign in view
    }
    
    // MARK: Alert notifications
    
    /**
     Presents an alert based on the success status of a login attempt. A successful login will transition to the
     message table view and an unsuccessful login will leave the user at the sign in view
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - success: the success status of the login attempt
     
     - version:
     1.0
     */
    func alertLogin(success: String){
        if(success == "true"){
            setCredentials(usernameTF.text!, password: passwordTF.text!)
            downloadAll() //get pending data
            
            //create an alert notifying of a successful login
            let alert = UIAlertController(title: "Where U At",
                message: "Welcome to the motherland!",
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Wavy",
                style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.performSegueWithIdentifier("MessageThreads", sender: nil)
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
        }//sign in successful
        else if(success == "false"){
            //create an alert notifying of an unsuccessful login
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
        }//sign in unsuccessful
    }
    
    /**
     Presents an alert based on the success status of creating an account
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - parameters:
        - success: the status of whether or not the friend request response was sent
     
     - version:
     1.0
     
     A successful create account will transition to the message table view and an unsuccessful
     create account will leave the user at the sign in view
     */
    func alertCreateAnAcouunt(success: String){
        if(success == "true"){
            setCredentials(usernameTF.text!, password: passwordTF.text!)
            
            //create an alert notifying of a successful create account
            let alert = UIAlertController(title: "Where U At",
                message: "Your account has been created!",
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Thanks",
                style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    self.performSegueWithIdentifier("MessageThreads", sender: nil)
            }
            
            alert.addAction(okAction)
            
            presentViewController(alert,
                animated: true,
                completion: nil)
        }
        else if(success == "false"){
            //create an alert notifying of an unsuccessful create account
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
    
    /**
     Checks if the user is already signed in. If the user is signed in, the view will transition to the MessageTableView
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     */
    func checkIfSignedIn(){
        let fetchRequest = NSFetchRequest(entityName: "Login")
        do {
            let result =
                try managedContext.executeFetchRequest(fetchRequest)
            let credentials = result as! [NSManagedObject]
            if(credentials.count != 0){
                let login = credentials.first
                let theCachedName = login!.valueForKey("username") as! String
                setUsername(theCachedName)
                performSegueWithIdentifier("MessageThreads", sender: nil)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    /**
     Sets the local credentials for the user
     
     - Author:
     Jeoff Villanueva
     
     - returns:
     void
     
     - version:
     1.0
     
     This function will be called by alertLogin or alertCreateAccount
     */
    func setCredentials(username: String, password: String) {
        let entity =  NSEntityDescription.entityForName("Login", inManagedObjectContext:managedContext)
        
        let login = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        login.setValue(username, forKey: "username")
        login.setValue(password, forKey: "password")
        login.setValue(true, forKey: "loginFlag")
        setUsername(usernameTF.text!)
        
        //attempt a managedContext save
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

}

