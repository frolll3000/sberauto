*** Settings ***
Documentation     Test task from Sberauto
Library           SeleniumLibrary
Library           Collections
Library           /src/keywords.py
Test Teardown    Close Browser

*** Variables ***
${URL}      	  https://sberauto.com/cars/
${BROWSER}        Chrome
${UUID}           b23b4749

*** Test Cases ***
Sberauto
    Open Chrome
   	Find Foto
	Check Vin


*** Keywords ***

Open Chrome
	Open Browser    ${URL}${UUID}     ${BROWSER}

Check Vin
    Wait Until Element Is Visible    //*[@class="MuiGrid-root MuiGrid-item MuiGrid-grid-xs-7 MuiGrid-grid-lg-10"]
    ${elements}=    Get WebElements    //*[@class="MuiGrid-root MuiGrid-item MuiGrid-grid-xs-7 MuiGrid-grid-lg-10"]
    ${texts}=    Create List
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        Append To List    ${texts}    ${text}
    END

    ${vin}    Keywords.Find Vin   ${texts}
    Log    ${vin}

Find Foto
    ${count_foto}=    Get Element Count    xpath=//*[@class="MuiGrid-root MuiGrid-item MuiGrid-grid-xs-12 MuiGrid-grid-lg-12"]//img[contains(@src, "https://images.sberauto.com/1200x900/")]
    Should Be True	${count_foto} > 6


