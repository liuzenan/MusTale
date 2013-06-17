<?php
class Listen_model extends CI_Model {

	var $joint_primary_keys = array('uid', 'song_id');
	var $database_name = 'listens';
	var $song_database_name = 'songs';
	var $public_attr = 'uid, song_id , listen_count';
	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
		$this -> load -> model('Song_model');
	}

	function get_popular($desc = 'desc', $limit = 50) {
		$this -> db -> select('songs.song_id, itune_track_id, SUM(listen_count) as listen_count');
		$this -> db -> join($this -> song_database_name, "$this->database_name.song_id = $this->song_database_name.song_id");
		$this -> db -> order_by('SUM(listen_count)', $desc);
		//$this -> db -> limit($limit);
		$this -> db -> group_by("song_id");
		$query = $this -> db -> get($this -> database_name);

		return $query -> result();
	}

	function get_with($values) {
		$this -> db -> select($this -> public_attr);
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
	}

	function update_count($values) {
		$this -> db -> select('listen_count');
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		$entry = $query -> row();
		$count = $entry -> listen_count;
		$count = $count + 1;
		$this -> db -> where($values);
		$this -> db -> update($this -> database_name, array('listen_count' => $count));
		return $this -> get_with($values);
	}

	function insert_entry($values) {
		if (self::is_existing($values)) {
			return $this -> update_count($values);
		}

		$this -> db -> insert($this -> database_name, $values);

		if ($this -> db -> affected_rows() == 1) {
			return $this -> get_with($values);
		} else {
			return NULL;
		}
	}

	function is_existing($values) {
		return self::_isExist($this -> joint_primary_keys, $values);
	}

	// Changed for joint-primary keys database
	function _isExist($joint_primary_keys, $values) {
		foreach ($joint_primary_keys as $joint_primary_key) {
			if (!isset($values[$joint_primary_key])) {
				return TRUE;
			}
			$this -> db -> where($joint_primary_key, $values[$joint_primary_key]);
		}
		$query = $this -> db -> get($this -> database_name);
		return ($query -> num_rows() != 0);
	}

}
