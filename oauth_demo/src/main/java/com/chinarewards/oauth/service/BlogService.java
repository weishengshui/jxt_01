package com.chinarewards.oauth.service;

import java.util.List;

import com.chinarewards.oauth.domain.Author;
import com.chinarewards.oauth.domain.Blog;
import com.chinarewards.oauth.reg.mapper.BlogMapper;
import com.google.inject.Inject;

public class BlogService implements IBlogService {
	
	@Inject
	private BlogMapper blogMapper;
	@Inject
	private IAuthorService authorService;
	
	@Override
	public Integer create(Blog blog) {
		Author author = blog.getAuthor();
		if(null != author){
			authorService.create(author);
		}
		return blogMapper.insert(blog);
	}

	@Override
	public Integer update(Blog blog) {
		
		return blogMapper.update(blog);
	}

	@Override
	public Blog findById(Integer id) {

		return blogMapper.select(id);
	}

	@Override
	public Integer delete(Blog blog) {

		return blogMapper.delete(blog);
	}

	@Override
	public Integer deleteAll() {

		return blogMapper.deleteAll();
	}

	@Override
	public List<Blog> findAll() {

		return blogMapper.selectAll();
	}

	@Override
	public Integer batchDelete(List<Integer> list) {

		return blogMapper.batchDelete(list);
	}

}
