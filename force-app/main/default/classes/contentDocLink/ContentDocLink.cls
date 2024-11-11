/**
 * @description Class for ContentDocumentLink object.
 */
public with sharing class ContentDocLink {
    /**
     * @description Method to prevent ContentDocumentLink creation if resource is already linked.
     */
    public static void preventFileUploadIfLinked(List<ContentDocumentLink> contentDocLinks) {
        Map<Id, ContentDocumentLink> resourceWithDocLinkMap = new Map<Id, ContentDocumentLink>();
        for(ContentDocumentLink link : contentDocLinks){
            if(link.LinkedEntityId.getSObjectType().getDescribe().getName() == Resource.OBJECT_API_NAME) {
                resourceWithDocLinkMap.put(link.LinkedEntityId, link);
            }
        }

        if(!resourceWithDocLinkMap.isEmpty()) {
            List<ContentDocumentLink> docLinks = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: resourceWithDocLinkMap.keySet() WITH SECURITY_ENFORCED];

            Set<Id> linkedEntityIds = new Set<Id>();
            for(ContentDocumentLink existingLink : docLinks) {
                linkedEntityIds.add(existingLink.LinkedEntityId);
            }

            for(ContentDocumentLink link : contentDocLinks) {
                if(linkedEntityIds.contains(link.LinkedEntityId)) {
                    link.addError('Resource is already linked.');
                }
            }
        }
    }
}