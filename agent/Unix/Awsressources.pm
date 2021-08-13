# Plugin "Aws Ressources" OCSInventory
# Author: Léa DROGUET

package Ocsinventory::Agent::Modules::Awsressources;

use Encode qw(decode);
use POSIX qw(strftime);
use JSON::PP;


sub new {

    my $name="awsressources"; # Name of the module

    my (undef,$context) = @_;
    my $self = {};

    #Create a special logger for the module
    $self->{logger} = new Ocsinventory::Logger ({
        config => $context->{config}
    });
    $self->{logger}->{header}="[$name]";
    $self->{context}=$context;
    $self->{structure}= {
        name => $name,
        start_handler => undef,    #or undef if don't use this hook
        prolog_writer => undef,    #or undef if don't use this hook
        prolog_reader => undef,    #or undef if don't use this hook
        inventory_handler => $name."_inventory_handler",    #or undef if don't use this hook
        end_handler => undef       #or undef if don't use this hook
    };
    bless $self;
}

######### Hook methods ############
sub awsressources_inventory_handler {

    my $self = shift;
    my $logger = $self->{logger};
    my $common = $self->{context}->{common};


    $logger->debug("Yeah you are in awsressources_inventory_handler :)");

    # Please modify below variable if you chose any other profile name during aws cli configuration
    my $profileName = 'ocs';

    # Define here which regions you wish to scan for instances (the profile above must have access to these)
    my @regions = (
                'us-east-2',
                'us-east-1',
                );
    
    foreach my $region (@regions) {
        # Instances will be retrieved for every region specified above
        my $result = `aws ec2 --profile $profileName describe-instances --region $region`;
        $result = decode_json $result;

        if (@{$result->{Reservations}}) {
            $logger->debug("Generation xml data for region : $region");        
            # reservations level
            foreach my $reservation (@{$result->{Reservations}}) {
                my $reservationId = $reservation->{ReservationId};
                my $ownerId = $reservation->{OwnerId};
                
                # instance level
                foreach my $instance (@{$reservation->{Instances}}) {
                    # Add XML
                    push @{$common->{xmltags}->{AWS_INSTANCES}},
                    {
                        RESERVATION_ID => [$reservationId],
                        OWNER_ID => [$ownerId],
                        INSTANCE_ID => [$instance->{InstanceId}],
                        INSTANCE_TYPE => [$instance->{InstanceType}],
                        LAUNCH_TIME => [$instance->{LaunchTime}],
                        AVAILABILTY_ZONE => [$instance->{Placement}{AvailabilityZone}],
                        ARCHITECTURE => [$instance->{Architecture}],
                        KEY_NAME => [$instance->{KeyName}],
                        IMAGE_ID => [$instance->{ImageId}],
                        AMI_LAUNCH_INDEX => [$instance->{AmiLaunchIndex}],
                        MONITORING => [$instance->{Monitoring}{State}],
                        STATE_CODE => [$instance->{State}{Code}],
                        STATE_NAME => [$instance->{State}{Name}],
                        STATE_REASON => [$instance->{StateTransitionReason}],
                        VIRTUALIZATION_TYPE => [$instance->{VirtualizationType}],
                        HIBERNATION_OPT_CONFIGURED => [JSON::PP::is_bool($instance->{HibernationOptions}->{Configured})],
                        ENCLAVED_OPT_ENABLED => [JSON::PP::is_bool($instance->{EnclaveOptions}->{Enabled})],

                    };

                    foreach my $networkscat (@{$instance->{NetworkInterfaces}}) {
                        push @{$common->{xmltags}->{AWS_INSTANCES_NETWORKS}},
                        {
                            RESERVATION_ID => [$reservationId],
                            OWNER_ID => [$ownerId],
                            INSTANCE_ID => [$instance->{InstanceId}],
                            MAC_ADDR => [$networkscat->{MacAddress}],
                            PRIVATE_DNS_NAME => [$networkscat->{PrivateDnsName}],
                            PRIVATE_IP_ADDR => [$networkscat->{PrivateIpAddress}],
                            PUBLIC_DNS_NAME => [$networkscat->{PublicDnsName}],
                            VPC_ID => [$networkscat->{VpcId}],
                            NETWORK_INTERFACE_ID => [$networkscat->{NetworkInterfaceId}],
                            SUBNET_ID => [$networkscat->{SubnetId}],

                        };

                    }


                    foreach my $blockcat (@{$instance->{BlockDeviceMappings}}) {
                        push @{$common->{xmltags}->{AWS_INSTANCES_HARDWARE}},
                        {
                            RESERVATION_ID => [$reservationId],
                            OWNER_ID => [$ownerId],
                            INSTANCE_ID => [$instance->{InstanceId}],
                            ROOT_DEVICE_NAME => [$instance->{RootDeviceName}],
                            ROOT_DEVICE_TYPE => [$instance->{RootDeviceType}],
                            CPU_CORE_COUNT => [$instance->{CpuOptions}{CoreCount}],
                            CPU_THREADS_PER_CORE => [$instance->{CpuOptions}{ThreadsPerCore}],
                            HYPERVISOR => [$instance->{Hypervisor}],
                            BLOCK_DEVICE_NAME => [$blockcat->{DeviceName}],
                            # BLOCK_DEVICE_TYPE => $blockcat->{Ebs},
                            BLOCK_DEVICE_ATTACH_TIME => [$blockcat->{Ebs}{AttachTime}],
                            BLOCK_DEVICE_DELETE_ON_TERMINATION => [JSON::PP::is_bool($blockcat->{Ebs}{DeleteOnTermination})],
                            BLOCK_DEVICE_STATUS => [$blockcat->{Ebs}{Status}],
                            BLOCK_DEVICE_VOLUME_ID => [$blockcat->{Ebs}{VolumeId}],
                        };
                        
                    }

                }
            }
        } else {
            $logger->debug("No instances found for region : $region");
        }
    }




    $logger->debug("Finishing awsressources_inventory_handler ..");
}

1;
