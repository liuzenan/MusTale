<?php
class Tale_model extends CI_Model {

	var $joint_primary_keys = array('uid', 'song_id');
	var $public_attr = 'tale_id,uid,song_id,text,voice_url,created_at,is_public,is_anonymous,is_front';
	var $database_name = 'tales';
	var $primary_key = 'tale_id';
	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
	}

	function get_with($values) {
		$this -> db -> select($this -> public_attr);
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
	}

	function insert_entry($values) {
		$this -> db -> insert($this -> database_name, $values);

		if ($this -> db -> affected_rows() == 1) {
			return $this -> get_with(array('tale_id'=>$this->db->insert_id()));
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
