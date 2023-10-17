/*
 * Created on Tue Nov 23, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

public interface ExternalProductConsumedSelector extends fflib_ISObjectSelector {
    List<ProductConsumed__x> selectByDateModified(DateTime asOf);
    List<ProductConsumed__x> selectByExternalIds(Set<Id> externalIds);
}