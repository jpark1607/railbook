class RecordController < ApplicationController
	def find
		@books = Book.find([2, 5, 10])
		render 'hello/list'
	end

	def find_by
		@book = Book.find_by(publish: '제이펍')
		render 'books/show'
	end

	def find_by2
		@book = Book.find_by(publish: '제이펍', price: 27090)
		render 'books/show'
	end

	def where
		@books = Book.where(publish: '제이펍')
		render 'hello/list'
	end

	def where2
		@books = Book.all
		@books.where!(publish: '제이펍')
		@books.order!(:published)
		render 'books/index'
	end

	def ph1
		@books = Book.where('publish = :publish AND price >= :price', 
			publish: params[:publish], price: params[:price])
		render 'hello/list'
	end

	def not
		@books = Book.where.not(isbn: params[:id])
		render 'books/index'
	end

	def order
		@books = Book.where(publish: '제이펍').order(published: :desc, price: :asc)
		render 'hello/list'
	end

	def reorder
		@books = Book.order(:publish).order(:price)
		#@books = Book.order(:publish).reorder(:price)
		#@books = Book.order(:publish).reorder(nil)
		render 'books/index'
	end

	def select
		@books = Book.where('price >= 20000').select(:title, :price)
		render 'hello/list'
	end

	def select2
		@pubs = Book.select(:publish).distinct.order(:publish)
		#@pubs = Book.select(:publish).distinct.distinct(false)
	end

	def offset
		@books = Book.order(published: :desc).limit(3).offset(4)
		render 'hello/list'
	end

	def page
		page_size = 3
		page_num = params[:id] == nil ? 0 : params[:id].to_i - 1
		@books = Book.order(published: :desc).limit(page_size).offset(page_size * page_num)
		render 'hello/list'
	end

	def last
		@book = Book.order(published: :desc).last
		render 'books/show'
	end

	def groupby
		@books = Book.select('publish, AVG(price) AS avg_price').group(:publish)
	end

	def groupby2
		@books = Book.group(:publish).average(:price)
	end

	def havingby
		@books = Book.select('publish, AVG(price) AS avg_price').group(:publish).having('AVG(price) >= ?', 25000)
		render 'record/groupby'
	end

	def unscope
		@books = Book.where(publish: '제이펍').order(:price).select(:isbn, :title).unscope(:where, :select)
		render 'books/index'
	end
	
	def unscope2
		@books = Book.where(publish: '제이펍', cd: true).order(:price).unscope(where: :cd)
		render 'books/index'
	end
	
	def none
		case params[:id]
			when 'all'
				@books = Book.all
			when 'new'
				@books = Book.order('published DESC').limit(5)
			when 'cheap'
				@books = Book.order(:price).limit(5)
			else
				@books = Book.none
		end
		render 'books/index'
	end

	def pluck
		render text: Book.where(publish: '제이펍').pluck(:title, :price)
	end

	def exists
		flag = Book.where(publish: '프리렉').exists?

		#flag = Book.exists?(1)
		#flag = Book.exists?(['price > ?', 5000])
		#flag = Book.exists?(publish: '제이펍')
		#flag = Book.exists?
		render text: "존재하나요? : #{flag}"
	end

	def scope
		@books = Book.jpub.top10
		render 'hello/list'
	end

	def def_scope
		render text: Review.all.inspect
	end

	def count
		cnt = Book.where(publish: '제이펍').count
		
		#cnt = Book.count
		#cnt = Book.count(:publish)
		#cnt = Book.distince.count(:publish)
		render text: "#{cnt}개입니다."
	end

	def average
		price = Book.where(publish: '제이펍').average(:price)
		render text: "평균 가격은 #{price}원입니다."
	end

	def literal_sql
		@books = Book.find_by_sql(['SELECT publish, AVG(price) AS avg_price FROM "books"
			GROUP BY publish HAVING AVG(price) >= ?', 2500])
		render 'record/groupby'
	end

	def update_all
		cnt = Book.where(publish: '한빛미디어').update_all(publish: '제이펍')
		render text: "#{cnt}개의 데이터를 업데이트했습니다."
	end

	def update_all2
		cnt = Book.order(:published).limit(5).update_all('price = price * 0.8')
		render text: "#{cnt}개의 데이터를 업데이트했습니다."
	end

	def destroy_all
		Book.destroy_all(['publish <> ?', '제이펍'])
		#Book.where('publish <> ?', '제이펍').destroy_all
		render text: '제거 완료'
	end

	def transact
			Book.transaction do
				b1 = Book.new({isbn: '978-4-7741-4223-0',
					title: 'Ruby 포켓 레퍼런스',
					price: 2000, publish: '제이펍', published: '2011-01-01'})
				b1.save!
				raise '예외 발생: 모든 처리를 취소합니다.'
				b2 = Book.new({isbn: '978-4-7741-4223-2',
					title: 'Tomcat 포켓 레퍼런스',
					price: 2500, publish: '제이펍', published: '2011-01-01'})
				b2.save!
			end
			render text: '트랜잭션에 성공했습니다.'
		rescue => e
			render text: e.message
	end
			
end
