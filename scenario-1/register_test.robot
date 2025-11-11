*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers

*** Variables ***
${WEB_URL}    http://localhost:3000/register
${WEB_BROWSER}    chrome

${ERR_NUMBER_ONLY}    Your account ID should contain numbers only.
${ERR_IN_USE}    This account ID is already in use. Please use a different account ID.
${ERR_LEN_10}    Your account ID must be exactly 10 digits long.
${ERR_FILL}    Please fill out this field.
${ERR_NUM_ONLY}    Your password should contain numbers only.
${ERR_LEN_4}    Your password must be exactly 4 digits long.
${ERR_LEN_30}    The combined length of your first and last name must not exceed 30 characters.
*** Test Cases ***
TC1: Register Success
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    1111111111
    Input text    //*[@id="password"]    1234
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Alert Should Be Present    Registration successful!

TC2: Register with NaN acc number
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    111111111a
    Input text    //*[@id="password"]    1234
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_NUMBER_ONLY}
    Page Should Contain    ${ERR_NUMBER_ONLY}

TC3: Register with existing Account Number
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    1111111111
    Input text    //*[@id="password"]    1234
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_IN_USE}
    Page Should Contain    ${ERR_IN_USE}

TC4: Register with Account Number len < 10
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    11111
    Input text    //*[@id="password"]    1234
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_LEN_10}
    Page Should Contain    ${ERR_LEN_10}

TC5: Register with Account Number len > 10
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    111111111111111
    Input text    //*[@id="password"]    1234
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_LEN_10}
    Page Should Contain    ${ERR_LEN_10}

# TC6: Register with empty Account Number
#     Open Browser    ${WEB_URL}    ${WEB_BROWSER}
#     Maximize Browser Window

#     Wait Until Element Is Visible    //*[@id="accountId"]
#     Input text    //*[@id="password"]    1234
#     Input text    //*[@id="firstName"]    Time
#     Input text    //*[@id="lastName"]    Patiphon
#     Click Element    //*[@id="root"]/div/div/div/form/button

#     ${input_field} =    Get WebElement    //*[@id="accountId"]
#     ${is_focus_visible} =    Execute Javascript    return arguments[0].matches(':focus-visible');    ARGUMENTS    ${input_field}
#     Should Be True    ${is_focus_visible}

TC6: Register Invalid Password NaN
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    1111111111
    Input text    //*[@id="password"]    123a
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_NUM_ONLY}
    Page Should Contain    ${ERR_NUM_ONLY}

TC7: Register Invalid Password Length less than 4
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    1111111111
    Input text    //*[@id="password"]    123
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_LEN_4}
    Page Should Contain    ${ERR_LEN_4}

TC8: Register Invalid Password Length greater than 4
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    1111111111
    Input text    //*[@id="password"]    12345
    Input text    //*[@id="firstName"]    Time
    Input text    //*[@id="lastName"]    Patiphon
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_LEN_4}
    Page Should Contain    ${ERR_LEN_4}

# TC10: Register Password Empty
#     Open Browser    ${WEB_URL}    ${WEB_BROWSER}
#     Maximize Browser Window

#     Wait Until Element Is Visible    //*[@id="accountId"]
#     Input text    //*[@id="accountId"]    1111111111
#     Input text    //*[@id="firstName"]    Time
#     Input text    //*[@id="lastName"]    Patiphon
#     Click Element    //*[@id="root"]/div/div/div/form/button

#     ${input_field} =    Get WebElement    //*[@id="password"]
#     ${is_focus_visible} =    Execute Javascript    return arguments[0].matches(':focus-visible');    ARGUMENTS    ${input_field}
#     Should Be True    ${is_focus_visible}

TC9: Register Full name longer than 30 characters
    Open Browser    ${WEB_URL}    ${WEB_BROWSER}
    Maximize Browser Window

    Wait Until Element Is Visible    //*[@id="accountId"]
    Input text    //*[@id="accountId"]    1111111111
    Input text    //*[@id="password"]    1234
    Input text    //*[@id="firstName"]    ThisIsAReallyLongTextForTestingPurpose
    Input text    //*[@id="lastName"]    ThisIsAReallyLongTextForTestingPurpose
    Click Element    //*[@id="root"]/div/div/div/form/button

    Wait Until Page Contains    ${ERR_LEN_30}
    Page Should Contain    ${ERR_LEN_30}

# TC12: Register First name is empty
#     Open Browser    ${WEB_URL}    ${WEB_BROWSER}
#     Maximize Browser Window

#     Wait Until Element Is Visible    //*[@id="accountId"]
#     Input text    //*[@id="accountId"]    1111111111
#     Input text    //*[@id="password"]    1234
#     Input text    //*[@id="lastName"]    Patiphon
#     Click Element    //*[@id="root"]/div/div/div/form/button
#     ${input_field} =    Get WebElement    //*[@id="firstName"]
#     ${is_focus_visible} =    Execute Javascript    return arguments[0].matches(':focus-visible');    ARGUMENTS    ${input_field}
#     Should Be True    ${is_focus_visible}

# TC13: Register Last name is empty
#     Open Browser    ${WEB_URL}    ${WEB_BROWSER}
#     Maximize Browser Window

#     Wait Until Element Is Visible    //*[@id="accountId"]
#     Input text    //*[@id="accountId"]    1111111111
#     Input text    //*[@id="password"]    1234
#     Input text    //*[@id="firstName"]    Patiphon
#     Click Element    //*[@id="root"]/div/div/div/form/button
#     ${input_field} =    Get WebElement    //*[@id="lastName"]
#     ${is_focus_visible} =    Execute Javascript    return arguments[0].matches(':focus-visible');    ARGUMENTS    ${input_field}
#     Should Be True    ${is_focus_visible}