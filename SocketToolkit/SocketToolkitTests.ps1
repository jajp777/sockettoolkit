#Set-ExecutionPolicy -ExecutionPolicy remotesigned -Scope process
Import-Module -Name NUnit -Force
Import-Module -Name PsTest

Copy-Item -Path SoketToolkit.psm1 -Destination SoketToolkit.ps1

.\SoketToolkit.ps1

(New-Test 'New-Socket: blocking socket when $NoneBlocking switched off' {

    # Arrange.
    $expectedSocket = 'socket'
    $expectedAddressFamily = [Net.Sockets.AddressFamily]::InterNetwork
    $expectedSocketType = [Net.Sockets.SocketType]::Stream
    $expectedProtocolType = [Net.Sockets.ProtocolType]::Tcp
    
    # Mock New-Object cmdlet.
    function New-Object ($TypeName, $ArgumentList, $Property) {
    
        # Make sure that a socket is supposed to be created.
        $Assert::That($TypeName, $Is::EqualTo('Net.Sockets.Socket'))
        
        # Make sure that socket constructor arguments are correct.
        $Assert::That($ArgumentList[0], $Is::EqualTo($expectedAddressFamily))
        $Assert::That($ArgumentList[1], $Is::EqualTo($expectedSocketType))
        $Assert::That($ArgumentList[2], $Is::EqualTo($expectedProtocolType))
                
        # Make sure that blocking property is set correctly.
        $Assert::True($Property.Blocking)
        
        # Return expected socket.
        $expectedSocket
    }
    
    # Act.
    $actualSocket = New-Socket

    # Assert.
    $Assert::That($actualSocket, $Is::EqualTo($expectedSocket))

}),

(New-Test 'New-Socket: none blocking socket when $NoneBlocking switched on' {

    # Arrange.
    $expectedSocket = 'socket'
    
    # Mock New-Object cmdlet.
    function New-Object ($TypeName, $ArgumentList, $Property) {
                
        # Make sure that blocking property is set correctly.
        $Assert::False($Property.Blocking)
        
        # Return expected socket.
        $expectedSocket
    }
    
    # Act.
    $actualSocket = New-Socket -NoneBlocking

    # Assert.
    $Assert::That($actualSocket, $Is::EqualTo($expectedSocket))

}) |

# Invoke tests.
Invoke-Test |

# Format test results.
Format-TestResult