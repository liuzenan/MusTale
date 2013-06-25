<?php
class Dedication_model extends CI_Model {

	var $joint_primary_keys = array();
	var $public_attr = 'from,to,tale_id,is_anonymous,is_public,created_at';
	var $database_name = 'dedications';

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
