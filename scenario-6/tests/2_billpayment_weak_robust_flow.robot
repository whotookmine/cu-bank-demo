*** Settings ***
Documentation   BillPayment weak-robust flow with precondition balance = 1000
Library         SeleniumLibrary
Resource        ../resources/keywords.robot    
Suite Setup     Open Browser And Login
Suite Teardown  Logout And Close

*** Test Cases ***
BillPayment Weak-Robust Scenario
    [Documentation] 

    # 1) Ensure precondition: balance = 1000
    ${before}=    Get Balance
    Run Keyword If    ${before} < 1000    Deposit Money    ${1000 - ${before}}
    Ensure Balance Equals    1000
    Refresh Page Before Test


    # 2) bill = Phone, amount = 0 -> expect error + balance = 1000
    Pay Bill    phone    0
    Expect Bill Error Contains    The amount must be greater than 0. Please enter a positive number
    Ensure Balance Equals         1000
    Refresh Page Before Test


    # 3) bill = Water, amount = 1001 -> expect error + balance = 1000
    Pay Bill    water    1001
    Expect Bill Error Contains    Your balance is not enough to complete the bill payment.
    Ensure Balance Equals         1000
    Refresh Page Before Test


    # 4) bill = Electric, amount = 0.5 -> expect form invalid + balance = 1000
    Pay Bill    electric    0.5
    Expect Amount Field Invalid    css:input[cid="b4"]
    Ensure Balance Equals          1000
    Refresh Page Before Test


    # 5) bill = None, amount = 100 -> expect form invalid + balance = 1000
    Pay Bill    none    100
    Expect Bill Form Invalid
    Ensure Balance Equals         1000

    # 6) bill = Water, amount = 1 -> expect success + balance = 999
    Pay Bill    water    1
    Page Should Not Contain Element    ${BILL_ERR}
    Ensure Balance Equals         999

    # 7) topup 1 -> expect balance = 1000 (make sure baseline is 1000฿)
    Deposit Money    1
    Ensure Balance Equals         1000
    Refresh Page Before Test

    # 8) bill = Electric, amount = 1000 -> expect success + balance = 0
    Pay Bill    electric    1000
    Page Should Not Contain Element    ${BILL_ERR}
    Ensure Balance Equals         0
    Refresh Page Before Test


    # 9) deposit 1000 -> expect balance = 1000 (make sure baseline is 1000฿)
    Deposit Money    1000
    Ensure Balance Equals         1000
    Refresh Page Before Test


    # 10) bill = Water, amount = 1000 -> expect success + balance = 0
    Pay Bill    water    1000
    Page Should Not Contain Element    ${BILL_ERR}
    Ensure Balance Equals         0

