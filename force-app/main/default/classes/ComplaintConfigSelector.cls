/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface ComplaintConfigSelector extends fflib_ISObjectSelector {
    List<CRM_TWD_Complaint_Creation__mdt> selectAll();
}