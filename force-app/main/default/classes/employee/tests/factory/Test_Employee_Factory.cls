/**
 * @description Factory class for Employee
 */
@isTest
public class Test_Employee_Factory {

    /**
     * @description Method to create employee record
     */
    public void createDepartment() {
        // ARRANGE: Insert manager
        Manager__c manager = new Manager__c(
            First_Name__c = 'createDepartment',
            Last_Name__c = '0',
            Email__c = 'manager001@email.com'
        );
        insert manager;

        // ARRANGE: Insert department
        Department__c department = new Department__c(
            Name = 'createDepartment',
            Manager__c = manager.Id
        );
        insert department;
    }

    /**
     * @description Method to create department and resource records
     */
    public void createDepartmentAndResource() {
        // ARRANGE: Insert manager
        Manager__c manager = new Manager__c(
            First_Name__c = 'createDepartmentAndResource',
            Last_Name__c = '0',
            Email__c = 'manager002@email.com'
        );
        insert manager;

        // ARRANGE: Insert department
        Department__c department = new Department__c(
            Name = 'createDepartmentAndResource',
            Manager__c = manager.Id
        );
        insert department;

        // ARRANGE: Insert content version
        ContentVersion contentVersion = new ContentVersion(
            Title = 'createDepartmentAndResource',
            PathOnClient = 'createDepartmentAndResource.pdf',
            VersionData = Blob.valueOf('Content data')
        );
        insert contentVersion;

        // ARRANGE: Insert resource
        Resource__c resource = new Resource__c(
            Name = 'createDepartmentAndResource',
            Department__c = department.Id,
            Role__c = 'Intern'
        );
        insert resource;

        // ARRANGE: Query content document
        ContentVersion insertedContentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id LIMIT 1];

        // ARRANGE: Insert content document link
        ContentDocumentLink contentDocLink = new ContentDocumentLink(
            ContentDocumentId = insertedContentVersion.ContentDocumentId,
            LinkedEntityId = resource.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert contentDocLink;
    }
}