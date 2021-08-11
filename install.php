<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_awsressources()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("DROP TABLE `AWS_INSTANCES`");
    $commonObject -> sqlQuery("DROP TABLE `AWS_NETWORKS`");
    $commonObject -> sqlQuery("DROP TABLE `AWS_SPECS`");

    $commonObject -> sqlQuery("CREATE TABLE `AWS_INSTANCES` (
                          `ID` INT(11) NOT NULL AUTO_INCREMENT,
                          `HARDWARE_ID` INT(11) NOT NULL,
                          `RESERVATION_ID` VARCHAR(255) NOT NULL,
                          `OWNER_ID` VARCHAR(255) NOT NULL,
                          `INSTANCE_ID` VARCHAR(255) NOT NULL,
                          `INSTANCE_TYPE` VARCHAR(255) NOT NULL,
                          `LAUNCH_TIME` VARCHAR(255) DEFAULT NULL,
                          `AVAILABILTY_ZONE` VARCHAR(255) NOT NULL,
                          `ARCHITECTURE` VARCHAR(255) DEFAULT NULL,
    		              `KEY_NAME` VARCHAR(255) DEFAULT NULL,
                          `IMAGE_ID` VARCHAR(255) DEFAULT NULL,
                          `AMI_LAUNCH_INDEX` VARCHAR(255) DEFAULT NULL,
                          `MONITORING` VARCHAR(255) DEFAULT NULL,
                          `STATE_CODE` VARCHAR(255) DEFAULT NULL,
                          `STATE_NAME` VARCHAR(255) DEFAULT NULL,
                          `STATE_REASON` VARCHAR(255) DEFAULT NULL,
                          `VIRTUALIZATION_TYPE` VARCHAR(255) DEFAULT NULL,
                          `HIBERNATION_OPT_CONFIGURED` VARCHAR(255) DEFAULT NULL,
                          `ENCLAVED_OPT_ENABLED` VARCHAR(255) DEFAULT NULL,
                          PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                            ) ENGINE=INNODB ;");

    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `AWS_NETWORKS` (
                        `ID` INT(11) NOT NULL AUTO_INCREMENT,
                        `HARDWARE_ID` INT(11) NOT NULL,
                        `RESERVATION_ID` VARCHAR(255) NOT NULL,
                        `OWNER_ID` VARCHAR(255) NOT NULL,
                        `INSTANCE_ID` VARCHAR(255) NOT NULL,
                        `MAC_ADDR` VARCHAR(255) NOT NULL,
                        `PRIVATE_DNS_NAME` VARCHAR(255) DEFAULT NULL,
                        `PRIVATE_IP_ADDR` VARCHAR(255) DEFAULT NULL,
                        `PUBLIC_DNS_NAME` VARCHAR(255) DEFAULT NULL,
                        `VPC_ID` VARCHAR(255) DEFAULT NULL,
                        `NETWORK_INTERFACE_ID` VARCHAR(255) DEFAULT NULL,
                        `SUBNET_ID` VARCHAR(255) DEFAULT NULL,
                        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                        ) ENGINE=INNODB;");


    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `AWS_SPECS` (
                        `ID` INT(11) NOT NULL AUTO_INCREMENT,
                        `HARDWARE_ID` INT(11) NOT NULL,
                        `RESERVATION_ID` VARCHAR(255) NOT NULL,
                        `OWNER_ID` VARCHAR(255) NOT NULL,
                        `INSTANCE_ID` VARCHAR(255) NOT NULL,
                        `BLOCK_DEVICE_NAME` VARCHAR(255) DEFAULT NULL,
                        `BLOCK_DEVICE_ATTACH_TIME` VARCHAR(255) DEFAULT NULL,
                        `BLOCK_DEVICE_DELETE_ON_TERMINATION` VARCHAR(255) DEFAULT NULL,
                        `BLOCK_DEVICE_STATUS` VARCHAR(255) DEFAULT NULL,
                        `BLOCK_DEVICE_VOLUME_ID` VARCHAR(255) DEFAULT NULL,
                        `CPU_CORE_COUNT` VARCHAR(255) DEFAULT NULL,
                        `CPU_THREADS_PER_CORE` VARCHAR(255) DEFAULT NULL,
                        `HYPERVISOR`  VARCHAR(255) DEFAULT NULL,
                        `ROOT_DEVICE_NAME` VARCHAR(255) DEFAULT NULL,
                        `ROOT_DEVICE_TYPE` VARCHAR(255) DEFAULT NULL,
                        PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                        ) ENGINE=INNODB;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_awsressources()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE `AWS_INSTANCES`");
    $commonObject -> sqlQuery("DROP TABLE `AWS_NETWORKS`");
    $commonObject -> sqlQuery("DROP TABLE `AWS_SPECS`");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_awsressources()
{

}