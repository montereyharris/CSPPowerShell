﻿$authorityname = 'mageniumcspsandbox.onmicrosoft.com'
Get-ADALAccessResultContext -AuthorityName mageniumcspsandbox.onmicrosoft.com -credential $credential -ClientId d4a70d61-4862-4e65-a09e-b763d1898327 -ResourceId 'https://api.partnercenter.microsoft.com'
$headers = @{"Authorization" = ($token.CreateAuthorizationHeader())}
$headers += @{"Accept" = 'application\json'}
$headers+=@{"MS-RequestId" = $requestid} 
$headers+=@{"MS-CorrelationId" = (New-guid)} 
$output = Invoke-RestMethod -Method Get -Uri 'https://api.partnercenter.microsoft.com/v1/customers?size=40' -Headers $headers

