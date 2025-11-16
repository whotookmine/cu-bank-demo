*** Settings ***
Library    SeleniumLibrary
Suite Teardown    Close All Browsers
Test Teardown    Capture Page Screenshot

*** Variables ***
${BASE_URL}              http://localhost:3000
${LOGIN_PATH}            /
${ACCOUNT_PATH}          /account/
${BROWSER}               chrome
${ACCOUNT_ID}            1111111111
${PASSWORD}              1234
${EXPLICIT_WAIT}         10s

# locators
${ACC_INPUT}             //*[@cid='l1']
${PWD_INPUT}             //*[@cid='l2']
${LOGIN_BTN}             //*[@cid='lc']
${DEP_AMOUNT_INPUT}      //*[@cid='d1']
${DEP_SUBMIT_BTN}        //*[@cid='dc']
${DEP_ERROR_LABEL}       //*[@cid='deposite-error-mes']
# expected text (จากเอกสาร)
${ERR_INVALID_NUMBER}    Invalid balance amount. Please enter a valid number.
${ERR_POSITIVE_ONLY}     The amount must be greater than 0. Please enter a positive number.
${ERR_WHOLE}    The balance amount must be a whole number with no decimals.


*** Test Cases ***
TC3-1 Deposit fails with amount = 0
    [Tags]    scenario3    eq2
    Open App And Login
    Go To Account Page
    Clear Element Text    ${DEP_AMOUNT_INPUT}
    Input Text    ${DEP_AMOUNT_INPUT}    0
    Click Element    ${DEP_SUBMIT_BTN}
    Wait For Deposit Error Text    ${ERR_POSITIVE_ONLY}
    # Capture Evidence    scenario3-eq2-amount0

TC3-2 Deposit fails with negative amount
    [Tags]    scenario3    eq3
    Open App And Login
    Go To Account Page
    Clear Element Text    ${DEP_AMOUNT_INPUT}
    Input Text    ${DEP_AMOUNT_INPUT}    -100
    Click Element    ${DEP_SUBMIT_BTN}
    Wait For Deposit Error Text    ${ERR_POSITIVE_ONLY}
    # Capture Evidence    scenario3-eq3-negative

TC3-3 Deposit fails with non-numeric amount
    [Tags]    scenario3    eq4
    Open App And Login
    Go To Account Page
    Clear Element Text    ${DEP_AMOUNT_INPUT}
    Input Text    ${DEP_AMOUNT_INPUT}    abc
    Click Element    ${DEP_SUBMIT_BTN}
    Wait For Deposit Error Text    ${ERR_INVALID_NUMBER}
    # Capture Evidence    scenario3-eq4-nonnumeric

TC3-4 Deposit fails with decimal amount
    [Tags]    scenario3    eq4
    Open App And Login
    Go To Account Page
    Clear Element Text    ${DEP_AMOUNT_INPUT}
    Input Text    ${DEP_AMOUNT_INPUT}    20.00
    Click Element    ${DEP_SUBMIT_BTN}
    Wait For Deposit Error Text    ${ERR_WHOLE}

*** Keywords ***
Open App And Login
    Open Browser To Login
    Input Text    ${ACC_INPUT}    ${ACCOUNT_ID}
    Input Text    ${PWD_INPUT}    ${PASSWORD}
    Click Element    ${LOGIN_BTN}
    Wait Until Location Contains    ${ACCOUNT_PATH}    ${EXPLICIT_WAIT}

Open Browser To Login
    ${url}=    Set Variable    ${BASE_URL}${LOGIN_PATH}
    Open Browser    ${url}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${ACC_INPUT}    ${EXPLICIT_WAIT}

Go To Account Page
    ${url}=    Set Variable    ${BASE_URL}${ACCOUNT_PATH}
    Go To    ${url}
    Wait Until Element Is Visible    ${DEP_AMOUNT_INPUT}    ${EXPLICIT_WAIT}
    Sleep    1

Wait For Deposit Error Text
    [Arguments]    ${expected}
    Wait Until Element Is Visible    ${DEP_ERROR_LABEL}    ${EXPLICIT_WAIT}
    ${txt}=    Get Text    ${DEP_ERROR_LABEL}
    Should Be Equal    ${txt}    ${expected}
    Sleep    1s    # รอให้ข้อความแสดงเต็มก่อนถ่ายรูป

Capture Evidence
    [Arguments]    ${name}
    ${ts}=    Get Time    result_format=%Y%m%d-%H%M%S
    Set Screenshot Directory    ${EXECDIR}/evidence
    Capture Page Screenshot    ${name}-${ts}.png
