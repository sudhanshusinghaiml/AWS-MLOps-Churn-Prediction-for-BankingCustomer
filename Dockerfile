FROM python
COPY requirements.txt .
RUN pip install -r requirements.txt
WORKDIR /banking_churn_prediction
COPY . .
WORKDIR /banking_churn_prediction/src
RUN mkdir -p logs
RUN ["chmod", "+x", "gunicorn.sh"]
EXPOSE 5000
ENTRYPOINT ["./gunicorn.sh"]