*** Settings ***
Library    SeleniumLibrary
Resource   ../testdata/test_data_case5.robot
Resource   ../testdata/environment.robot
Test Teardown    Close All Browsers

*** Test Cases ***
Verify Case 5 Transfer fail
    [Tags]    Case 5 Transfer fail - Invalid AcctId
    Open Browser    ${WEB_URL}     ${WEB_BROWSER}
    Maximize Browser Window

    #Step 1: Log in - Input account number
    Wait Until Element Contains    //h2    Login
    Input text    //*[@id='accountId']    ${test_data_acctnumber}
    ${acctnumber}=    Get Value    //*[@id='accountId']
    Should Be Equal    ${acctnumber}    ${test_data_acctnumber}
    sleep    1
    
    #Step 1: Log in - Input password
    Input text    //*[@id='password']    ${test_data_password}
    ${password}=    Get Value    //*[@id='password']
    Should Be Equal    ${password}    ${test_data_password}
    sleep    1
    
    #Step 1: Log in - press login button
    Click Element  //*[@cid='lc']
    sleep    1

    #Step 2: Deposit - Input deposit amnt
    Wait Until Element Contains    //h2    Account ID:
    Input text    //*[@cid='d1']    ${test_data_depositAmount}
    ${depositamount}=    Get Value    //*[@cid='d1']
    Should Be Equal    ${depositamount}    ${test_data_depositAmount}
    sleep    1
    
    #Step 2: Deposit - press deposit confirm button
    Click Element  //*[@cid='dc']
    sleep    1

    #Step 3: Withdraw - Input withdraw amnt
    Input text    //*[@cid='w1']    ${test_data_withdrawAmount}
    ${withdrawamount}=    Get Value    //*[@cid='w1']
    Should Be Equal    ${withdrawamount}    ${test_data_withdrawAmount}
    sleep    1

    #Step 3: Withdraw - press withdraw confirm button
    Click Element  //*[@cid='wc']
    sleep    1

    #Step 4: Transfer - Input transfer acctId 
    Input text    //*[@cid='t1']    ${test_data_transferAcctId}
    ${transferacctid}=    Get Value    //*[@cid='t1']
    Should Be Equal    ${transferacctid}    ${test_data_transferAcctId}
    sleep    1

    #Step 4: Transfer - Input transfer amnt 
    Input text    //*[@cid='t2']    ${test_data_transferAmnt}
    ${transferamnt}=    Get Value    //*[@cid='t2']
    Should Be Equal    ${transferamnt}    ${test_data_transferAmnt}
    sleep    1

    #Step 4: Transfer - press transfer confirm button
    Click Element  //*[@cid='tc']
    
    #Step 4: Transfer - verify message error
    Wait Until Element Contains    //*[@cid='transfer-error-mes']    ${test_data_fail_submit_transfer} 
    sleep    1