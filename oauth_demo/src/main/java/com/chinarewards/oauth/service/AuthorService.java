package com.chinarewards.oauth.service;

import java.util.List;

import com.chinarewards.oauth.domain.Author;
import com.chinarewards.oauth.reg.mapper.AuthorMapper;
import com.google.inject.Inject;

public class AuthorService implements IAuthorService {
	
	@Inject
	private AuthorMapper authorMapper;
	
	@Override
	public Integer create(Author author) {

		return authorMapper.insert(author);
	}

	@Override
	public Integer update(Author author) {

		return authorMapper.update(author);
	}

	@Override
	public Author findById(Integer id) {
		
		return authorMapper.select(id);
	}

	@Override
	public Integer delete(Author author) {

		return authorMapper.delete(author);
	}

	@Override
	public Integer deleteAll() {

		return authorMapper.deleteAll();
	}

	@Override
	public List<Author> findAll() {

		return authorMapper.selectAll();
	}

	@Override
	public Integer batchDelete(List<Integer> list) {

		return authorMapper.batchDelete(list);
	}

}
