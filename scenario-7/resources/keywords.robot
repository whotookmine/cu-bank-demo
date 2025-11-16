*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}          http://localhost:3000
${ACCOUNT_NUMBER}    1122334455
${PASSWORD}          1234

*** Keywords ***

Open Browser And Login
    Open Browser    ${BASE_URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    id:accountId
    Input Text    id:accountId    ${ACCOUNT_NUMBER}
    Input Text    id:password     ${PASSWORD}
    Click Button    xpath=//button[text()="Login"]
    Wait Until Page Contains    Account

Logout And Close Browser
    Click Element    xpath=//button[text()="Logout"]
    Close Browser

Get Balance
    Wait Until Element Is Visible    //*[@id="root"]/div/div/div/div[2]/article/h1[3]
    ${text}=    Get Text    //*[@id="root"]/div/div/div/div[2]/article/h1[3]
    ${balance}=    Convert To Number    ${text}
    [Return]    ${balance}

Ensure Baseline Balance
    [Arguments]    ${target}
    ${current}=    Get Balance
    ${diff}=    Evaluate    ${target} - ${current}
    Run Keyword If    ${diff} > 0    Deposit Money    ${diff}
    Ensure Balance Equals    ${target}

Ensure Balance Equals
    [Arguments]    ${expected}
    ${now}=    Get Balance
    Should Be Equal As Numbers    ${now}    ${expected}

Deposit Money
    [Arguments]    ${amount}
    Wait Until Element Is Visible    css:.Card_card__1d4RB:nth-child(3) button
    Click Element    css:.Card_card__1d4RB:nth-child(3) button
    Input Text       id=amount    ${amount}
    Click Element    css:.Card_card__1d4RB:nth-child(3) button
    Sleep    1s

Pay Bill
    [Arguments]    ${billType}    ${amount}
    Scroll Element Into View    xpath=//h2[text()="Bill Payment"]
    Run Keyword If    '${billType}' != 'none'    Click Element    xpath=//input[@value="${billType}"]
    Input Text       xpath=//input[@id="amount"]    ${amount}
    Click Element    xpath=//button[@cid="bc"]
    Sleep    1s

Refresh Page Before Test
    Reload Page
    Wait Until Page Contains Element    xpath=//h2[text()="Bill Payment"]