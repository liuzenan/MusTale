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

	function index_get() {
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
		$getableParams = array('uid', 'fb_id');
		$values = self::_formGetParams($getableParams);

		if (count($values) != 1) {// no param is provided
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$user = $this -> User_model -> get_with($values);
		if ($user && count($user) > 0) {
			$this -> response(array('user' => $user[0]), 200);
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
	 * Song
	 */
	// Get a Song
	function song_get() {
		$getableParams = array('song_id');
		$values = self::_formGetParams($getableParams);
		if (count($values) != 1) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$song = $this -> Song_model -> get_with($values);
		if ($song) {
			$this -> response($song, 200);
		} else {
			$this -> response(array('error' => 'Song could not be found'), 404);
		}
	}

	// Get all songs
	function songs_get() {
		$getableParams = array('song_id', 'itune_track_id');
		$values = self::_formGetParams($getableParams);
		$song = $this -> Song_model -> get_with($values);
		if ($song) {
			$this -> response($song, 200);
		} else {
			$this -> response(array('error' => 'Song could not be found'), 404);
		}
	}

	// Create a song
	function songs_post() {
		$params = array('itune_track_id');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);

		if (isset($result['error'])) {
			$this -> response(array('error' => $result['error']), 400);
		} else if (count($result) == 0) {
			$this -> response(array('error' => NULL), 400);
		}

		$songID = $this -> Song_model -> insert_entry($result);

		if ($songID) {
			$this -> response(array('song_id' => $songID), 200);
		} else {
			$this -> response(array('error' => 'Song already exist!'), 404);
		}
	}

	/*
	 * Dedication
	 */
	function dedications_post() {
		if ($this -> post('from') == $this -> post('to')) {
			$this -> response(array('error' => "Invalid arguments"), 400);
		}

		$params = array('from', 'to', 'tale_id', 'text', 'voice_url');
		$default_values = array('text' => '', 'voice_url' => '');
		$result = self::_checkPostParams($params, $default_values);

		if (isset($result['error'])) {
			$this -> response(array('error' => $result['error']), 400);
		} else if (count($result) == 0) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}

		// assure at either voice_url or text isset
		if ($result['text'] == '' && $result['voice_url'] == '') {
			$this -> response(array('error' => "dedication content is not set"), 400);
		}

		// assure foreign keys constrains
		$from = $this -> User_model -> get_with(array('uid' => $result['from']));
		$to = $this -> User_model -> get_with(array('uid' => $result['to']));
		$song = $this -> Song_model -> get_with(array('tale_id' => $result['tale_id']));

		if (!$from || !$to || !$song) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}

		$dedication = $this -> Dedication_model -> insert_entry($result);

		if ($dedication) {
			$this -> response($dedication, 200);
		} else {
			$this -> response(array('error' => 'dedication already exist!'), 404);
		}
	}

	// Get a dedication
	function dedication_get() {
		$getableParams = array('from', 'to');
		$values = self::_formGetParams($getableParams);
		if (count($values) != 2) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}
		$dedication = $this -> Dedication_model -> get_with($values);
		if ($dedication) {
			$this -> response($dedication, 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
	}

	// Get dedications
	function dedications_get() {
		$getableParams = array('from', 'to');
		$values = self::_formGetParams($getableParams);
		$dedications = $this -> Dedication_model -> get_with($values);
		if ($dedications) {
			$this -> response($dedications, 200);
		} else {
			$this -> response(array('error' => 'Dedication could not be found'), 404);
		}
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
	function tales_get() {
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
	function tales_post() {
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

	function subscribe_post() {

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
		$app_id = "168614603309444";
		$app_secret = "e88fd3b4f3ac6b984f945dc346a7676a";

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

}
