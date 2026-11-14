"""Scoring personnalise Azure ML pour un modele MLflow scikit-learn/skops."""

import json
import logging
import os
from pathlib import Path

import mlflow.sklearn
import numpy as np
import pandas as pd

MODEL = None


def init():
    """Charge le modele une seule fois; une erreur doit faire echouer l'init."""
    global MODEL
    model_root = Path(os.environ["AZUREML_MODEL_DIR"])
    candidates = list(model_root.rglob("MLmodel"))
    if len(candidates) != 1:
        raise RuntimeError(
            f"Expected one MLmodel under {model_root}, found {len(candidates)}"
        )

    model_dir = candidates[0].parent
    logging.info("Loading trusted registered MLflow/skops model from %s", model_dir)
    # MLflow lit le format skops et skops_trusted_types depuis MLmodel.
    MODEL = mlflow.sklearn.load_model(str(model_dir))
    logging.info("Model loaded: %s", type(MODEL).__name__)


def run(raw_data):
    """Accepte data/sample-request.json: {input_data:{columns:[...],data:[[...]]}}."""
    if MODEL is None:
        raise RuntimeError("Model not initialized")

    body = json.loads(raw_data) if isinstance(raw_data, str) else raw_data
    if isinstance(body, str):
        body = json.loads(body)
    if not isinstance(body, dict):
        raise ValueError("Expected a JSON object")

    data = body.get("input_data", body)
    if not isinstance(data, dict) or "columns" not in data or "data" not in data:
        raise ValueError("Expected input_data containing columns and data")

    frame = pd.DataFrame(data["data"], columns=data["columns"])
    if frame.empty:
        raise ValueError("Prediction input must contain at least one row")

    predictions = MODEL.predict(frame)
    return {"predictions": np.asarray(predictions).tolist()}
