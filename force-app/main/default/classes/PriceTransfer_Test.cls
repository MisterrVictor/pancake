@isTest
public class PriceTransfer_Test {

    @testSetup
    static void setup() {
        Pancake__c pancakeForAdditives = new Pancake__c(Name = 'Test Pancake');
        insert pancakeForAdditives;
        List<Additive__c> additives = new List<Additive__c>();
        List<Pancake_Additive__c> pancakeAdditives = new List<Pancake_Additive__c>();

        for(Integer i=0; i < 200; i++) {
            Additive__c additive = new Additive__c(
                Name='Test additive' + i,
                Price__c = 1
            );
            additives.add(additive);
        }
        insert additives;
        for(Additive__c additive : additives){
            Pancake_Additive__c pancakeAdditive = new Pancake_Additive__c(
                Pancake__c = pancakeForAdditives.Id,
                Additive__c = additive.Id,
                Price__c = 0
            );
            pancakeAdditives.add(pancakeAdditive);
        }
        insert pancakeAdditives;
    }

    @isTest static void TestAdditivePriceToChange(){
        List<Additive__c> selectAdditives = [SELECT Name, Price__c FROM Additive__c WHERE Name Like 'Test additive%'];

        for(Additive__c additive : selectAdditives){
            //change Price for additives
            additive.Price__c = 9.99;
        }
        update selectAdditives;
        //check related list
        List<Pancake_Additive__c> pancakeAdditivesCheck = [SELECT Additive__c, Price__c
                                                           FROM Pancake_Additive__c
                                                           WHERE Additive__c IN :selectAdditives
                                                          ];
        System.assertEquals(200, pancakeAdditivesCheck.size());
        //check related Price field
        List<Pancake_Additive__c> pancakeAdditivesCheckPrice = [SELECT Price__c
                                                                FROM Pancake_Additive__c
                                                               ];
        System.assertEquals(9.99, pancakeAdditivesCheckPrice[0].Price__c);

    }
}