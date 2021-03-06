trigger PriceTransfer on Additive__c (before insert, before update, after insert, after update) {

    if(Trigger.isAfter && Trigger.isUpdate && Recursion.isFirst){
        Recursion.isFirst = false;
        List<Pancake_Additive__c> pancakesToUpdate = new List<Pancake_Additive__c>();

        List<Pancake_Additive__c> pancakeAdditives = [
            SELECT Price__c, Additive__r.Price__c//Price_Additive__c,
            FROM Pancake_Additive__c
            WHERE Additive__c IN :Trigger.New
        ];

        for(Pancake_Additive__c pan : pancakeAdditives){
            pan.Price__c = pan.Additive__r.Price__c;  //Formula: Price_Additive (Currency) = Additive__r.Price__c
            pancakesToUpdate.add(pan);
        }

        update pancakesToUpdate;
    }
}