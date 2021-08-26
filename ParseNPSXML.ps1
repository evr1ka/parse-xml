#Ver_0.1 Emil Romanov
$Path = "C:\Temp"
$ListXMLs = Get-ChildItem -Path "$Path\*.xml" -Recurse -File -Force -ErrorAction SilentlyContinue | Select-Object FullName
Clear-Host
$NPSs = @()
foreach($PathXml in $ListXMLs){
    $FileXmlName =($PathXml.FullName -split('\\'))[-1].TrimEnd(".xml")
    $PathNodesXML = "$Path\Nodes.csv"
    $Xml = [Xml](Get-Content -Path  $($PathXml.FullName) -RAW)    
    $XPath = "//Clients//Children"
    $NodesXML = Select-Xml -Path $($PathXml.FullName) -XPath $Xpath | Select-Object -ExpandProperty Node
    $NodesXML | Export-Csv $PathNodesXML -Delimiter ";" -NoTypeInformation
    $Nodes = (Get-Content $PathNodesXML)[0]  -split(";") -replace ('"','')
    $XPath = "//Clients"
    foreach($Node in $Nodes){      
        $NPS = [pscustomobject]@{
            ServerNPS = $FileXmlName
            Name = $Node
            Client_Secret_Template_Guid = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Client_Secret_Template_Guid."#text"
            IP_Address = $($xml.SelectNodes("$XPath/node()")).$Node.properties.IP_Address."#text"
            NAS_Manufacturer = $($xml.SelectNodes("$XPath/node()")).$Node.properties.NAS_Manufacturer."#text"
            Opaque_Data  = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Opaque_Data."#text"
            Quarantine_Compatible = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Quarantine_Compatible."#text"
            Radius_Client_Enabled  = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Radius_Client_Enabled."#text"
            Require_Signature = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Require_Signature."#text"
            Shared_Secret = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Shared_Secret."#text"
            Template_Guid = $($xml.SelectNodes("$XPath/node()")).$Node.properties.Template_Guid."#text"        
        }
        $NPSs += $NPS        
    }    
}
$NPSs | Export-Csv "$Path\AllNPS.csv" -Delimiter ";" -NoTypeInformation