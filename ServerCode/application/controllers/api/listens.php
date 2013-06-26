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

class Listens extends MY_REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
	}

	function index_post() {
		$user = self::_authenticate();
		$params = array('song_id');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		self::_validatePostParams($result);
		
		// assure foreign keys constrains
		$song = $this -> Song_model -> get_with(array('song_id' => $result['song_id']));
		
		if (!$song) {
			$this -> response(array('error' => 'Song id can not be found '), 400);
		}
		$result['uid'] = $user->uid;
		$entry = $this -> Listen_model -> insert_entry($result);
		if ($entry && count($entry)) {
			$this -> response($entry[0], 200);
		} else {
			$this -> response(array('error' => 'Invalid argument'), 400);
		}
	}

	function popular_get() {
		self::_authenticate();
		if (!$this -> get('uid')) {
			$user = self::_authenticate();
			$result = $this -> Listen_model -> get_popular('desc', 50);
			$this -> response($result, 200);
		} else {

		}
	}

}
