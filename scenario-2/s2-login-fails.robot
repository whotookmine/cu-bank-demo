*** Settings ***
Library    SeleniumLibrary
Suite Teardown    Close All Browsers
Test Teardown     Capture Page Screenshot

*** Variables ***
${BASE_URL}              http://localhost:3000
${LOGIN_PATH}            /
${ACCOUNT_PATH}          /account/
${BROWSER}               chrome
${EXPLICIT_WAIT}         10s

# Known accounts for testing
${VALID_ACCOUNT_ID}      1111111111
${VALID_PASSWORD}        1234
${NON_EXIST_ACC}         9999999999

# Locators (ปรับตามแอปจริงหากต่าง)
${ACC_INPUT}             //*[@cid='l1']
${PWD_INPUT}             //*[@cid='l2']
${LOGIN_BTN}             //*[@cid='lc']
${LOGIN_ERROR_LABEL}     //*[@cid='login-error-mes']

# Expected error texts (อ้างอิงสเปค CU Bank)
${ERR_ACC_NUMERIC}       Your account ID should contain numbers only.
${ERR_ACC_10_DIGITS}     Your account ID must be exactly 10 digits long.
${ERR_ACC_NOT_FOUND}     User not found. Please check your account ID.
${ERR_PWD_NUMERIC}       Your password should contain numbers only.
${ERR_PWD_4_DIGITS}      Your password must be exactly 4 digits long.
${ERR_PWD_INCORRECT}     Incorrect password. Please try again.

*** Test Cases ***

TC2-02 Login fails: Account non-numeric
    Open Browser To Login
    Attempt Login And Expect Error    11111abc11    1234    ${ERR_ACC_NUMERIC}

TC2-03 Login fails: Account wrong length (9 digits)
    Open Browser To Login
    Attempt Login And Expect Error    111111111     1234    ${ERR_ACC_10_DIGITS}

TC2-04 Login fails: Account not found
    Open Browser To Login
    Attempt Login And Expect Error    ${NON_EXIST_ACC}    1234    ${ERR_ACC_NOT_FOUND}

TC2-05 Login fails: Password non-numeric
    Open Browser To Login
    Attempt Login And Expect Error    ${VALID_ACCOUNT_ID}    12a4    ${ERR_PWD_NUMERIC}

TC2-06 Login fails: Password wrong length (3 digits)
    Open Browser To Login
    Attempt Login And Expect Error    ${VALID_ACCOUNT_ID}    123     ${ERR_PWD_4_DIGITS}

TC2-07 Login fails: Incorrect password
    Open Browser To Login
    Attempt Login And Expect Error    ${VALID_ACCOUNT_ID}    0000    ${ERR_PWD_INCORRECT}

*** Keywords ***
Open Browser To Login
    ${url}=    Set Variable    ${BASE_URL}${LOGIN_PATH}
    Open Browser    ${url}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${ACC_INPUT}    ${EXPLICIT_WAIT}

Attempt Login And Expect Error
    [Arguments]    ${account}    ${password}    ${expected_error}
    Clear Element Text    ${ACC_INPUT}
    Input Text    ${ACC_INPUT}    ${account}
    Clear Element Text    ${PWD_INPUT}
    Input Text    ${PWD_INPUT}    ${password}
    Click Element    ${LOGIN_BTN}
    Wait Until Location Contains    ${LOGIN_PATH}    ${EXPLICIT_WAIT}
    Location Should Not Contain     ${ACCOUNT_PATH}
    Wait Until Element Is Visible   ${LOGIN_ERROR_LABEL}    ${EXPLICIT_WAIT}
    ${txt}=    Get Text    ${LOGIN_ERROR_LABEL}
    Should Be Equal    ${txt}    ${expected_error}
    Sleep    1s

Location Should Not Contain
    [Arguments]    ${path_part}
    ${loc}=    Get Location
    Should Not Contain    ${loc}    ${path_part}
