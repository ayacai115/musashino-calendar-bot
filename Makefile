start_local_db:
	docker-compose up

create_local_table:
	bundle exec ruby bootstrap/create_local_db.rb
