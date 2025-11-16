*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers

*** Variables ***
${BASE_URL}       http://localhost:3000
${BROWSER}        Chrome

# Valid Credentials (V1)
${ACCOUNT_ID}     1111111111
${PIN}            1234

# Invalid/Robust Credentials (I1, I2, I3)
${INVALID_ACCOUNT}  9999999999
${INVALID_PIN}      4321
${INVALID_FORMAT}   ABC

# Deposit/Withdraw Amounts
${DEPOSIT_AMOUNT}     1000
${WITHDRAW_SUCCESS}   500
${WITHDRAW_TOO_MUCH}  250000000
${WITHDRAW_ZERO}      0
${WITHDRAW_NEGATIVE}  -100
${WITHDRAW_NON_NUMERIC}  XYZ

${ZERO_ERR}     The amount must be greater than 0. Please enter a positive number.
${NAN_ERR}  Invalid balance amount. Please enter a valid number.
${ERR_NOT_ENOUGH}    Your balance is not enough to complete the withdrawal.

*** Test Cases ***
# =======================================================
# 1. VALID CLASS TEST CASES (V1) - คาดหวัง PASS
# =======================================================

Deposit Successfully (V1)
    [Documentation]    ทดสอบฝากเงิน 1000 บาทหลัง Login (V1)
    Open Application
    Login With Valid Credential
    Deposit Money    ${DEPOSIT_AMOUNT}
    # (เพิ่มการตรวจสอบยอดคงเหลือถ้ามี element id=balance)

Withdraw Fail When Balance Not Enough (I1)
    [Documentation]    ทดสอบถอนเงินเกินยอดคงเหลือ (I1)
    Open Application
    Login With Valid Credential
    Deposit Money    ${DEPOSIT_AMOUNT}
    Withdraw Money Fail    ${WITHDRAW_TOO_MUCH}
    Page Should Contain    ${ERR_NOT_ENOUGH}

Withdraw Fail With Non-Numeric Input (I2 - Robust)
    [Documentation]    ทดสอบถอนเงินด้วยค่าที่ไม่ใช่ตัวเลข (I2)
    Open Application
    Login With Valid Credential
    Withdraw Money Fail    ${WITHDRAW_NON_NUMERIC}
    Page Should Contain    ${NAN_ERR}

Withdraw Fail With Decimal Input (I2 - Robust)
    [Documentation]    ทดสอบถอนเงินด้วยค่า decimal
    Open Application
    Login With Valid Credential
    Withdraw Money Fail    100.25
    Page Should Contain    The balance amount must be a whole number with no decimals

Withdraw Fail With Zero Amount (I3 - Robust)
    [Documentation]    ทดสอบถอนเงินด้วยค่าศูนย์ (I3)
    Open Application
    Login With Valid Credential
    Withdraw Money Fail    ${WITHDRAW_ZERO}
    Page Should Contain    ${ZERO_ERR}

Withdraw Fail With Negative Amount (I3 - Robust)
    [Documentation]    ทดสอบถอนเงินด้วยค่าลบ (I3)
    Open Application
    Login With Valid Credential
    Withdraw Money Fail    ${WITHDRAW_NEGATIVE}
    Page Should Contain    ${ZERO_ERR}

*** Keywords ***
Open Application
    Open Browser    ${BASE_URL}/    ${BROWSER}
    Set Window Size    1280    672

Login With Valid Credential
    Input Text       id=accountId    ${ACCOUNT_ID}
    Input Text       id=password     ${PIN}
    Press Keys       id=password     ENTER
    # รอให้หน้าจอหลักที่มีปุ่ม Deposit/Withdraw ปรากฏขึ้น
    Wait Until Page Contains Element    css:.Card_card__1d4RB:nth-child(3) button    5s
    Sleep    1

Login With Invalid Credential
    [Arguments]      ${account}    ${pin}
    Input Text       id=accountId    ${account}
    Input Text       id=password     ${pin}
    Press Keys       id=password     ENTER
    # รอให้ข้อความ Error ปรากฏ
    Wait Until Page Contains    ${LOGIN_ERROR_MSG}    5s

Deposit Money
    [Arguments]    ${amount}
    Wait Until Element Is Visible    css:.Card_card__1d4RB:nth-child(3) button
    Click Element    css:.Card_card__1d4RB:nth-child(3) button
    Input Text       id=amount    ${amount}
    Click Element    css:.Card_card__1d4RB:nth-child(3) button
    Sleep    1s

Deposit Money Fail
    [Arguments]    ${amount}
    Wait Until Element Is Visible    css:.Card_card__1d4RB:nth-child(3) button
    Click Element    css:.Card_card__1d4RB:nth-child(3) button
    Input Text       id=amount    ${amount}
    Click Element    css:.Card_card__1d4RB:nth-child(3) button
    Sleep    1s

Withdraw Money Success
    [Arguments]    ${amount}
    Wait Until Element Is Visible    css:.Card_card__1d4RB:nth-child(4) button
    Click Element    css:.Card_card__1d4RB:nth-child(4) button
    # ใช้ CSS Selector ที่ระบุ id=amount ในการ์ดที่ 4
    Input Text       css:.Card_card__1d4RB:nth-child(4) #amount    ${amount}
    Click Element    css:.Card_card__1d4RB:nth-child(4) button
    Sleep    2s

Withdraw Money Fail
    [Arguments]    ${amount}
    # แก้ไข StaleElement: รอให้ปุ่มปรากฏก่อน
    Wait Until Element Is Visible    css:.Card_card__1d4RB:nth-child(4) button    5s
    Click Element    css:.Card_card__1d4RB:nth-child(4) button
    # ใช้ CSS Selector ที่ระบุ id=amount ในการ์ดที่ 4
    Input Text       css:.Card_card__1d4RB:nth-child(4) #amount    ${amount}
    Click Element    css:.Card_card__1d4RB:nth-child(4) button
    Sleep    1s