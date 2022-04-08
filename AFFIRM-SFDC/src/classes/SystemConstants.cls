/** Adding a new picklist?  Copy and paste it from Salesforce into GoogleSheets or Excel
 * Put this formula as your last cell, and you can copy the formula results directly to the constants class
 * to get all the picklist values added at once.
 * ="public final String " & SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(B7," ",""),".",""),"-",""),"&",""),")",""),"(","") & " = '" & C7 & "';"
 * this formula turns this
 * Values	API Name
*/
public class SystemConstants {

    public static final Biz_Domains Domain {
        get {
            if (Domain == null) {
                Domain = new Biz_Domains();
            }
            return Domain;
        }
        set;
    }

    public class Biz_Domains {
        public final String AccountAll = 'Account - All';
        public final String ContactAll = 'Contact - All';

    }

}