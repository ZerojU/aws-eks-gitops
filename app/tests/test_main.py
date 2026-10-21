from fastapi.testclient import TestClient
from pathlib import Path
from main import app
import pytest
import json

client = TestClient(app)

@pytest.mark.smoke
def test_health():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

@pytest.mark.smoke
def test_version():
    version_file = (
        Path(__file__).resolve().parents[1] / "version.json"
    )

    expected = json.loads(
        version_file.read_text(encoding="utf-8")
    )

    response = client.get("/version")

    assert response.status_code == 200
    assert response.json() == expected

@pytest.mark.functional
def test_orders():
    response = client.get("/api/orders")

    assert response.status_code == 200
    assert len(response.json()["orders"]) == 2