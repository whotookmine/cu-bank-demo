*** Settings ***
Library    Browser

*** Variables ***
${BASE_URL}          http://localhost:3000
${ACCOUNT_NUMBER}    111111111
${PASSWORD}          1234
${BILL_AMOUNT}       100

*** Test Cases ***
Login And Bill Payment Success
    [Documentation]    ทดสอบ Flow เต็ม: Login และ Bill Payment (สำเร็จ)
    New Browser    chromium    headless=False    slowMo=4
    ${page}=    New Page       ${BASE_URL}
    Sleep    1s

    #LOGIN
    Sleep    1s
    Wait For Elements State    id=accountId    visible    timeout=5s
    Fill Text                  id=accountId    ${ACCOUNT_NUMBER}
    Fill Text                  id=password     ${PASSWORD}
    Click                      role=button[name="Login"]
    Wait For Elements State    text="Account"    visible    timeout=5s
    Sleep    1s

    #BILL PAYMENT
    Wait For Elements State    xpath=//h2[normalize-space(.)="Bill Payment"]    visible    timeout=5s
    Scroll To Element          xpath=//h2[normalize-space(.)="Bill Payment"]
    Sleep    1s

    #เลือก Electric Charge (รอ element ก่อน)
    Wait For Elements State    xpath=(//input[@name="billTarget" and @value="electric"])[1]    visible    timeout=5s
    Click                      xpath=(//input[@name="billTarget" and @value="electric"])[1]
    Sleep    1s

    #กรอกจำนวนเงิน
    Wait For Elements State    xpath=(//input[@id="amount"])[1]    visible    timeout=5s
    Sleep    1s
    Fill Text                  xpath=(//input[@cid="b4"])[1]    ${BILL_AMOUNT}
    Sleep    1s

    #กดปุ่ม Confirm
    Wait For Elements State    xpath=(//button[@cid="bc"])[1]    visible    timeout=5s
    Click                      xpath=(//button[@cid="bc"])[1]
    sleep    1s

    Sleep    1s
    Take Screenshot

    Close Browser
