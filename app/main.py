import logging
import os

from fastapi import FastAPI, HTTPException

app = FastAPI(title="EKS GitOps project")

VERSION = os.getenv("APP_VERSION", "v1.0")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("project-app")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/version")
def version():
    return {"version": VERSION}


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