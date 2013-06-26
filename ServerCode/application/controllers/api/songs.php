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

class Songs extends MY_REST_Controller {

	function __construct() {
		// Call the Model constructor
		parent::__construct();
	}

	// Create a song
	function index_post() {
		$user = self::_authenticate();
		$params = array('itune_track_id');
		$default_values = array();
		$result = self::_checkPostParams($params, $default_values);
		self::_validatePostParams($result);
		$songID = $this -> Song_model -> insert_entry($result);

		if ($songID) {
			$this -> response(array('song_id' => $songID), 200);
		} else {
			$result = $this -> Song_model -> get_with(array('itune_track_id' => $this -> post('itune_track_id')));
			$this -> response(array('song_id' => $result[0] -> song_id), 200);
		}
	}

	// Get all songs
	function index_get() {
		$user = self::_authenticate();
		$getableParams = array('song_id', 'itune_track_id');
		$values = self::_formGetParams($getableParams);
		$song = $this -> Song_model -> get_with($values);
		if ($song) {
			$this -> response($song, 200);
		} else {
			$this -> response(array('error' => 'Song could not be found'), 404);
		}
	}

	/*
	 * Tale
	 */
	// upload a tale
	function tales_post() {
		$user = self::_authenticate();
		if (!$this -> get('song_id')) {
			$this -> response(array('error' => 'invalid arguement'), 400);
		}
		$songId = $this -> get('song_id');
		$userId = $user -> uid;

		// assure foreign keys constrains
		$song = $this -> Song_model -> get_with(array('song_id' => $songId));
		if (!$song || count($song) == 0) {
			$this -> response(array('error' => 'Invalid arguments'), 400);
		}

		$params = array('text', 'text', 'voice_url');
		$default_values = array('text' => '', 'voice_url' => '');

		$result = self::_checkPostParams($params, $default_values);
		self::_validatePostParams($result);

		// Special handler for boolean 囧
		$result['is_front'] = $_POST['is_front'];
		$result['is_anonymous'] = $_POST['is_anonymous'];
		$result['is_public'] = $_POST['is_public'];

		// voice_url or text must set
		if (strlen($result['voice_url']) == 0 && strlen($result['text']) == 0) {
			$this -> response(array('error' => 'invalid arguement'), 400);
		}

		$result['uid'] = $userId;
		$result['song_id'] = $songId;

		$array = $this -> Tale_model -> insert_entry($result);

		if ($array) {
			$this -> response($array[0], 200);
		} else {
			$this -> response(array('error' => 'Song could not be found'), 404);
		}
	}

	function tales_get() {
		$user = self::_authenticate();
		if (!$this -> get('song_id')) {
			$this -> response(array('error' => 'invalid arguement'), 400);
		}
		$songId = $this -> get('song_id');
		$curUserID = $user -> uid;
		$tales = $this -> Tale_model -> get_with(array('song_id' => $songId));
		// for each tale
		$result = array();
		foreach ($tales as $tale) {

			$postUserID = $tale -> uid;
			unset($tale -> uid);
			// if tale is not public and the request user is not equal the post user, skip the tale
			if (!$tale -> is_public && strcmp($curUserID, $postUserID) != 0) {
				continue;
			} else {
				$taleId = $tale -> tale_id;
				$tale -> is_liked = $this -> User_like_tale_model -> is_liked($curUserID, $taleId);
				$tale -> like_count = count($this -> User_like_tale_model -> get_with(array('tale_id' => $taleId)));
				$tale -> comment_count = count($this -> Comment_model -> get_with(array('tale_id' => $taleId)));
				if (!$tale -> is_anonymous || $curUserID == $postUserID) {
					$fromUser = $this -> User_model -> get_with(array('uid' => $postUserID));
					$tale -> from_user = $fromUser[0];
				} else {
					$tale -> from_user = NULL;
				}
				$result[] = $tale;
			}
		}
		$this -> response($result, 200);
	}

}
