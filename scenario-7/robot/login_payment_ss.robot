*** Settings ***
Documentation   Scenario 7 - Bill Payment Success (ตรงตาม Test Case Document)
Library         SeleniumLibrary
Resource        ../resources/keywords.robot

*** Variables ***
${WEB_URL}    http://localhost:3000/register
${BASE_URL}          http://localhost:3000
${ACCOUNT_NUMBER}    1122334455
${PASSWORD}          1234
${BILL_AMOUNT}       100
${BILL_ERR}          xpath=//p[contains(@class,"error")]
${BILL_SUCCESS_MSG}  xpath=//*[contains(text(),"Payment completed successfully.")]

*** Test Cases ***

Precondition Register Success
    Open Browser    ${WEB_URL}    chrome
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    ${ACCOUNT_NUMBER}
    Input text    //*[@id="password"]    ${PASSWORD}
    Input text    //*[@id="firstName"]    Owen
    Input text    //*[@id="lastName"]    OwenOwen
    Wait Until Element Is Visible    //*[@id="root"]/div/div/div/form/button
    Click Element    //*[@id="root"]/div/div/div/form/button

    Alert Should Be Present    Registration successful!


TC07-01 Pay Bill - Electric (Valid)
    [Documentation]    ทดสอบการชำระบิล Electric ด้วยจำนวนเงินถูกต้อง (amount=100)
    Open Browser And Login
    # Ensure precondition: balance >= 1000
    ${before}=    Get Balance
    Run Keyword If    ${before} < 1000    Deposit Money    ${1000 - ${before}}
    Ensure Balance Equals    1000

    # Step 1 - Select Electric bill
    Click Element    xpath=//input[@name="billTarget" and @value="electric"]

    # Step 2 - Fill valid amount
    Input Text    xpath=//input[@cid="b4" and @name="amount"]    100

    # Step 3 - Click Confirm
    Click Element    xpath=//button[@cid="bc"]

    Refresh Page Before Test

    Sleep    1

    # Step 4 - Verify success message & balance
    Ensure Balance Equals    900


TC07-02 Pay Bill - Water (Valid, Boundary = Full Balance)
    [Documentation]    ทดสอบการชำระบิล Water ด้วยจำนวนเงินเท่ากับยอดเงินคงเหลือ (Boundary)
    # Reset balance = 1000
    Open Browser And Login
    ${before}=    Get Balance
    Run Keyword If    ${before} < 1000    Deposit Money    ${1000 - ${before}}
    Ensure Balance Equals    1000

    # Step 1 - Select Water bill
    Click Element    xpath=//input[@name="billTarget" and @value="water"]

    # Step 2 - Fill valid amount = 1000 (Boundary)
    Input Text    xpath=//input[@cid="b4" and @name="amount"]    1000

    # Step 3 - Click Confirm
    Click Element    xpath=//button[@cid="bc"]

    Refresh Page Before Test

    Sleep    1

    # Step 4 - Verify success message & balance = 0
    Ensure Balance Equals    0


TC07-03 Pay Bill - Phone (Valid, Lower Boundary)
    [Documentation]    ทดสอบการชำระบิล Phone ด้วยจำนวนเงินต่ำสุดที่อนุญาต (Boundary = 1)
    # Reset balance = 1000
    Open Browser And Login
    Deposit Money    1000
    Ensure Balance Equals    1000

    # Step 1 - Select Phone bill
    Click Element    xpath=//input[@name="billTarget" and @value="phone"]

    # Step 2 - Fill amount = 1 (Lower boundary)
    Input Text    xpath=//input[@cid="b4" and @name="amount"]    1

    # Step 3 - Click Confirm
    Click Element    xpath=//button[@cid="bc"]

    Refresh Page Before Test

    Sleep    1

    # Step 4 - Verify success message & balance = 999
    Ensure Balance Equals    999