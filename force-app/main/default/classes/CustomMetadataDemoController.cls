public with sharing class CustomMetadataDemoController {
    
    public WidgetPreset__mdt Record {get;set;}
    
    public String DeployId {get;set;}    
    
    public String DeployResult {get;set;}
    
    public PageReference init() {
        
        Record = [select DeveloperName, Label, DefaultNotification__c, Alias__c 
                    from WidgetPreset__mdt
                    where DeveloperName = 'BluetoohToothbrush'];
                    
        return null;
    }
    
    public PageReference save() {
                        
        DeployId = 
            cmds.CustomMetadata.Operations
                .callback(
                    cmds__MetadataDeployment__e.getSObjectType(),
                    cmds__MetadataDeployment__e.cmds__DeploymentId__c, 
                    cmds__MetadataDeployment__e.cmds__Result__c)
                .enqueueUpsertRecords(
                    new List<SObject> { Record })
                .deployId;
                        
        return null;
    }
    
    public PageReference saveHandler() {

        DeployId = null;                
        cmds.CustomMetadata.SaveRecordResult result = 
            (cmds.CustomMetadata.SaveRecordResult) 
                JSON.deserialize(DeployResult, cmds.CustomMetadata.SaveRecordResult.class);
        if(!result.success) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, result.message));            
        }            
        
        return null;
    }
}