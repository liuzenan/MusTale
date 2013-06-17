<?php
class User_model extends CI_Model {

	var $primary_key = 'uid';
	var $public_attr = 'uid,fb_id,email,name,gender,profile_url,fb_location_id,link,created_at';
	var $database_name = 'users';
	var $unique_attrs = array('uid', 'fb_id', 'email');

	function __construct() {
		// Call the Model constructor
		parent::__construct();
		$this -> load -> database();
	}

	function get_auth_token($values) {
		$this -> db -> select('auth_token,uid');
		$this -> db -> where($values);
		$query = $this -> db -> get($this -> database_name);
		return $query -> result();
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
		if (self::is_existing_user($values)) {
			return NULL;
		}
		$this -> db -> insert($this -> database_name, $values);
		if ($this -> db -> affected_rows() == 1) {
			$uid = $this -> db -> insert_id();
			$this -> renewAuthToken($uid);
			return $uid;
		} else {
			return NULL;
		}
	}
	function renewAuthToken($uid) {
		$this -> update_user_with_id($uid, array('auth_token' => self::_generateAuthToken($uid)));
	}

	function get_with_id($id) {
		return self::get_with(array('uid' => $id));
	}

	function update_user_with_id($id, $values) {
		if (!self::is_existing_user($values) || !self::is_existing_user_with_id($id)) {
			return NULL;
		} else {
			$id_key_pair = array($this -> primary_key => $id);
			$this -> db -> update($this -> database_name, $values, $id_key_pair);
			if ($this -> db -> affected_rows() != 0) {
				return self::get_with_id($id);
			} else {
				return NULL;
			}
		}
	}

	function is_existing_user_with_id($id) {
		$values = array($this -> primary_key => $id);
		return self::is_existing_user($values);
	}

	function is_existing_user($values) {
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

	function _generateAuthToken($uid) {
		$date = new DateTime();
		return md5($uid . $date -> getTimestamp());
	}


}
