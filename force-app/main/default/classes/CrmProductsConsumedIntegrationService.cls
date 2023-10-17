/*
 * Created on Tue Nov 23, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

public interface CrmProductsConsumedIntegrationService {
    List<ProductConsumed__x> getExternalProductsConsumedByDateModified(DateTime asOf);
    List<ProductConsumed__x> getExternalProductsConsumedByExternalIds(Set<Id> externalIds);
    void upsertProductsConsumed(List<ProductConsumed__x> externalProductsConsumed);
}