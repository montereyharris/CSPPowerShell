Function Get-ADALAccessResultContext
{

<#
 .SYNOPSIS
 Acquires OAuth 2.0 ADALAccessResultContext from Azure Active Directory (AAD)

 .DESCRIPTION
 The Get-ADALAccessResultContext cmdlet lets you acquire OAuth 2.0 AccessTokeADALAccessResultContext  from Azure Active Directory (AAD) 
 by using Active Directory Authentication Library (ADAL).

 There are two ways to get AccessToken
 
 1. You can pass UserName and Password to avoid SignIn Prompt.
 2. You can pass RedirectUri to use SignIn prompt.

 If you want to use different credential by using SignIn Prompt, use ForcePromptSignIn.
 Use Get-Help Get-AccessToken -Examples for more detail.

 .PARAMETER AuthorityName
 Azure Active Directory Name or Guid. i.e.)contoso.onmicrosoft.com

 .PARAMETER ClientId
 A registerered ClientId as application to the Azure Active Directory.

 .PARAMETER ResourceId
 A Id of service (resource) to consume.

 .PARAMETER UserName
 A username to login to Azure Active Directory.

 .PARAMETER Password
 A password for UserName

 .PARAMETER RedirectUri
 A registered RedirectUri as application to the Azure Active Directory.

 .PARAMETER ForcePromptSignIn
 Indicate to force prompting for signin in.

 .EXAMPLE
 Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com -ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d -ResourceId https://analysis.windows.net/powerbi/api -RedirectUri $redirectUri

 This example acquire accesstoken by using RedirectUri from contoso.onmicrosoft.com Azure Active Directory for PowerBI service. 
 It will only prompt you to sign in for the first time, or when cache is expired.

 .EXAMPLE
 Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com -ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d -ResourceId https://analysis.windows.net/powerbi/api -RedirectUri $redirectUri -ForcePromptSignIn

 This example acquire accesstoken by using RedirectUri from contoso.onmicrosoft.com Azure Active Directory for PowerBI service.
 It always prompt you to sign in.

  .EXAMPLE
 Get-ADALAccessToken -AuthorityName contoso.onmicrosoft.com -ClientId 8f710b23-d3ea-4dd3-8a0e-c5958a6bc16d -ResourceId https://analysis.windows.net/powerbi/api -UserName user1@contoso.onmicrosoft.com -Password password

 This example acquire accesstoken by using UserName/Password from contoso.onmicrosoft.com Azure Active Directory for PowerBI service. 

#>
    param
    (
        [parameter(Mandatory=$true)]
        [string]$AuthorityName,
        [parameter(Mandatory=$true)]
        [string]$ClientId,
        [parameter(Mandatory=$true)]
        [string]$ResourceId,
        [parameter(Mandatory=$true, ParameterSetName="credential")]
        [pscredential]
        [System.Management.Automation.Credential()] $credential,
        [parameter(Mandatory=$true, ParameterSetName="RedirectUri")]
        [string]$RedirectUri,
        [parameter(Mandatory=$false, ParameterSetName="RedirectUri")]
        [switch]$ForcePromptSignIn
    )    
    
    # Authority Format
    $authority = "https://login.windows.net/{0}/" -F $AuthorityName;
    # Create AuthenticationContext
    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext($authority)
    
    try
    {
        if($RedirectUri -ne '')
        {
            # Create RedirectUri
            $rUri = New-Object System.Uri -ArgumentList $RedirectUri
            # Set PromptBehavior
            if($ForcePromptSignIn)
            {
                $promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Always
            }
            else
            {
                $promptBehavior = [Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto
            }
            # Get AccessToken
            $authResult = $authContext.AcquireToken($ResourceId, $ClientId, $rUri,$promptBehavior)
        }
        else
        {
            # Create Credential
            $cred = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential($credential.UserName, $credential.Password)
            # Get AccessToken
            $authResult = $authContext.AcquireToken($ResourceId, $ClientId, $cred)
        }
    }
    catch [Microsoft.IdentityModel.Clients.ActiveDirectory.AdalException]
    {
        Write-Error $_
    }
    return $authResult
}


Function Get-CSPCustomer {
Param(

[Parameter(Mandatory = $true,ValuefromPipeline = $false)]
[ Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationResult]$AccessToken,
[Parameter(Mandatory = $true,ValuefromPipeline = $false)]
$ResultSize = 40


)


Begin
    {
        
        
        $headers =@{"Authorization" = ($AccessToken.CreateAuthorizationHeader())}
        $headers += @{"Accept" = 'application\json'}
        $headers+=@{"MS-RequestId" = $requestid} 
        $headers+=@{"MS-CorrelationId" = (New-guid)}

        $RawCustomers = $output = Invoke-RestMethod -Method Get -Uri "https://api.partnercenter.microsoft.com/v1/customers?size=$ResultSize" -Headers $headers
        
        }


}