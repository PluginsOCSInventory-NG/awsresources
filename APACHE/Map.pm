###############################################################################
## OCSINVENTORY-NG
## Copyleft Léa Droguet 2021
## Web : http://www.ocsinventory-ng.org
##
## This code is open source and may be copied and modified as long as the source
## code is always made freely available.
## Please refer to the General Public Licence http://www.gnu.org/ or Licence.txt
################################################################################

package Apache::Ocsinventory::Plugins::Awsresources::Map;

use strict;

use Apache::Ocsinventory::Map;

$DATA_MAP{AWS_INSTANCES} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'INSTANCE_ID',
    writeDiff => 0,
    cache => 0,
    fields => {
      RESERVATION_ID => {},
      OWNER_ID => {},
      ACCOUNT_ALIAS => {},
      INSTANCE_ID => {},
      INSTANCE_TYPE => {},
      LAUNCH_TIME => {},
      AVAILABILTY_ZONE => {},
      ARCHITECTURE => {},
      KEY_NAME => {},
      IMAGE_ID => {},
      IMAGE_DESCRIPTION => {},
      AMI_LAUNCH_INDEX => {},
      MONITORING => {},
      STATE_CODE => {},
      STATE_NAME => {},
      STATE_REASON => {},
      VIRTUALIZATION_TYPE => {},
      HIBERNATION_OPT_CONFIGURED => {},
      ENCLAVED_OPT_ENABLED=> {},
    }
  };

$DATA_MAP{AWS_INSTANCES_NETWORKS} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      RESERVATION_ID => {},
      OWNER_ID => {},
      ACCOUNT_ALIAS => {},
      INSTANCE_ID => {},
      MAC_ADDR => {},
      PRIVATE_DNS_NAME => {},
      PRIVATE_IP_ADDR => {},
      PUBLIC_DNS_NAME => {},
      VPC_ID => {},
      NETWORK_INTERFACE_ID => {},
      SUBNET_ID => {},
    }
  };

$DATA_MAP{AWS_INSTANCES_HARDWARE} = {
    mask => 0,
    multi => 1,
    auto => 1,
    delOnReplace => 1,
    sortBy => 'NAME',
    writeDiff => 0,
    cache => 0,
    fields => {
      RESERVATION_ID => {},
      OWNER_ID => {},
      ACCOUNT_ALIAS => {},
      INSTANCE_ID => {},
      BLOCK_DEVICE_NAME => {},
      BLOCK_DEVICE_ATTACH_TIME => {},
      BLOCK_DEVICE_DELETE_ON_TERMINATION => {},
      BLOCK_DEVICE_STATUS => {},
      BLOCK_DEVICE_VOLUME_ID => {},
      CPU_CORE_COUNT => {},
      CPU_THREADS_PER_CORE => {},
      HYPERVISOR => {},
      ROOT_DEVICE_NAME => {},
      ROOT_DEVICE_TYPE => {},
    }
  };
1;
