/*
* Created on Thur Dec 9, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface AsyncApexJobSelector extends fflib_ISObjectSelector {
    Boolean isJobRunning(String className);
}