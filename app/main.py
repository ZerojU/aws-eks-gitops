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
        """
        orders = [
            {"id": 1, "item": "keyboard"},
            {"id": 2, "item": "mouse"},
        ]

        logger.info("Orders retrieved successfully")

        return {"orders": orders}
        """

        # v1.1 장애 재현:
        # 존재하지 않는 필드를 참조하는 코드 오류
        order = {"id": 1, "item": "keyboard"}

        result = {
            "id": order["id"],
            "item": order["product_name"],
        }

        return {"orders": [result]}

    except Exception:
        logger.exception("Failed to retrieve orders")
        raise HTTPException(
            status_code=500,
            detail="Internal server error"
        )