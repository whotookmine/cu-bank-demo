*** Settings ***
Documentation   Register user for billing test flows
Library         SeleniumLibrary
Resource        ../resources/keywords.robot
Suite Setup     Open Browser To Register    
Suite Teardown  Close Browser

*** Test Cases ***
Register Fixed User Successfully
    [Documentation]    Register a fixed user with
    Fill Register Form    1910000000    1234    Danuwat    Maoleethong
    Submit Register
    Expect Register Success