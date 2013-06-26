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

class Users extends MY_REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
	}

	function index_get() {
		$user = self::_authenticate();
		$getableParams = array('uid', 'fb_id', 'email', 'name', 'link', 'fb_location_id', 'gender', 'profile_url');
		$values = self::_formGetParams($getableParams);

		$user = $this -> User_model -> get_with($values);
		if ($user) {
			$this -> response(array('user' => $user), 200);
		} else {
			$this -> response(array('error' => 'User could not be found', 'data' => NULL), 200);
		}
	}

	/**
	 * User
	 */

	//Get a user
	function user_get() {
		$user = self::_authenticate();
		$getableParams = array('uid', 'fb_id');
		$values = self::_formGetParams($getableParams);

		if (count($values) != 1) {// no param is provided
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$user = $this -> User_model -> get_with($values);
		if ($user && count($user) > 0) {
			$this -> response($user[0], 200);
		} else {
			$this -> response(array('error' => 'User could not be found', 'data' => NULL), 400);
		}
	}

	// Update a user
	function index_put() {
		if (!$this -> get('uid')) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}

		$id = $this -> get('uid');

		if (!$this -> User_model -> is_existing_user_with_id($id)) {
			$this -> response(array('error' => 'User could not be found'), 404);
		}

		$allowed_params = array('name', 'link', 'fb_location_id', 'gender', 'profile_url');

		$values = self::_filterPutParams($allowed_params);
		$updated_user = $this -> User_model -> update_user_with_id($id, $values);
		if ($updated_user) {
			$this -> response(array('user' => $updated_user), 200);
		} else {
			$this -> response(array('error' => 'Could not update user', 'provided_values' => $values), 200);
		}
	}

	/*
	 * Dedication
	 */
	function dedications_post() {
		$userFrom = self::_authenticate();

		$params = array('tale_id');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		self::_validatePostParams($result);
		if (!$this -> get('uid')) {
			$this -> response(array('error' => "Uid is not set"), 400);
		}

		// Special handle for boolean 囧
		$result['is_anonymous'] = $_POST['is_anonymous'];
		$result['is_public'] = $_POST['is_public'];

		// foriegn key constrain
		$taleList = $this -> Tale_model -> get_with(array('tale_id' => $this -> post('tale_id')));
		$userToList = $this -> User_model -> get_with(array('uid' => $this -> get('uid')));
		if (!$taleList || !$userToList) {
			$this -> response(array('error' => "Invalid arguments"), 400);
		}

		$tale = $taleList[0];
		$userTo = $userToList[0];
		// check if the tale is written by the userFrom
		if (strcmp($userFrom -> uid, $tale -> uid) != 0) {
			$this -> response(array('error' => 'the tale is not from this user'), 400);
		}
		// user cannot didicate to self
		if (strcmp($userFrom -> uid, $userTo -> uid) == 0) {
			$this -> response(array('error' => "Cannot dedicate to self"), 400);
		}

		$result['from'] = $userFrom -> uid;
		$result['to'] = $userTo -> uid;

		$dedicationList = $this -> Dedication_model -> insert_entry($result);

		if (!$dedicationList) {
			$this -> response(array('error' => 'dedication already exist!'), 404);
		} else {
			$dedication = $dedicationList[0];
			$dedication -> from = $userFrom;
			$dedication -> to = $userTo;
			$this -> response($dedication, 200);
		}
	}

	// Get dedications
	function dedications_get() {
		$userRequest = self::_authenticate();
		$getableParams = array('from', 'to', 'created_at');
		$values = self::_formGetParams($getableParams);
		$dedications = $this -> Dedication_model -> get_with($values);
		if ($dedications) {
			$result = array();
			foreach ($dedications as $dedication) {
				$userFromId = $dedication -> from;
				$userToId = $dedication -> to;
				$taleId = $dedication -> tale_id;
				$userFrom = $this -> User_model -> get_with(array('uid' => $userFromId));
				$userTo = $this -> User_model -> get_with(array('uid' => $userToId));
				$tale = $this -> Tale_model -> get_with(array('tale_id' => $taleId));
				$song = $this -> Song_model -> get_with(array('song_id' => $tale[0] -> song_id));
				
				$dedication -> from = $userFrom[0];
				$dedication -> to = $userTo[0];
				$dedication -> song = $song[0];
				
				if (strcmp($userRequest -> uid, $userFromId) == 0) {
					// if request user is the posting-user himself, return full data
					$result[] = $dedication;
				} else if (strcmp($userRequest -> uid, $userToId) == 0) {
					// if request user is the post-to user
					if ($dedication -> is_anonymous) {
						// if dedication is anonymous, then don't show the user from
						$dedication -> from = NULL;
					}
					$result[] = $dedication;
				} else {
					// to other user
					if (!$dedication -> is_public) {
						// if dedication is not public then skip the dedication
						continue;
					} else {
						if ($dedication -> is_anonymous) {
							// if dedication is anonymous, then don't show the user from
							$dedication -> from = NULL;
						}
						$result[] = $dedication;
					}
				}
			}
			$this -> response($result, 200);
		} else {
			$this -> response(array(), 200);
		}
	}

}
