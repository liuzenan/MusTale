<?php
class Comment_model extends CI_Model {

	var $joint_primary_keys = array('uid', 'tale_id');
	var $database_name = 'comments';
	var $public_attr = array('uid', 'tale_id', 'content', 'created_at');
	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
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
		$this -> db -> order_by('created_at', 'desc');
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
	}

	function insert_entry($values) {
		$this -> db -> insert($this -> database_name, $values);
		if ($this -> db -> affected_rows() == 1) {
			$entries = $this -> get_with($values);
			return $entries[0];
		} else {
			return NULL;
		}
	}

}
