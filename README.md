# MoviYa / Moviyang V2.0

Visión
------
MoviYa es una plataforma integradora de e-commerce + logística orquestada por una malla de agentes IA, monetizada mediante comisiones dinámicas y recompensas tokenizadas.

Arquitectura
-----------
- Frontend: Next.js (SSR), PWA, diseño dark-mode por defecto.
- Orquestador: Python (FastAPI). Master Node Router.
- Microservicios de alto rendimiento: Go (E-commerce, Logistics, Finance).
- DB: PostgreSQL + Redis.
- Blockchain: Smart Contracts (Solidity) en EVM para rewards y revenue sharing.
- Contenedores: Docker + docker-compose (arranque local).

Cómo levantar el entorno (desarrollo local)
------------------------------------------
1. Clona el repo:
   git clone git@github.com:moviYa23/QuantumEngine.git
2. Copia el .env.example a .env y ajusta variables (DB, claves de APIs, RPC de blockchain).
3. Levanta los contenedores:
   docker-compose up --build
4. Frontend disponible en http://localhost:3000

Puntos técnicos clave
---------------------
- Tarifa dinámica: function CalculateDynamicFee(productPrice, savedAmount, daysSaved, vipLevel)
- Master Node Router: punto único para interpretación de intención y delegación a workers.
- Recompensas: MoviyangToken.sol -> mintForPurchase() es llamada por backend al confirmar compra.
- Pasarela: integrar Binance Pay SDK en el microservicio Finance.

Contribuir
---------
- Fork -> branch feature/<tu-feature> -> PR.
- Recompensas: cada PR con tests y uso real podrá ser auditado y compensado mediante el contrato de revenue sharing (documentado en /contracts/README.md).

Licencia
--------
MIT
