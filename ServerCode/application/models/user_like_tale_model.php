<?php
class User_like_tale_model extends CI_Model {

	var $joint_primary_keys = array('uid', 'tale_id');
	var $database_name = 'user_like_tale';
	var $public_attr = array('uid', 'tale_id', 'created_at');
	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
	}

	function is_liked($uid, $taleID) {
		$values = array('uid' => $uid, 'tale_id' => $taleID);
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		if (count($query -> result()) > 0) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function get_count_with($values) {
		$this -> db -> select($this -> public_attr);
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		return count($query -> result());
	}

	function get_with($values) {
		$this -> db -> select($this -> public_attr);
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
	}

	function delete_entry($values) {
		$this -> db -> delete($this -> database_name, $values);
		if ($this -> db -> affected_rows() == 1) {
			return TRUE;
		} else {
			return FALSE;
		}
	}

	function insert_entry($values) {
		if (self::is_existing($values)) {
			return NULL;
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
