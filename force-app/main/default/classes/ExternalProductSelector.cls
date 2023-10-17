/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface ExternalProductSelector extends fflib_ISObjectSelector {
    List<Product2__x> selectById(Set<Id> recordIds);
}