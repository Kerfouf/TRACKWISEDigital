/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface ExternalAssetSelector extends fflib_ISObjectSelector {
    List<Asset__x> selectById(Set<Id> recordIds);
}