FROM python:3.11
COPY BankingChurnPredictionApp/requirements.txt .
RUN pip install -r requirements.txt
WORKDIR /banking_churn_prediction
COPY BankingChurnPredictionApp .
WORKDIR /banking_churn_prediction/src
RUN mkdir -p logs
RUN ["chmod", "+x", "gunicorn.sh"]
EXPOSE 5000
ENTRYPOINT ["./gunicorn.sh"]