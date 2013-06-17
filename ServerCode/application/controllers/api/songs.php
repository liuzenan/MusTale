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

}
