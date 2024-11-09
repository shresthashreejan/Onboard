/**
 * @description Class for ContentDocument object.
 */
public with sharing class ContentDocument {
    /**
     * @description Method to prevent file upload if resource is already linked.
     */
    public static void preventFileUploadIfLinked(List<ContentDocument> contentDocs) {
        System.assert(false, contentDocs[0]);
    }
}