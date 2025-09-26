helm upgrade --install gravitino ./gravitino/gravitino -n data-service

helm upgrade --install airflow ./airflow -n data-service

helm upgrade --install trino ./trino -n data-service