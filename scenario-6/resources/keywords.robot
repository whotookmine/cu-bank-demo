*** Settings ***
Library   SeleniumLibrary
Resource  ../config/env.robot
Resource  locators.robot

*** Keywords ***

Open Browser To Register
    Open Browser    http://localhost:3000/register    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    ${REG_ACC}    10s

Fill Register Form
    [Arguments]    ${accountId}    ${password}    ${firstName}    ${lastName}
    Clear Element Text    ${REG_ACC}
    Input Text            ${REG_ACC}      ${accountId}
    Clear Element Text    ${REG_PASS}
    Input Text            ${REG_PASS}     ${password}
    Clear Element Text    ${REG_FIRST}
    Input Text            ${REG_FIRST}    ${firstName}
    Clear Element Text    ${REG_LAST}
    Input Text            ${REG_LAST}     ${lastName}

Submit Register
    Click Button          ${REG_BTN}
    Sleep                 0.5s

Expect Register Success
    ${has_alert}=    Run Keyword And Return Status    Alert Should Be Present    3s
    Run Keyword If    ${has_alert}    Handle Alert    accept=True
    Wait Until Element Is Visible    ${INPUT_ACCOUNT}    10s

Open Browser And Login
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${INPUT_ACCOUNT}    10s
    Input Text    ${INPUT_ACCOUNT}    ${USER_ACC_N}
    Input Text    ${INPUT_PIN}        ${USER_PASS}
    Click Button  ${BTN_LOGIN}

    ${ok}=    Run Keyword And Return Status
    ...      Wait Until Page Contains Element    ${DEPOSIT_INPUT}    8s
    IF    not ${ok}
        ${err_present}=    Run Keyword And Return Status
        ...                Wait Until Page Contains Element    ${LOGIN_ERR}    3s
        IF    ${err_present}
            ${msg}=    Get Text    ${LOGIN_ERR}
            Fail    Login failed: ${msg}
        ELSE
            Fail    Login failed or /account not ready. Check backend & credentials.
        END
    END

Go To Account Page
    Go To    ${ACCOUNT_URL}
    Wait Until Element Is Visible    ${DEPOSIT_INPUT}    10s
    Sleep    1

Logout And Close
    Wait Until Element Is Visible    ${BTN_LOGOUT}    5s
    Click Element                    ${BTN_LOGOUT}
    Wait Until Element Is Visible    ${INPUT_ACCOUNT}    10s
    Close Browser

Get Balance
    ${txt}=    Get Text    ${H1_BALANCE}
    ${val}=    Evaluate    int(${txt})
    Sleep                 1.5s
    [Return]    ${val}

Deposit Money
    [Arguments]    ${amount}
    Clear Element Text    ${DEPOSIT_INPUT}
    Input Text            ${DEPOSIT_INPUT}    ${amount}
    Click Button          ${DEPOSIT_BTN}
    Sleep                 1.5s

Ensure Balance Equals
    [Arguments]    ${expected}
    Wait Until Keyword Succeeds    5x    1s    Balance Should Equal    ${expected}

Balance Should Equal
    [Arguments]    ${expected}
    ${cur}=    Get Balance
    Should Be Equal As Integers    ${cur}    ${expected}

Select Bill
    [Arguments]    ${bill}
    Run Keyword If    '${bill}'=='water'      Click Element    ${RADIO_WATER}
    ...              ELSE IF    '${bill}'=='electric'   Click Element    ${RADIO_ELECTRIC}
    ...              ELSE IF    '${bill}'=='phone'      Click Element    ${RADIO_PHONE}
    ...              ELSE    No Operation

Pay Bill
    [Arguments]    ${bill}    ${amount}
    Run Keyword If    '${bill}'!='none'    Select Bill    ${bill}
    Clear Element Text    ${BILL_AMOUNT}
    Input Text            ${BILL_AMOUNT}    ${amount}
    Click Button          ${BILL_CONFIRM}
    Sleep                 2s

Refresh Page Before Test
    Reload Page
    Wait Until Page Contains Element    ${DEPOSIT_INPUT}    10s
    Sleep    1s
    
Expect Bill Error Contains
    [Arguments]    ${snippet}
    Wait Until Page Contains Element    ${BILL_ERR}    5s
    Element Should Contain               ${BILL_ERR}    ${snippet}

Expect Bill Form Invalid
    ${valid}=    Execute Javascript    return document.querySelector('button[cid="bc"]').closest('form').checkValidity();
    Run Keyword If    ${valid}    Fail    Expected Bill Payment form to be invalid but it was valid
    Log    Bill Payment form invalid as expected (HTML5 validation triggered)

Expect Amount Field Invalid
    [Arguments]    ${locator}
    ${valid}=    Execute Javascript    return document.querySelector('${locator.replace("css:", "")}').checkValidity();
    Run Keyword If    ${valid}    Fail    Expected field to be invalid but it was valid
    Log    Input invalid as expected (HTML5 validation triggered)