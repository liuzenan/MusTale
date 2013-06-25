<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Example
 *
 * This is an example of a few basic user interaction methods you could use
 * all done with a hardcoded array.
 *
 * @package		CodeIgniter
 * @subpackage	Rest Server
 * @category	Controller
 * @author		Phil Sturgeon
 * @link		http://philsturgeon.co.uk/code/
 */

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH . '/libraries/REST_Controller.php';
/*
 200: Success (OK)
 400: Invalid widget was requested (Bad Request)
 401: Invalid authorization credentials (Unauthorized)
 403: Invalid timestamp in Date header (Forbidden)
 404: Unsupported method or format (Not Found)
 *
 */

class MY_REST_Controller extends REST_Controller {
	var $APP_FACEBOOK_ID = "168614603309444";
	var $APP_FACEBOOK_SECRET = "e88fd3b4f3ac6b984f945dc346a7676a";
	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> model('User_model');
		$this -> load -> model('Song_model');
		$this -> load -> model('Listen_model');
		$this -> load -> model('Tale_model');
		$this -> load -> model('Comment_model');
		$this -> load -> model('User_like_tale_model');
		$this -> load -> helper('rest_helper');
		$this -> load -> model('Dedication_model');
	}

	// note this wrapper function exists in order to circumvent PHP’s
	//strict obeying of HTTP error codes.  In this case, Facebook
	//returns error code 400 which PHP obeys and wipes out
	//the response.
	function _curl_get_file_contents($URL) {
		$c = curl_init();
		curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($c, CURLOPT_URL, $URL);
		$contents = curl_exec($c);
		$err = curl_getinfo($c, CURLINFO_HTTP_CODE);
		curl_close($c);
		if ($contents)
			return $contents;
		else
			return FALSE;
	}

	function token_get() {
		$accessToken = $this -> get('access_token');
		$result = self::_validate_access_token($accessToken);
		$this -> response($result, 200);
	}

	function _validate_access_token($access_token) {
		$app_id = $this -> APP_FACEBOOK_ID;
		$app_secret = $this -> APP_FACEBOOK_SECRET;
		// Attempt to query the graph:
		$graph_url = "https://graph.facebook.com/me?" . "access_token=" . $access_token;
		$response = self::_curl_get_file_contents($graph_url);
		$decoded_response = json_decode($response);

		//Check for errors
		if (isset($decoded_response -> error)) {
			// check to see if this is an oAuth error:
			if ($decoded_response -> error -> type == "OAuthException") {
				// Retrieving a valid access token.
				return array('result' => FALSE, 'error' => $decoded_response -> error -> message);
			} else {
				return array('result' => FALSE, 'error' => "other error has happened");
			}
		} else {
			// success
			return array('result' => TRUE, 'error' => NULL, 'fb_id' => $decoded_response -> id);
		}

	}

	function _authenticate() {
		if (!isset($_GET['auth_token']) && !isset($_POST['auth_token']) && !$this -> get('auth_token')) {
			$this -> response(array('error' => 'unauthorized1'), 401);
		} else if (isset($_GET['auth_token'])) {
			$authToken = $_GET['auth_token'];
		} else if ($this -> get('auth_token')) {
			$authToken = $this -> get('auth_token');
		} else {
			$authToken = $_POST['auth_token'];
		}
		$result = $this -> User_model -> get_with(array('auth_token' => $authToken));
		if (!$result || count($result) == 0) {
			$this -> response(array('error' => 'unauthorized2'), 401);
		}
		return $result[0];
	}

	function _validatePostParams($result) {
		if (isset($result['error'])) {
			$this -> response(array('error' => $result['error']), 400);
		} else if (count($result) == 0) {
			$this -> response(array('error' => NULL), 400);
		}
	}

	/*
	 * Check parameter of a post function, return key-value pair array of parameter
	 */
	function _checkPostParams($params, $default_values) {
		$result = array();
		foreach ($params as $param) {
			// if a param is not set value and no default value is set, then error
			if (!$this -> post($param) && !isset($default_values[$param])) {
				return array('error' => $param . " is not set");
			} else if (!$this -> post($param)) {
				// if a param is not set value but has default value, then good
				$value = $default_values[$param];
				$result[$param] = $value;
			} else {
				// else has value
				$value = $this -> post($param);
				$result[$param] = $value;
			}
		}
		return $result;
	}

	/*
	 * Check parameter of a put function, return key-value pair array of parameter
	 */
	function _filterPutParams($allowd_params) {
		$result = array();
		foreach ($allowd_params as $allowd_param) {
			if ($this -> put($allowd_param)) {
				$result[$allowd_param] = $this -> put($allowd_param);
			}
		}
		return $result;
	}

	/*
	 * Form get params from $this->get
	 */
	function _formGetParams($getable_params) {
		$result = array();
		foreach ($getable_params as $getable_param) {
			if ($this -> get($getable_param)) {
				$result[$getable_param] = $this -> get($getable_param);
			}
		}
		return $result;
	}

}
