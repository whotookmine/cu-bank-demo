*** Variables ***

# Register page locators
${REG_ACC}          css:input[cid="r1"]
${REG_PASS}         css:input[cid="r2"]
${REG_FIRST}        css:input[cid="r3"]
${REG_LAST}         css:input[cid="r4"]
${REG_BTN}          css:button[cid="rc"]
${REG_ERR}          css:label[cid="register-error-mes"]

# login page locators
${INPUT_ACCOUNT}   css:input[cid="l1"]
${INPUT_PIN}       css:input[cid="l2"]
${BTN_LOGIN}       css:button[cid="lc"]
${LOGIN_ERR}       css:label[cid="login-error-mes"]

# logout page locators
${BTN_LOGOUT}      xpath=//a[normalize-space(.)='LOG OUT']

# Account Balance
${H1_BALANCE}      xpath=//article//h2[normalize-space(.)='Balance:']/following-sibling::h1[1]

# Deposit section locators
${DEPOSIT_INPUT}   css:input[cid="d1"]
${DEPOSIT_BTN}     css:button[cid="dc"]
${DEPOSIT_ERR}     css:label[cid="deposite-error-mes"]

# Bill Payment locators
${RADIO_WATER}        css:input[name="billTarget"][value="water"]
${RADIO_ELECTRIC}     css:input[name="billTarget"][value="electric"]
${RADIO_PHONE}        css:input[name="billTarget"][value="phone"]
${BILL_AMOUNT}        css:input[cid="b4"]
${BILL_CONFIRM}       css:button[cid="bc"]
${BILL_ERR}           css:label[cid="billpayment-error-mes"]
