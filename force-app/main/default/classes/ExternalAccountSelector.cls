/*
* Created on Thurs Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ExternalAccountSelector extends fflib_ISObjectSelector {
    List<Account__x> selectById(Set<Id> recordIds);
}