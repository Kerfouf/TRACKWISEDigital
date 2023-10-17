/**
 * @File Name          : fflib_QualifiedMethodAndArgValuesTest.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 6/9/2020, 10:59:05 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/9/2020   Jon Astemborski     Initial Version
**/
@isTest
public with sharing class fflib_QualifiedMethodAndArgValuesTest
{
    @isTest
    private static void equalsReturnsExpectedResults()
    {
        fflib_QualifiedMethod qm1 = new fflib_QualifiedMethod('Type1', 'Method1', new List<Type>{ Integer.class } );
        fflib_MethodArgValues mav1 = new fflib_MethodArgValues(new List<Object>{ 'hello' });
        Object obj1 = 'hello';

        fflib_QualifiedMethodAndArgValues qmaav = new fflib_QualifiedMethodAndArgValues(qm1, mav1, obj1);

        fflib_QualifiedMethod qm2 = qmaav.getQualifiedMethod();
        fflib_MethodArgValues mav2 = qmaav.getMethodArgValues();
        Object obj2 = qmaav.getMockInstance();
        String string1 = qmaav.toString();

        System.assertEquals(qm1, qm2);
        System.assertEquals(mav1, mav2);
        System.assertEquals(obj1, obj2);
        System.assertEquals('Type1.Method1(Integer) with args: [hello]', string1);

    }
}