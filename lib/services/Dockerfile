FROM python:3.11-slim

WORKDIR /app

COPY . .

#Install dependencies
RUN pip install -r requirements.txt

#Port
EXPOSE 5000

CMD ["python", "app.py"]
