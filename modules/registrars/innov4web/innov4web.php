<?php

if (!defined("WHMCS")) {
    die("This file cannot be accessed directly");
}

include 'class.php';


function innov4web_MetaData()
{
    return array(
        'DisplayName' => 'Innov4web Registrar Module for WHMCS',
        'APIVersion' => '1.0',
    );
}


function innov4web_getConfigArray()
{
    return [
        'FriendlyName' => [
            'Type' => 'System',
            'Value' => 'Innov4web Registrar Module for WHMCS',
        ],
        'APIUsername' => [
            'FriendlyName' => 'API Username',
            'Type' => 'text',
        ],
        'APIKey' => [
            'FriendlyName' => 'API Password',
            'Type' => 'text',
        ],
    ];
}


function innov4web_RegisterDomain($params)
{



    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'years' => $params['regperiod'],
        'name' => $params['fullname'],
        'companyname' => $params['companyname'],
        'address' => $params['address1'],
        'city' => $params['city'],
        'postcode' => $params['postcode'],
        'countrycode' => $params['countrycode'],
        'email' => $params['email'],
        'phonenumber' => $params['phonenumber'],
        //'vatnumber' => $params['tax_id'], //You can change this field acording you whmcs configuration ex $params["additionalfields"]["nif"]
        'vatnumber' => 999999999,
        'nameserver1' => $params['ns1'],
        'nameserver2' => $params['ns2'],
        'method' => 'POST',
    );


    try {
        $api = new ApiClient();
        $api->call('register', $data);


        $status = $api->getFromResponse('status');

        if ($status == 200){
            return array(
                'success' => true,
            );
        }else{
            return array(
                'error' =>  $api->getFromResponse('message'),
            );
        }




    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}


function innov4web_RenewDomain($params)
{


    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'years' => $params['regperiod'],
        'method' => 'POST',
    );


    try {
        $api = new ApiClient();
        $api->call('renew', $data);

        $status = $api->getFromResponse('status');

        if ($status == 200){
            return array(
                'success' => true,
            );
        }else{
            return array(
                'error' =>  $api->getFromResponse('message'),
            );
        }

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}



function innov4web_TransferDomain($params)
{

    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'eppcode' => $params['eppcode'],
        'nameserver1' => $params['ns1'],
        'nameserver2' => $params['ns2'],
        'method' => 'POST',
    );

    try {
        $api = new ApiClient();
        $api->call('transfer', $data);

        $status = $api->getFromResponse('status');

        if ($status == 200){
            return array(
                'success' => true,
            );
        }else{
            return array(
                'error' =>  $api->getFromResponse('message'),
            );
        }

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}



function innov4web_GetNameservers($params)
{

    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'method' => 'GET',
    );

    try {
        $api = new ApiClient();
        $api->call('info', $data);

        $respApi = $api->getFromResponse('data');

        $status = $api->getFromResponse('status');

        if ($status == 200){

            $nameservers = $respApi['nameservers'];

            return array(
                'ns1' => $nameservers['ns1'],
                'ns2' => $nameservers['ns2'],
                'ns3' => $nameservers['ns3'],
                'ns4' => $nameservers['ns4'],
            );
        }else{

            return array(
                'error' =>  $api->getFromResponse('message'),
            );
        }

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}

function innov4web_SaveNameservers($params)
{

    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'ns1' => $params['ns1'],
        'ns2' => $params['ns2'],
        'ns3' => $params['ns3'],
        'ns4' => $params['ns4'],
        'method' => 'PUT',
    );

    try {
        $api = new ApiClient();
        $api->call('nameservers', $data);

        $status = $api->getFromResponse('status');

        if ($status == 200){
            return array(
                'success' => true,
            );
        }else{
            return array(
                'error' =>  $api->getFromResponse('message'),
            );
        }

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}


function innov4web_GetEPPCode($params)
{

    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'method' => 'GET',
    );

    try {
        $api = new ApiClient();
        $api->call('epp', $data);

        $respApi = $api->getFromResponse('data');
        $eppcode = $respApi['eppcode'];

        if ($eppcode ) {
            // If EPP Code is returned, return it for display to the end user
            return array(
                'eppcode' => $eppcode,
            );
        } else {
            // If EPP Code is not returned, it was sent by email, return success
            return array(
                'success' => 'success',
            );
        }

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}


function innov4web_Sync($params)
{

    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'method' => 'GET',
    );

    try {
        $api = new ApiClient();
        $api->call('info', $data);

        $respApi = $api->getFromResponse('data');

        $status = $respApi['status'];

            if ($status == 'Active'){
                $returnActive = true;
                $returnExpired = false;
                $returnTransferredAway = false;
            }
            if ($status == 'Expired'){
                $returnActive = false;
                $returnExpired = true;
                $returnTransferredAway = false;
            }
            if ($status == 'transferredaway'){
                $returnActive = false;
                $returnExpired = false;
                $returnTransferredAway = true;
            }


        return array(
            'expirydate' => $respApi['expirydate'], // Format: YYYY-MM-DD
            'active' => (bool) $returnActive, // Return true if the domain is active
            'expired' => (bool) $returnExpired, // Return true if the domain has expired
            'transferredAway' => (bool) $returnTransferredAway, // Return true if the domain is transferred out
        );

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}

function innov4web_ClientAreaCustomButtonArray()
{
    return [
        'Manage DNSSEC' => 'dnssecds',
    ];
}

function innov4web_dnssecds($params)
{
    $domain   = $params['sld'] . '.' . $params['tld'];
    $domainid = $params['domainid'];
    $command  = isset($_REQUEST['command']) ? $_REQUEST['command'] : '';
    $error    = null;
    $success  = null;

    $api = new ApiClient();

    // Process add or remove command
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && in_array($command, ['secDNSadd', 'secDNSrem'])) {
        $keyTag     = isset($_POST['keyTag'])     ? trim($_POST['keyTag'])     : '';
        $alg        = isset($_POST['alg'])         ? trim($_POST['alg'])         : '';
        $digestType = isset($_POST['digestType']) ? trim($_POST['digestType']) : '';
        $digest     = isset($_POST['digest'])     ? trim($_POST['digest'])     : '';

        $method = ($command === 'secDNSadd') ? 'POST' : 'DELETE';

        try {
            $api->call('dnssec', [
                'username'   => $params['APIUsername'],
                'password'   => $params['APIKey'],
                'domain'     => $domain,
                'method'     => $method,
                'keytag'     => $keyTag,
                'algorithm'  => $alg,
                'digesttype' => $digestType,
                'digest'     => $digest,
            ]);
            $success = ($command === 'secDNSadd') ? 'DS record added successfully.' : 'DS record removed successfully.';
        } catch (\Exception $e) {
            $error = $e->getMessage();
        }
    }

    // Fetch current records
    $DSRecords     = "You don't have any DS records";
    $DSRecordslist = [];

    if (!$error) {
        try {
            $api->call('dnssec', [
                'username' => $params['APIUsername'],
                'password' => $params['APIKey'],
                'domain'   => $domain,
                'method'   => 'GET',
            ]);

            $status  = $api->getFromResponse('status');
            $data    = $api->getFromResponse('data');
            $records = isset($data['dnssec']) ? $data['dnssec'] : [];

            if ($status == 200 && !empty($records)) {
                $DSRecords = 'YES';
                foreach ($records as $r) {
                    $DSRecordslist[] = [
                        'keyTag'     => $r['keytag'],
                        'alg'        => $r['algorithm'],
                        'digestType' => $r['digesttype'],
                        'digest'     => $r['digest'],
                    ];
                }
            }
        } catch (\Exception $e) {
            $error = $e->getMessage();
        }
    }

    return [
        'templatefile' => 'dnssecds',
        'requirelogin'  => true,
        'vars' => [
            'domain'        => $domain,
            'domainid'      => $domainid,
            'error'         => $error,
            'success'       => $success,
            'DSRecords'     => $DSRecords,
            'DSRecordslist' => $DSRecordslist,
        ],
    ];
}


function innov4web_TransferSync($params)
{

    $data = array(
        'username' => $params['APIUsername'],
        'password' => $params['APIKey'],
        'domain' => $params['sld'] . '.' . $params['tld'],
        'method' => 'GET',
    );



    try {
        $api = new ApiClient();
        $api->call('info', $data);

        $respApi = $api->getFromResponse('data');

        $status = $respApi['status'];

        if ($status == "Active") {
            return array(
                'completed' => true,
                'expirydate' => $respApi['expirydate'], // Format: YYYY-MM-DD
            );

        } else {
            // No status change, return empty array
            return array();
        }

    } catch (\Exception $e) {
        return array(
            'error' => $e->getMessage(),
        );
    }
}

