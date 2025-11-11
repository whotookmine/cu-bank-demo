*** Settings ***
Library    SeleniumLibrary
Library    String
Suite Teardown    Close All Browsers
Test Teardown     Capture Page Screenshot

*** Variables ***
${BASE_URL}                http://localhost:3000
${LOGIN_PATH}              /
${ACCOUNT_PATH}            /account/
${BROWSER}                 chrome
${EXPLICIT_WAIT}           10s

# Accounts
${SRC_ACCOUNT}             1111111111
${SRC_PASSWORD}            1234
${DST_ACCOUNT}             1910000000
${DST_PASSWORD}            1234
${XFER_AMOUNT}             100

# Locators
${ACC_INPUT}               //*[@cid='l1']
${PWD_INPUT}               //*[@cid='l2']
${LOGIN_BTN}               //*[@cid='lc']
${LOGIN_ERROR_LABEL}       //*[@cid='login-error-mes']
${BALANCE_LABEL}           //*[contains(text(),'Balance')]/following::*[1]
${RECEIVER_INPUT}          //*[@cid='t1']
${TRANSFER_AMOUNT_INPUT}   //*[@cid='t2']
${TRANSFER_CONFIRM_BTN}    //*[@cid='tc']
${TRANSFER_ERROR_LABEL}    //*[@cid='transfer-error-mes']

${SRC_LATEST_XFER_CARD}      xpath=(//*[normalize-space(text())='transfer to'])[last()]/ancestor::div[1]
${DST_LATEST_XFER_CARD}      xpath=(//*[normalize-space(text())='transfer from'])[last()]/ancestor::div[1]

*** Test Cases ***
TC8-01 End-to-End Transfer Between Two Accounts (Cross-Verification)
    # 1) เก็บยอดก่อนโอน (ผู้รับ)
    ${dst_before}=    Get Balance Fresh Login    ${DST_ACCOUNT}    ${DST_PASSWORD}    
    
    # 2) ล็อกอินเป็นผู้โอน เก็บยอดก่อนโอน
    Open Browser To Login
    Attempt Login And Expect Success    ${SRC_ACCOUNT}    ${SRC_PASSWORD}
    ${src_before}=    Read Current Balance
    
    # 3) โอนเงิน และยืนยันว่าไม่มี error label โผล่
    Perform Transfer    ${DST_ACCOUNT}    ${XFER_AMOUNT}
    Page Should Not Contain Element    ${TRANSFER_ERROR_LABEL}    

    # 4) ตรวจยอดผู้โอนลดลงตามจำนวน
    ${src_after}=    Wait And Read Current Balance
    ${expect_src}=   Evaluate    ${src_before} - ${XFER_AMOUNT}
    Should Be Equal As Integers    ${src_after}    ${expect_src}

    Log To Console    \n${src_before}
    Display Latest Transfer To    # << เพิ่มบรรทัดนี้

    # 5) ล็อกอินเป็นผู้รับอีกครั้ง ตรวจยอดเพิ่มขึ้นตามจำนวน
    Close All Browsers
    ${dst_after}=    Get Balance Fresh Login    ${DST_ACCOUNT}    ${DST_PASSWORD}
    ${expect_dst}=   Evaluate    ${dst_before} + ${XFER_AMOUNT}
    Should Be Equal As Integers    ${dst_after}    ${expect_dst}

    Log To Console    \n${dst_before}
    Display Latest Transfer From    # << เพิ่มบรรทัดนี้

    Assert Latest Transfer Pair Consistency    ${src_after}    ${dst_after}
   
*** Keywords ***
Open Browser To Login
    ${url}=    Set Variable    ${BASE_URL}${LOGIN_PATH}
    Open Browser    ${url}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    ${ACC_INPUT}    ${EXPLICIT_WAIT}

Attempt Login And Expect Success
    [Arguments]    ${account}    ${password}
    Clear Element Text    ${ACC_INPUT}
    Input Text    ${ACC_INPUT}    ${account}
    Clear Element Text    ${PWD_INPUT}
    Input Text    ${PWD_INPUT}    ${password}
    Click Element    ${LOGIN_BTN}
    Wait Until Location Contains    ${ACCOUNT_PATH}    ${EXPLICIT_WAIT}
    Page Should Not Contain Element    ${LOGIN_ERROR_LABEL}
    Sleep    0.5s

Read Current Balance
    Wait Until Element Is Visible    ${BALANCE_LABEL}    ${EXPLICIT_WAIT}
    ${txt}=    Get Text    ${BALANCE_LABEL}
    ${num}=    To Integer From Text    ${txt}
    RETURN    ${num}

Wait And Read Current Balance
    # เผื่อ backend อัปเดตช้า เรา poll จนยอดนิ่ง
    Wait Until Keyword Succeeds    5x    1s    Read Current Balance
    ${v}=    Read Current Balance
    RETURN    ${v}

Get Balance Fresh Login
    [Arguments]    ${account}    ${password}
    Open Browser To Login
    Attempt Login And Expect Success    ${account}    ${password}
    ${bal}=    Read Current Balance
    RETURN    ${bal}

Perform Transfer
    [Arguments]    ${receiver}    ${amount}
    Wait Until Element Is Visible    ${RECEIVER_INPUT}    ${EXPLICIT_WAIT}
    Clear Element Text    ${RECEIVER_INPUT}
    Input Text    ${RECEIVER_INPUT}    ${receiver}
    Clear Element Text    ${TRANSFER_AMOUNT_INPUT}
    Input Text    ${TRANSFER_AMOUNT_INPUT}    ${amount}
    Click Element    ${TRANSFER_CONFIRM_BTN}
    Sleep    0.5s

To Integer From Text
    [Arguments]    ${text}
    # ตัดอักขระที่ไม่ใช่ตัวเลข (รองรับเครื่องหมายลบกรณีมี)
    ${clean}=    Replace String Using Regexp    ${text}    [^0-9\-]    ${EMPTY}
    ${num}=      Convert To Integer    ${clean}
    RETURN       ${num}

Display Latest Transfer To
    # รอให้การ์ด "transfer to" ล่าสุด ปรากฏใน DOM ก่อน
    Wait Until Page Contains Element    ${SRC_LATEST_XFER_CARD}    ${EXPLICIT_WAIT}
    ${src_date_line}=      Get Text    ${SRC_LATEST_XFER_CARD}//*[contains(normalize-space(.),'date:')][1]
    ${src_target_line}=    Get Text    ${SRC_LATEST_XFER_CARD}//*[contains(normalize-space(.),'target:')][1]
    ${src_amount_line}=    Get Text    ${SRC_LATEST_XFER_CARD}//*[contains(normalize-space(.),'amount:')][1]
    ${src_balance_line}=   Get Text    ${SRC_LATEST_XFER_CARD}//*[contains(normalize-space(.),'balance:')][1]

    # แยกค่าใช้งานจริง
    ${SRC_DATE}=       Get Text After Label    ${src_date_line}    date:
    ${SRC_TARGET}=     To Integer From Labeled Line    ${src_target_line}
    ${SRC_AMOUNT}=     To Integer From Labeled Line    ${src_amount_line}
    ${SRC_BALANCE}=    To Integer From Labeled Line    ${src_balance_line}

    # เผยแพร่เป็น Test variables
    Set Test Variable    ${SRC_DATE}
    Set Test Variable    ${SRC_TARGET}
    Set Test Variable    ${SRC_AMOUNT}
    Set Test Variable    ${SRC_BALANCE}

    Log To Console    \n=== LATEST TRANSFER TO ===
    Log To Console    ${src_date_line}
    Log To Console    ${src_target_line}
    Log To Console    ${src_amount_line}
    Log To Console    ${src_balance_line}

Display Latest Transfer From
    # รอให้การ์ด "transfer from" ล่าสุด ปรากฏก่อน
    Wait Until Page Contains Element    ${DST_LATEST_XFER_CARD}    ${EXPLICIT_WAIT}
    ${dst_date_line}=      Get Text    ${DST_LATEST_XFER_CARD}//*[contains(normalize-space(.),'date:')][1]
    ${dst_target_line}=    Get Text    ${DST_LATEST_XFER_CARD}//*[contains(normalize-space(.),'target:')][1]
    ${dst_amount_line}=    Get Text    ${DST_LATEST_XFER_CARD}//*[contains(normalize-space(.),'amount:')][1]
    ${dst_balance_line}=   Get Text    ${DST_LATEST_XFER_CARD}//*[contains(normalize-space(.),'balance:')][1]

    ${DST_DATE}=       Get Text After Label    ${dst_date_line}    date:
    ${DST_TARGET}=     To Integer From Labeled Line    ${dst_target_line}
    ${DST_AMOUNT}=     To Integer From Labeled Line    ${dst_amount_line}
    ${DST_BALANCE}=    To Integer From Labeled Line    ${dst_balance_line}

    Set Test Variable    ${DST_DATE}
    Set Test Variable    ${DST_TARGET}
    Set Test Variable    ${DST_AMOUNT}
    Set Test Variable    ${DST_BALANCE}

    Log To Console    \n=== LATEST TRANSFER FROM ===
    Log To Console    ${dst_date_line}
    Log To Console    ${dst_target_line}
    Log To Console    ${dst_amount_line}
    Log To Console    ${dst_balance_line}

Get Text After Label
    [Arguments]    ${line}    ${label}
    ${val}=    Replace String    ${line}    ${label}    ${EMPTY}
    ${val}=    Strip String    ${val}
    RETURN    ${val}

To Integer From Labeled Line
    [Arguments]    ${line}
    ${num}=    To Integer From Text    ${line}
    RETURN    ${num}

Assert Latest Transfer Pair Consistency
    [Arguments]    ${src_after}    ${dst_after}
    # แปลงเลขบัญชีเป็น int ไว้เทียบแบบตัวเลข
    ${DST_ACC_INT}=    Convert To Integer    ${DST_ACCOUNT}
    ${SRC_ACC_INT}=    Convert To Integer    ${SRC_ACCOUNT}

    # 1) target (ฝั่งผู้โอน) = เลขบัญชีผู้รับ
    Should Be Equal As Integers    ${SRC_TARGET}    ${DST_ACC_INT}

    # 2) amount (ฝั่งผู้โอน) = จำนวนที่โอน
    Should Be Equal As Integers    ${SRC_AMOUNT}    ${XFER_AMOUNT}

    # 3) balance (ฝั่งผู้โอน) = ยอดหลังโอนของผู้โอน
    Should Be Equal As Integers    ${SRC_BALANCE}   ${src_after}

    # 4) date ตรงกันทั้งสองฝั่ง (กัน flake ด้วยการเทียบเฉพาะนาที/ชั่วโมง หรือ prefix เดียวกัน)
    # ถ้า date แสดงแบบ "YYYY-MM-DD HH:MM:SS", ตัดวินาทีทิ้งก่อนเทียบ
    ${SRC_DATE_MM}=    Replace String Using Regexp    ${SRC_DATE}    :\d{2}$    ${EMPTY}
    ${DST_DATE_MM}=    Replace String Using Regexp    ${DST_DATE}    :\d{2}$    ${EMPTY}
    Should Be Equal As Strings     ${DST_DATE_MM}    ${SRC_DATE_MM}

    # 5) target (ฝั่งผู้รับ) = เลขบัญชีผู้โอน
    Should Be Equal As Integers    ${DST_TARGET}    ${SRC_ACC_INT}

    # 6) amount (ฝั่งผู้รับ) = amount ฝั่งผู้โอน
    Should Be Equal As Integers    ${DST_AMOUNT}    ${SRC_AMOUNT}

    # 7) balance (ฝั่งผู้รับ) = ยอดหลังรับโอน
    Should Be Equal As Integers    ${DST_BALANCE}   ${dst_after}
