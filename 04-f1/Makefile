.PHONY: update relax db db-down db-reset

update:
	python3 scripts/update_data.py

relax:
	python3 scripts/export_relax.py

db:
	docker-compose up --build -d

db-down:
	docker-compose down

db-reset:
	docker-compose down -v
	docker-compose up --build -d
