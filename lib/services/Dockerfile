FROM python:3.11-slim

WORKDIR /app

COPY . .

#dependencies
RUN pip install -r requirements.txt

#port
EXPOSE 5000

CMD ["python", "app.py"]
