<?php
class Song_model extends CI_Model {

	var $primary_key = 'song_id';
	public $public_attr = 'songs.song_id,songs.itune_track_id,songs.created_at';
	var $database_name = 'songs';
	var $unique_attrs = array('song_id', 'itune_track_id');

	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
	}

	function get_all($limit = 100) {
		$this -> db -> select($this -> public_attr);
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
	}

	function get_with($values) {
		$this -> db -> select($this -> public_attr);
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
	}

	function get_last_ten_entries() {
		$query = $this -> db -> get($this -> database_name, 10);
		return $query -> result();
	}

	function insert_entry($values) {
		if (self::is_existing($values)) {
			return NULL;
		}
		$this -> db -> insert($this -> database_name, $values);
		if ($this -> db -> affected_rows() == 1) {
			return $this -> db -> insert_id();
		} else {
			return NULL;
		}
	}

	function is_existing($values) {
		return self::_isExist($this -> unique_attrs, $values);
	}

	function _isExist($unique_attrs, $values) {
		foreach ($unique_attrs as $unique_attr) {
			if (isset($values[$unique_attr]))
				$this -> db -> or_where($unique_attr, $values[$unique_attr]);
		}
		$query = $this -> db -> get($this -> database_name);
		return ($query -> num_rows() != 0);
	}

}
