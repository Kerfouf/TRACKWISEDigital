/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ProductConsumedSelector extends fflib_ISObjectSelector {
    Map<Id, Product_Consumed__c> selectProductsConsumedByExternalId(Set<Id> externalIds);
}