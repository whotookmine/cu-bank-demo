*** Settings ***
Documentation   Deposit until balance becomes 1000, then assert it equals 1000
Library         SeleniumLibrary
Resource        ../resources/keywords.robot
Suite Setup     Open Browser And Login
Suite Teardown  Logout And Close

*** Test Cases ***
Deposit 1000 And Expect Balance 1000
    ${before}=    Get Balance
    Run Keyword If    ${before} < 1000    Deposit Money    ${1000 - ${before}}
    Ensure Balance Equals    1000
