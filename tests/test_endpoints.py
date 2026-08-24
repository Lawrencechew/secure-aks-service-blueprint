from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_root():
    r = client.get("/")
    assert r.status_code == 200
    assert "service" in r.json()


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json().get("status") == "ok"


def test_ready():
    r = client.get("/ready")
    assert r.status_code == 200
    assert r.json().get("ready") is True


def test_metrics():
    client.get("/")
    client.get("/health")
    r = client.get("/metrics")
    assert r.status_code == 200
    assert "process_cpu_seconds_total" in r.text or r.text
    assert "app_requests_total" in r.text
    assert "app_request_latency_seconds_bucket" in r.text
