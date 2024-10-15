<?php


class ApiClient
{


    const API_URL = 'https://api.innov4web.pt/v1/';

    protected $results = array();


    public function call($action, $data)
    {
        $method = $data['method'];

        //Login and get Bearer token
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, self::API_URL . 'login');
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS,
            http_build_query(
                array(
                    'api_username' => $data['username'],
                    'api_password' => $data['password'],
                )
            )
        );
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $response = curl_exec($ch);
        if (curl_errno($ch)) {
            throw new \Exception('Connection Error: ' . curl_errno($ch) . ' - ' . curl_error($ch));
        }
        curl_close($ch);


        $auth = json_decode($response, true);
        $authstatus = $auth['status'];

        // Auth error
        if(!$authstatus == '200'){
            throw new \Exception('Auth error');
        }

        unset($data['username']);
        unset($data['password']);

        $token = $auth['data']['token'];
        $domain = $data['domain'];

        // Exec api request
        $ch = curl_init();
        if ($action == 'renew' OR $action == 'register'){
            $years = $data['years'];
            curl_setopt($ch, CURLOPT_URL, self::API_URL . 'domains/'.$domain.'/'.$action.'/'.$years);
        }else{
            curl_setopt($ch, CURLOPT_URL, self::API_URL . 'domains/'.$domain.'/'.$action);
        }


        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Authorization: Bearer ' . $token, 'Accept: application/json'));
        if($method == 'PUT'){
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "PUT");
            curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: Bearer ' . $token , 'Content-Type: application/x-www-form-urlencoded', 'Accept: application/json'));
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        }
        if($method == 'POST'){
            curl_setopt($ch, CURLOPT_HTTPHEADER, array('Authorization: Bearer ' . $token , 'Accept: application/json'));
            curl_setopt($ch, CURLOPT_POST, 1);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data));
        }
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 100);
        $response = curl_exec($ch);
        if (curl_errno($ch)) {
            throw new \Exception('Connection Error: ' . curl_errno($ch) . ' - ' . curl_error($ch));
        }
        curl_close($ch);

        //Status 200
        $responsestatus = json_decode($response, true);
        $respstatus = $responsestatus['status'];
        $respmessage = $responsestatus['message'];
        if(!$respstatus == '200'){
            throw new \Exception("Error : $respmessage");
        }



        //Delete current autorization token
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, self::API_URL . 'logout');
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Authorization: Bearer ' . $token, 'Accept: application/json'));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $logout = curl_exec($ch);
        if (curl_errno($ch)) {
            throw new \Exception('Connection Error: ' . curl_errno($ch) . ' - ' . curl_error($ch));
        }
        curl_close($ch);



        $this->results = $this->processResponse($response);

        logModuleCall(
            'innov4web',
            $action,
            $data,
            $response,
            $this->results
        );

        if ($this->results === null && json_last_error() !== JSON_ERROR_NONE) {
            throw new \Exception('Bad response received from API');
        }

        return $this->results;
    }


    public function processResponse($response)
    {
        return json_decode($response, true);
    }


    public function getFromResponse($key)
    {
        return isset($this->results[$key]) ? $this->results[$key] : '';
    }
}
