/*
* Created on Wed Nov 17, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface GroupSelector extends fflib_ISObjectSelector{
    Group selectQueueByName(String queueName);
}