#FROM python:3.11-slim

#WORKDIR /app

#COPY . .

#dependencies
#RUN pip install -r requirements.txt

#port
#EXPOSE 5000

#CMD ["python", "app.py"]

#------------------------------------------------

#Build the Python environment
FROM python:3.11-slim as build

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

#Final image
FROM python:3.11-slim

WORKDIR /app
COPY --from=build /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]