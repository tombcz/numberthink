
import UIKit
import CoreData

//import SQLite3 // when Xcode 9 is released, we can use this and remove the Bridging-Header.h file

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.migrate()
        AppDelegate.setupDataFile(fileName:"words.csv")
        return true
    }
    
    //
    // Copies the file with the given name from the bundle into the Documents folder
    // if it does not already exist.
    //
    static func setupDataFile(fileName:(String)) {
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentsURL.appendingPathComponent(fileName)
        if !( (try? fileURL.checkResourceIsReachable()) ?? false) {
            let bundleURL = Bundle.main.resourceURL?.appendingPathComponent(fileName)
            try? FileManager.default.copyItem(atPath: (bundleURL?.path)!, toPath: fileURL.path)
        }
    }
    
    //
    // Migrates a user's custom peg word list from pre-v5 versions of the app. We
    // just check to see if the old sqlite database exists, and if so, extract the
    // word list, write our simple CSV file, and then rename the database file.
    //
    static func migrate() {
        let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbURL = documentsURL.appendingPathComponent("numberthink.sql")
        if ((try? dbURL.checkResourceIsReachable()) ?? false) {
            var words = [String:String]()
            var db: OpaquePointer?
            if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
                var statement: OpaquePointer?
                if sqlite3_prepare_v2(db, "select word, number from tb_Peg", -1, &statement, nil) == SQLITE_OK {
                    while sqlite3_step(statement) == SQLITE_ROW {
                        let word = String(cString:sqlite3_column_text(statement, 0))
                        let number = String(cString:sqlite3_column_text(statement, 1))
                        words[word] = number
                    }
                    sqlite3_finalize(statement)
                    statement = nil
                }
            }
            
            if words.count > 0 {
                var csv = String()
                for tuple in words {
                    csv.append("\(tuple.value),\(tuple.key)\n")
                }
                let csvURL = documentsURL.appendingPathComponent("words.csv")
                try? csv.write(to: csvURL, atomically: false, encoding: .utf8)
            }
            
            let newDbURL = documentsURL.appendingPathComponent("numberthink_old.sql")
            try? FileManager.default.moveItem(at: dbURL, to: newDbURL)
        }
    }
}
