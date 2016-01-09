#coding: utf-8

class HelloController < ApplicationController
	def index
		render text: 'Hello World..!'
	end

	def view
		@msg = 'Hello World..!'
	end

	def list
		@books = Book.all
	end

	def app_var
		render text: MY_APP['logo']['source']
	end
end
