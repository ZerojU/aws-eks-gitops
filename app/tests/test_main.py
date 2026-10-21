from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_version():
    response = client.get("/version")

    assert response.status_code == 200
    assert response.json() == {"version": "v1.0"}


def test_orders():
    response = client.get("/api/orders")

    assert response.status_code == 200
    assert len(response.json()["orders"]) == 2