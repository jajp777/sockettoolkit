function New-Socket {
    
    #
    # .SYNOPSIS
    # Creates a new socket.
    #
    
    [CmdletBinding()]
    param (
    
        #
        # The address to connect to.
        #
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string] $Address,
    
        #
        # The port to connect to.
        #
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [int] $Port
    )
    
    process {
        Write-Verbose -Message "Resolving address $Address..."
        $hostEntry = [Net.Dns]::Resolve($Address)
        $ipAddress = $hostEntry.AddressList[0]
        Write-Verbose -Message "Address resolved to IP $ipAddress."
        $addressFamily = [Net.Sockets.AddressFamily]::InterNetwork
        $socketType = [Net.Sockets.SocketType]::Stream
        $protocolType = [Net.Sockets.ProtocolType]::Tcp
        $socket = New-Object `
            -TypeName Net.Sockets.Socket `
            -ArgumentList $addressFamily, $socketType, $protocolType
        $endPoint = New-Object `
            -TypeName Net.IPEndPoint `
            -ArgumentList $ipAddress, $Port
        Write-Verbose -Message 'Socket connecting...'
        $socket.Connect($endPoint)
        Write-Verbose -Message 'Socket connected.'
        $socket
    }
}