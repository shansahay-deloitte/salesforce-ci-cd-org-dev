public class VehicleSummaryController {
    public List<Vehicle__c> vehicle {get; set;}
    public String pId {get; set;}
    public VehicleSummaryController(ApexPages.StandardController controller) {
        pId = ApexPages.currentPage().getParameters().get('id');
        vehicle = [SELECT Name, Make__c, Model__c, Year__c, Price__c, VIN__c, Inventory__c 
                        FROM Vehicle__c];
    }

    // Save the PDF to Notes & Attachments
    public PageReference SavePdf() {
        // Generate the PDF content
        PageReference pdfPage = Page.VehicleSummary;
        pdfPage.getParameters().put('id', this.pId);
        Blob pdfBlob = pdfPage.getContentAsPDF();

        // Create a attachment name
        Attachment attachment = new Attachment();
        attachment.Name = 'VehicleSummary.pdf';
        attachment.Body = pdfBlob;
        attachment.ParentId = pId;
        attachment.ContentType = 'application/pdf';
        insert attachment;

        PageReference vehiclePage = new PageReference('/' + pId);
        vehiclePage.setRedirect(true);
        return vehiclePage;
    }
}