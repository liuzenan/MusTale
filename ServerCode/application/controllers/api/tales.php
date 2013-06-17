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

class Users extends REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> model('User_model');
		$this -> load -> model('Song_model');
		$this -> load -> model('Dedication_model');
		$this -> load -> model('Tale_model');
		$this -> load -> model('User_like_tale_model');
	}

	/**
	 *  Tale
	 */
	// Get a tale
	function tale_get() {
		$getableParams = array('tale_id');
		$values = self::_formGetParams($getableParams);
		if (count($values) != 1) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$tale = $this -> Tale_model -> get_with($values);
		if ($tale) {
			$this -> response($tale, 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
	}

	// Get tales matching query
	function index_get() {
		$getableParams = array('song_id', 'uid');
		$values = self::_formGetParams($getableParams);
		$tale = $this -> Tale_model -> get_with($values);
		if ($tale) {
			$this -> response(array('tales' => $tale), 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
	}

	// Create a tale
	function index_post() {
		$params = array('uid', 'song_id', 'is_public', 'is_anonymous', 'text', 'voice_url');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		if (isset($result['error'])) {
			$this -> response(array('error' => $result['error']), 400);
		} else if (count($result) == 0) {
			$this -> response(array('error' => 'Invalid arguments1'), 400);
		}
		// assure at either voice_url or text isset
		if ($result['text'] == '' && $result['voice_url'] == '') {
			$this -> response(array('error' => "Tale content is not set"), 400);
		}

		// assure foreign keys constrains
		$user = $this -> User_model -> get_with(array('uid' => $result['uid']));
		$song = $this -> Song_model -> get_with(array('song_id' => $result['song_id']));

		if (!$user || !$song) {
			$this -> response(array('error' => 'Invalid arguments2'), 400);
		}

		$tale = $this -> Tale_model -> insert_entry($result);

		if ($tale) {
			$this -> response($tale, 200);
		} else {
			$this -> response(array('error' => 'Tale already exist!'), 404);
		}
	}

	/**
	 *
	 */
	public function likes_post() {
		$params = array('uid', 'tale_id');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		if (isset($result['error'])) {
			$this -> response(array('error' => $result['error']), 400);
		} else if (count($result) == 0) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}

		// assure foreign keys constrains
		$user = $this -> User_model -> get_with(array('uid' => $result['uid']));
		$tale = $this -> Tale_model -> get_with(array('tale_id' => $result['tale_id']));
		if (!$user || !$tale) {
			$this -> response(array('error' => 'Invalid arguments2'), 400);
		}

		$like = $this -> User_like_tale_model -> insert_entry($result);

		if ($like) {
			$this -> response($like, 200);
		} else {
			$this -> response(array('error' => 'user already liked!'), 404);
		}
	}

	public function likes_get() {
		$getableParams = array('tale_id', 'uid');
		$values = self::_formGetParams($getableParams);
		if (count($values) == 0) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$likeCount = $this -> Tale_model -> get_with($values);
		if ($likeCount) {
			$this -> response($likeCount, 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
	}

	public function like_get() {
		$getableParams = array('tale_id', 'uid');
		$values = self::_formGetParams($getableParams);
		if (count($values) != 2) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$likeCount = $this -> Tale_model -> get_with($values);
		if ($likeCount) {
			$this -> response($likeCount, 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
	}

	/*
	 * Check parameter of a post function, return key-value pair array of parameter
	 */
	private function _checkPostParams($params, $default_values) {
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
	private function _filterPutParams($allowd_params) {
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
	private function _formGetParams($getable_params) {
		$result = array();
		foreach ($getable_params as $getable_param) {
			if ($this -> get($getable_param)) {
				$result[$getable_param] = $this -> get($getable_param);
			}
		}
		return $result;
	}

}
