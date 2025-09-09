package com.myspring.vampir.item.service;

import java.util.List;

import org.springframework.dao.DataAccessException;

public interface ItemService {
	public List listItems() throws DataAccessException;
}
