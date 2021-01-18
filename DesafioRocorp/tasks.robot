*** Settings ***
Documentation   Desafio Robocorp
Library         RPA.Browser
Library         RPA.Excel.Files
Library         RPA.HTTP 


*** Variables ***

${URL}        http://rpachallenge.com/
${ARQUIVO}    challenge.xlsx

*** Keywords ***
Pegando lista de pessoas do arquivo Excel
    Open Workbook            ${ARQUIVO}    #Abre o excel 
    ${table}=                Read Worksheet As Table           header=True            #Lê o arquivo excel considerando o cabeçalho e guarda numa variavel 
    Close Workbook                
    [Return]                 ${table}                 #Retorna a variável 

*** Keywords***
Preencher o formulario                #Keyword responsável por percorrer a tabela que foi extraida e preencher o formulário do site 
    [Arguments]    ${person}
    Input Text    css:input[ng-reflect-name="labelFirstName"]  ${person}[First Name]
    Input Text    css:input[ng-reflect-name="labelLastName"]  ${person}[Last Name]
    Input Text    css:input[ng-reflect-name="labelCompanyName"]  ${person}[Company Name]
    Input Text    css:input[ng-reflect-name="labelRole"]  ${person}[Role in Company]
    Input Text    css:input[ng-reflect-name="labelAddress"]  ${person}[Address]
    Input Text    css:input[ng-reflect-name="labelEmail"]  ${person}[Email]
    Input Text    css:input[ng-reflect-name="labelPhone"]  ${person}[Phone Number]
    Click Button    Submit


*** Tasks ***
Abrir o navegador e download do arquivo
    Open Available Browser          ${URL}            #RPA.Browser
    Title Should Be                 Rpa Challenge
    Download                        http://rpachallenge.com/assets/downloadFiles/challenge.xlsx    overwrite=True        #RPA.HTTP
    Click Button                    Start 

Preenchimento Formulario
    ${people}=    Pegando lista de pessoas do arquivo Excel   #será uma lista com os dados da tabela 
    FOR  ${person}  IN  @{people}               #percorre a lista 
      Preencher o formulario  ${person}
    END

Coleta dos resultados
    Capture Element Screenshot    css:div.congratulations
    [Teardown]  Close All Browsers
