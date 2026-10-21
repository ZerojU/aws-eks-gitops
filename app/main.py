import logging
import json
from fastapi import FastAPI, HTTPException
from pathlib import Path

app = FastAPI(title="EKS GitOps project")

VERSION_INFO = json.loads(
    (Path(__file__).resolve().parent / "version.json")
    .read_text(encoding="utf-8")
)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("project-app")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/version")
def version():
    return VERSION_INFO


@app.get("/api/orders")
def get_orders():
    try:
        orders = [
            {"id": 1, "item": "keyboard"},
            {"id": 2, "item": "mouse"},
        ]

        logger.info("Orders retrieved successfully")

        return {"orders": orders}

    except Exception:
        logger.exception("Failed to retrieve orders")
        raise HTTPException(
            status_code=500,
            detail="Internal server error"
        )