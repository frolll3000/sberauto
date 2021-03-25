*** Settings ***
Documentation     Test task from Sberauto
Library           SeleniumLibrary
Library           Collections
Library           RequestsLibrary
Library           String
Test Teardown     Close Browser

*** Variables ***
${URL}      	  https://sberauto.com/cars/
${BROWSER}        Chrome
${API_URL}        https://api.sberauto.com

*** Test Cases ***
Sberauto
    Get Uuid
    Open Chrome
    Check Foto
    Check Vin

*** Keywords ***

Get Uuid
    Create Session  get_uuid  ${API_URL}
    ${header}      Create Dictionary    Content-Type=application/json
    ${response}    POST On Session      get_uuid   /searcher/getCars   headers=${header}
    ${cars_info}   Evaluate             json.loads('''${response.content}''')    json
    Set Test Variable    ${cars_info}

    ${count_api_imgs}    Get length    ${cars_info['data']['results'][0]['images']}
    Set Test Variable    ${count_api_imgs}

Open Chrome
    Open Browser    ${URL}${cars_info['data']['results'][0]['uuid']}     ${BROWSER}

Check Foto
    Wait Until Element Is Visible    //*[@class="MuiGrid-root MuiGrid-item MuiGrid-grid-xs-12 MuiGrid-grid-lg-12"]
    ${count_web_imgs}=    Get Element Count    xpath=//*[contains(@class, "MuiGrid-grid-lg-12")]//img[contains(@src, "1200x900")]
    Should Be True	${count_web_imgs} == ${count_api_imgs}
    Should Be True	${count_web_imgs} > 0

    ${count_web_atrrs}=    Get WebElements        xpath=//*[contains(@class, "MuiGrid-grid-lg-12")]//img[contains(@src, "1200x900")]
    ${attrs}=    Create List
    FOR    ${element_atrr}    IN    @{count_web_atrrs}
        ${attr}=    Get Element Attribute    ${element_atrr}    src
        Append To List    ${attrs}    ${attr}
    END

    ${count}    Set Variable If    ${count_web_imgs} >= 6    5
    ...                            ${count_web_imgs} < 6     ${count_web_imgs}

    FOR    ${i}    IN RANGE    0    ${count} + 1
        Should Contain    ${cars_info['data']['results'][0]['images'][${i}]['urls']['url_original']}    ${attrs[${i}]}
    END

Check Vin
    ${all_text}    Get Text    //*[contains(@class, "MuiGrid-spacing-xs-2") and contains(@class, "jss")]
    ${vin}    Get Regexp Matches    ${all_text}    \\w\\w\\w\\w\\*{13}
    Should Be True	  ${vin}
