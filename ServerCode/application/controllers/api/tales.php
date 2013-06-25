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

class Tales extends MY_REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
	}

	function comments_post() {
		$user = self::_authenticate();
		$params = array('tale_id', 'content');
		$tale = $this -> Tale_model -> get_with(array('tale_id' => $tale_id));
		if (!$tale) {
			$this -> response(array('error' => 'Invalid arguments2'), 400);
		}
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		self::_validatePostParams($result);
		$result['uid'] = $user -> uid;
		$comment = $this -> Comment_model -> insert_entry($result);
		$this -> response($comment, 200);
	}

	function comments_get() {
		$user = self::_authenticate();
		if (!$this -> get('tale_id')) {
			$this -> response(array('error' => 'Invalid arguments1'), 400);
		}
		$taleId = $this -> get('tale_id');
		$tale = $this -> Tale_model -> get_with(array('tale_id' => $taleId));
		if (!$tale) {
			$this -> response(array('error' => 'Invalid arguments2'), 400);
		}

		
		$comments = $this -> Comment_model -> get_with(array('tale_id' => $taleId));
		$this -> response($comments, 200);
	}

	/**
	 *
	 */
	public function likes_post() {
		$user = self::_authenticate();
		if (!$this -> get('tale_id')) {
			$this -> response(array('error' => 'Invalid arguments1'), 400);
		}
		$tale_id = $this -> get('tale_id');

		$tale = $this -> Tale_model -> get_with(array('tale_id' => $tale_id));

		if (!$tale) {
			$this -> response(array('error' => 'Invalid arguments2'), 400);
		}

		$like = $this -> User_like_tale_model -> insert_entry(array('tale_id' => $tale_id, 'uid' => $user -> uid));

		if ($like) {
			$count = count($this -> User_like_tale_model -> get_with(array('tale_id' => $tale_id)));
			$this -> response(array('count' => $count), 200);
		} else {
			$this -> response(array('error' => 'user already liked!'), 404);
		}
	}

	function unlikes_post() {
		$user = self::_authenticate();
		if (!$this -> get('tale_id')) {
			$this -> response(array('error' => 'Invalid arguments1'), 400);
		}
		$tale_id = $this -> get('tale_id');

		$tale = $this -> Tale_model -> get_with(array('tale_id' => $tale_id));

		if (!$tale) {
			$this -> response(array('error' => 'Invalid arguments2'), 400);
		}

		$result = $this -> User_like_tale_model -> delete_entry(array('tale_id' => $tale_id, 'uid' => $user -> uid));

		if ($result) {
			$count = count($this -> User_like_tale_model -> get_with(array('tale_id' => $tale_id)));
			$this -> response(array('count' => $count), 200);
		} else {
			$this -> response(array('error' => 'user not liked yet'), 404);
		}
	}

	public function likes_get() {
		$user = self::_authenticate();
		$getableParams = array('tale_id', 'uid');
		$values = self::_formGetParams($getableParams);
		if (count($values) == 0) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$likeCount = count($this -> Tale_model -> get_with($values));
		if ($likeCount) {
			$this -> response(array('count' => $likeCount), 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
	}

}
