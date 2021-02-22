start_local_db:
	docker-compose up -d
	bundle exec ruby app/lambda/scraper_function.rb