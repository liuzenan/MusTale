<?php
/*
 * Check parameter of a post function, return key-value pair array of parameter
 */
if (!function_exists('checkPostParams')) {
	function checkPostParams($params, $default_values) {
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

}

/*
 * Check parameter of a put function, return key-value pair array of parameter
 */

if (!function_exists('filterPutParams')) {
	function filterPutParams($allowd_params) {
		$result = array();
		foreach ($allowd_params as $allowd_param) {
			if ($this -> put($allowd_param)) {
				$result[$allowd_param] = $this -> put($allowd_param);
			}
		}
		return $result;
	}

}

/*
 * Form get params from $this->get
 */
if (!function_exists('formGetParams')) {
	function formGetParams($getable_params) {
		$result = array();
		foreach ($getable_params as $getable_param) {
			if ($this -> get($getable_param)) {
				$result[$getable_param] = $this -> get($getable_param);
			}
		}
		return $result;
	}

}

if (!function_exists('authenticate')) {
	function authenticate() {
		if (!$this -> get('auth_token')) {
			$this -> response(array('error' => 'unauthorized'), 401);
		}
		$authToken = $this -> get('auth_token');
		$result = $this -> User_model -> get_with(array('auth_token' => $authToken));
		if (!$result || count($result) == 0) {
			$this -> response(array('error' => 'unauthorized'), 401);
		}
		return $result[0];
	}

}
?>