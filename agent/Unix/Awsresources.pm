# Plugin "Aws Resources" OCSInventory
# Author: Léa DROGUET

package Ocsinventory::Agent::Modules::Awsresources;

use Encode qw(decode);
use POSIX qw(strftime);
use JSON::PP;

sub new {

    my $name="awsresources"; # Name of the module

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
sub awsresources_inventory_handler {

    my $self = shift;
    my $logger = $self->{logger};
    my $common = $self->{context}->{common};


    $logger->debug("Yeah you are in awsresources_inventory_handler :)");

    # add there 1. targeted account and 2. arrays of targeted regions for this account
    my %targets = (
            '000000000002' =>    ['eu-central-1', 'us-east-2'],
            '000000000001' =>    ['eu-central-2', 'us-east-1'],
            ); 
    
    # modify this to match your IAM role name
    my $IAMrole = 'InventorizationRole';
    

    foreach my $account (keys %targets) {
        $ENV{AWS_ACCESS_KEY_ID} = '';
        $ENV{AWS_SECRET_ACCESS_KEY} = '';
        $ENV{AWS_SESSION_TOKEN} = '';
        $arn = "arn:aws:iam::$account:role/$IAMrole";
        # $ENV{HTTP_PROXY} = "set_http_proxy_here_if_necessary";
        # $ENV{HTTPS_PROXY} = "set_https_proxy_here_if_necessary";
        if (($assumeRole = `aws sts assume-role --role-arn "$arn" --role-session-name "OCS-Inventorization" 2>/dev/null`) ne '') {
            $res = decode_json $assumeRole;
            $logger->debug("AssumeRole successful for ARN: $arn");
            # set env var for this AWS role
            $ENV{AWS_ACCESS_KEY_ID} = $res->{Credentials}{AccessKeyId};
            $ENV{AWS_SECRET_ACCESS_KEY} = $res->{Credentials}{SecretAccessKey};
            $ENV{AWS_SESSION_TOKEN} = $res->{Credentials}{SessionToken};

        } else {
            $logger->debug("AssumeRole failed for ARN : $arn");
            next;
        }

        foreach my $region (@{$targets{$account}}) {
            # Instances will be retrieved for every region specified line 47
            if ((my $result = `aws ec2 describe-instances --region $region 2>/dev/null`) ne '') {

                $result = decode_json $result;

                my $accountAlias = `aws iam list-account-aliases`;
                $accountAlias = decode_json $accountAlias;
                $accountAlias = $accountAlias->{AccountAliases}[0];

                if (@{$result->{Reservations}}) {
                    $logger->debug("Generating xml data for region : $region");        
                    # reservations level
                    foreach my $reservation (@{$result->{Reservations}}) {
                        my $reservationId = $reservation->{ReservationId};
                        my $ownerId = $reservation->{OwnerId};
                        
                        # instance level
                        foreach my $instance (@{$reservation->{Instances}}) {
                            my $ImageID = $instance->{ImageId};
                            my $AMIDescription = `aws ec2 describe-images --image-ids $ImageID --region $region`;
                            $AMIDescr = decode_json $AMIDescription;
                            my $ImageDescr = $AMIDescr->{Images}[0]{Description};
                            # Add XML
                            push @{$common->{xmltags}->{AWS_INSTANCES}},
                            {
                                RESERVATION_ID => [$reservationId],
                                OWNER_ID => [$ownerId],
                                ACCOUNT_ALIAS => [$accountAlias],
                                INSTANCE_ID => [$instance->{InstanceId}],
                                INSTANCE_TYPE => [$instance->{InstanceType}],
                                LAUNCH_TIME => [$instance->{LaunchTime}],
                                AVAILABILTY_ZONE => [$instance->{Placement}{AvailabilityZone}],
                                ARCHITECTURE => [$instance->{Architecture}],
                                KEY_NAME => [$instance->{KeyName}],
                                IMAGE_ID => [$instance->{ImageId}],
                                IMAGE_DESCRIPTION => [$ImageDescr],
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
                                    ACCOUNT_ALIAS => [$accountAlias],
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
                                    ACCOUNT_ALIAS => [$accountAlias],
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
            } else {
                $logger->debug("Could not access region : $region");
            }

        }


    }

    $logger->debug("Finishing awsresources_inventory_handler ..");
}

1;
