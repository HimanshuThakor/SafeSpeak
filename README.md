# Tutorial: SafeSpeak

SafeSpeak is a **personal safety application** designed to provide *immediate help in emergency situations* and ensure a *safe communication environment*. It allows users to send **SOS alerts** to their trusted contacts with their location, features *real-time content monitoring* for harmful language, and enables users to report concerns, all while securely managing user accounts and facilitating *instant updates* and interactions.


## Visual Overview

```mermaid
flowchart TD
    A0["Data Models
"]
    A1["User & Authentication System
"]
    A2["Server & API Foundation
"]
    A3["External Communication & Utilities
"]
    A4["Emergency Services & Contacts
"]
    A5["Content Safety (Toxicity & Reports)
"]
    A6["Real-time Interactions (Socket.IO)
"]
    A2 -- "Connects to DB for" --> A0
    A1 -- "Manages user data in" --> A0
    A4 -- "Manages safety data in" --> A0
    A5 -- "Manages content data in" --> A0
    A2 -- "Exposes APIs for" --> A1
    A2 -- "Exposes APIs for" --> A4
    A2 -- "Exposes APIs for" --> A5
    A2 -- "Utilizes for responses" --> A3
    A1 -- "Sends notifications via" --> A3
    A4 -- "Dispatches alerts via" --> A3
    A5 -- "Integrates external AI with" --> A3
    A2 -- "Initializes" --> A6
    A1 -- "Emits login events to" --> A6
    A4 -- "Requires authentication from" --> A1
    A5 -- "Requires authentication from" --> A1
```

## Chapters

1. [Server & API Foundation
](01_server___api_foundation_.md)
2. [Data Models
](02_data_models_.md)
3. [External Communication & Utilities
](03_external_communication___utilities_.md)
4. [User & Authentication System
](04_user___authentication_system_.md)
5. [Emergency Services & Contacts
](05_emergency_services___contacts_.md)
6. [Content Safety (Toxicity & Reports)
](06_content_safety__toxicity___reports__.md)
7. [Real-time Interactions (Socket.IO)
](07_real_time_interactions__socket_io__.md)

---
