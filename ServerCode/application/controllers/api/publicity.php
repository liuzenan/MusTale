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
require APPPATH . '/libraries/MY_REST_Controller.php';
/*
 200: Success (OK)
 400: Invalid widget was requested (Bad Request)
 401: Invalid authorization credentials (Unauthorized)
 403: Invalid timestamp in Date header (Forbidden)
 404: Unsupported method or format (Not Found)
 *
 */

class Publicity extends MY_REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
	}

	function subscribe_post() {
		$params = array('email');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		self::_validatePostparams($result);
		$email = $this -> post('email');
		
		/*
		if (!$this -> VerifyMailAddress($email)) {
			$this -> response(array('error' => 'Bad email format'), 400);
		}*/
		
		$subs = self::_get_with(array('email' => $email));
		if ($subs && count($subs) > 0) {
			// Already subscribed
			$this -> response(array('error' => 'User already subscribed'), 404);
		} else {
			$this -> db -> insert('subscribers', $result);
			$this -> response(array('result' => 'success'), 200);
		}
	}

	function VerifyMailAddress($address) {
		$Syntax = '#^[w.-]+@[w.-]+.[a-zA-Z]{2,5}$#';
		if (preg_match($Syntaxe, $adrdess))
			return true;
		else
			return false;
	}

	function _get_with($values) {
		$this -> db -> select('email,created_at,is_invited');
		$this -> db -> where($values);
		$query = $this -> db -> get('subscribers');
		return $query -> result();
	}
}
