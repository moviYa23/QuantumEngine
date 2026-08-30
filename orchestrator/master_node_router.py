"""
Master Node Router (esqueleto).
- Recibe un prompt/intent desde frontend.
- Identifica intención (usando un LLM).
- Enruta a nodos especializados (HTTP API calls).
- Devuelve una respuesta unificada.
"""
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import httpx
import os

app = FastAPI()

# Configurables: URLS internas de los microservicios dentro de docker-compose
ECOM_URL = os.getenv("ECOMMERCE_URL", "http://ecommerce:8001")
LOGI_URL = os.getenv("LOGISTICS_URL", "http://logistics:8002")
FIN_URL = os.getenv("FINANCE_URL", "http://finance:8003")

class PromptRequest(BaseModel):
    user_id: str
    prompt: str

@app.post("/route")
async def route_prompt(req: PromptRequest):
    # 1) Llamada placeholder a LLM para clasificar intención
    # (aquí integrarías OpenAI/otro LLM)
    intent = classify_intent(req.prompt)

    # 2) Enrutar según intención
    if intent == "search_product":
        async with httpx.AsyncClient() as client:
            r = await client.post(f"{ECOM_URL}/search", json={"query": req.prompt})
            return r.json()
    elif intent == "request_delivery_quote":
        async with httpx.AsyncClient() as client:
            r = await client.post(f"{LOGI_URL}/quote", json={"prompt": req.prompt})
            return r.json()
    elif intent == "process_payment":
        async with httpx.AsyncClient() as client:
            r = await client.post(f"{FIN_URL}/pay", json={"user_id": req.user_id, "prompt": req.prompt})
            return r.json()
    else:
        # 3) Si la intención requiere un nodo no disponible:
        # - publicar alerta en el registro de módulos o abrir issue PR auto
        raise HTTPException(status_code=404, detail=f"No worker node available for intent: {intent}")

def classify_intent(prompt: str) -> str:
    # Implementación inicial: reglas simples o llamada a un LLM.
    text = prompt.lower()
    if "comprar" in text or "precio" in text:
        return "search_product"
    if "entrega" in text or "llegar" in text:
        return "request_delivery_quote"
    if "pagar" in text or "comprar ahora" in text:
        return "process_payment"
    return "unknown"
