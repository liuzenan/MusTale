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

class Logout extends REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> model('User_model');
		$this -> load -> model('Song_model');
		$this -> load -> model('Dedication_model');
		$this -> load -> model('Tale_model');
		$this -> load -> model('User_like_tale_model');
	}

	function index_get() {
		$user = self::_authenticate();
		
		$this -> User_model -> update_user_with_id($user->uid,array('auth_token' => ''));
		$this -> response('', 200);
	}

	function _authenticate() {
		if (!$this -> get('auth_token')) {
			$this -> response(array('error' => 'unauthorized'), 401);
		}
		$authToken = $this -> get('auth_token');
		$result = $this -> User_model -> get_with(array('auth_token' => $authToken));
		if (!$result || count($result) == 0) {
			$this -> response(array('error' => 'unauthorized'), 401);
		}
		return $result[0];
	}

}
