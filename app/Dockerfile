FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ARG GIT_COMMIT=unknown

COPY main.py version.json ./

RUN python -c "import json; p='version.json'; d=json.load(open(p)); d['commit']='${GIT_COMMIT}'; open(p,'w').write(json.dumps(d))"

# 고정 UID/GID를 가진 비루트 사용자 생성
RUN groupadd --gid 10001 appgroup \
    && useradd \
        --uid 10001 \
        --gid 10001 \
        --create-home \
        --shell /usr/sbin/nologin \
        appuser

# 실행 사용자 명시
USER 10001:10001

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]