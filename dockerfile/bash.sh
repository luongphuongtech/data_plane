# build and push trino image with tag 460
docker build -t phuonln/trino-custom-150:460 -f Dockerfile.trino  .
docker push phuonln/trino-custom-150:460

# build and push airflow image w
docker build -t phuonln/airflow-custome-oauth2-25:latest -f Dockerfile.airflow  .
docker push phuonln/airflow-custome-oauth2-25:latest

# build and push gravitino image with plugins
docker build -t phuonln/gravitino-custome-oauth2-25:latest -f Dockerfile.gravitino .
docker push phuonln/gravitino-custome-oauth2-25:latest
