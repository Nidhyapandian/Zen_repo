#choosing the base image:
FROM python:3.8-alpine

#choosing working directory for the application:
WORKDIR /app

#copying the requirements.txt file to app directory and installing packages:
COPY requirements.txt .
RUN pip3 install -r requirements.txt

#copying the rest of application code to the working directory:
COPY . .

#exposing the application:
EXPOSE 5000

#Executing the application after creating image:
CMD ["python3","-m","flask","run","--host=0.0.0.0"]
