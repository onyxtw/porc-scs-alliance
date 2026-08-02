# PoRC‑SCS Verifier API Specification

## Endpoints (Conceptual)

- POST /verify-node
  - Input: PoRC JSON Schema-compliant payload
  - Output: PoRC Index score + compliance status

- GET /node/:id
  - Returns latest verified metrics and certification status.

## Payload Format

- Must conform to schema/porc_index.schema.json
- Includes compute, thermal, resilience metrics and node metadata.
