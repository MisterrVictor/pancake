trigger PriceToTransfer on Pancake_Additive__c (before insert, before update) {
    
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {   
        
        Set<Id> additiveIds = new Set<Id>();
        for (Pancake_Additive__c pancakeAdditive : Trigger.new) {
            additiveIds.add(pancakeAdditive.Additive__c);
        }
        
        Map<Id, Additive__c> additivesMap = new Map<Id, Additive__c>([
            SELECT Price__c
            FROM Additive__c
            WHERE Id IN :additiveIds
        ]);
        
        for (Pancake_Additive__c pancakeAdditive : Trigger.new) {
            pancakeAdditive.Price__c = additivesMap.get(pancakeAdditive.Additive__c).Price__c;
        }              
        
    }
}