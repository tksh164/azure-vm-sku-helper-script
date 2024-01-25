
#Requires -Modules @{ ModuleName = 'Az.Compute'; ModuleVersion = '7.1.1' }

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string] $Location
)

$params = @{}
if ($PSBoundParameters.ContainsKey('Location')) {
    $params.Location = $Location
}
Get-AzComputeResourceSku @params |
    Where-Object -Property 'ResourceType' -EQ -Value 'virtualMachines' |
    ForEach-Object -Process {
        $sku = $_
        $vmSizeInfo = [PSCustomObject] @{
            VMSizeName = $sku.Name
            Location = $sku.LocationInfo.Location
            Zones = $sku.LocationInfo.Zones -join ','
            ACUs = $null

            # Processor
            vCPUs = $null
            vCPUsAvailable = $null
            vCPUsPerCore = $null
            CpuArchitectureType = $null

            # Memory
            MemoryGB = $null

            # Storage
            MaxDataDiskCount = $null
            PremiumIO = $null
            UncachedDiskIOPS = $null
            UncachedDiskBytesPerSecond = $null
            CachedDiskBytes = $null
            CombinedTempDiskAndCachedIOPS = $null
            CombinedTempDiskAndCachedReadBytesPerSecond = $null
            CombinedTempDiskAndCachedWriteBytesPerSecond = $null
            OSVhdSizeMB = $null
            MaxResourceVolumeMB = $null
            EphemeralOSDiskSupported = $null
            MaxWriteAcceleratorDisksAllowed = $null
            UltraSSDAvailable = $null
            DiskControllerTypes = $null
            NvmeDiskSizeInMiB = $null
            NvmeSizePerDiskInMiB = $null

            # Network
            MaxNetworkInterfaces = $null
            AcceleratedNetworkingEnabled = $null
            RdmaEnabled = $null

            # GPU
            GPUs = $null

            # Security
            EncryptionAtHostSupported = $null
            TrustedLaunchDisabled = $null
            ConfidentialComputingType = $null

            # Others
            ParentSize = $null
            HyperVGenerations = $null
            MemoryPreservingMaintenanceSupported = $null
            CapacityReservationSupported = $null
            LowPriorityCapable = $null
            HibernationSupported = $null
            VMDeploymentTypes = $null
            RetirementDateUtc = $null
        }

        $sku.Capabilities | ForEach-Object -Process {
            $capability = $_
            $vmSizeInfo.$($capability.Name) = $capability.Value
        }

        return $vmSizeInfo
    }
