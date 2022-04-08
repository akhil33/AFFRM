public abstract class TestifyTestClass {
    protected ApexLimitDescribe testDescribe;


    public TestifyTestClass() {
        testDescribe = new ApexLimitDescribe();
        describeTest();
        startTestSetup(); //provided
        testSetup(); //user defined
        startTest(); //provided
        runTest(); //user defined
        stopTest(); //provided
        runAssertions(); //user defined
        endTestTeardown(); //provided
    }

    protected void startTestSetup() {
        //do the very start of the test class implementation

    }

    protected void endTestTeardown() {
        //do the very end of the test class implementation

    }

    protected virtual void startTest() {
        //do the Test.Start stuff

    }

    protected virtual void stopTest() {
        //do the Test.Stop stuff

    }

    //developer provides implementation of this
    // IE testDescribe.set...
    protected abstract void describeTest();

    //developer provides implementation of this
    // IE set up DataState
    protected abstract void testSetup();

    //developer provides implementation of this
    // IE calls a method
    protected abstract void runTest();

    //developer provides implementation of this
    // IE System.assert
    protected abstract void runAssertions();


}