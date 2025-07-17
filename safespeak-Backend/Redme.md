# Tutorial: SafeSpeak

SafeSpeak is a **personal safety application** designed to provide immediate help in _emergency situations_ and ensure a _safe communication environment_. It allows users to send **SOS alerts** to their trusted contacts with their location, features _real-time content monitoring_ for harmful language, and enables users to report concerns. The app securely manages user accounts and facilitates _instant updates_ and interactions.

## Visual Overview

```mermaid
flowchart TD
    A0["Server & API Foundation
"]
    A1["User & Authentication System
"]
    A2["Data Models
"]
    A3["Emergency Services & Contacts
"]
    A4["Content Safety (Toxicity & Reports)
"]
    A5["External Communication & Utilities
"]
    A6["Real-time Interactions (Socket.IO)
"]
    A0 -- "Initializes Real-time System" --> A6
    A0 -- "Exposes Auth APIs" --> A1
    A0 -- "Exposes Emergency APIs" --> A3
    A0 -- "Exposes Content APIs" --> A4
    A1 -- "Manages User Data" --> A2
    A1 -- "Utilizes External Services" --> A5
    A1 -- "Emits Events" --> A6
    A3 -- "Manages Safety Data" --> A2
    A3 -- "Sends Notifications" --> A5
    A4 -- "Manages Report Data" --> A2
    A4 -- "Calls External Services" --> A5
```

## Chapters

1. [Data Models
   ](01_data_models_.md)
2. [User & Authentication System
   ](02_user___authentication_system_.md)
3. [External Communication & Utilities
   ](03_external_communication___utilities_.md)
4. [Emergency Services & Contacts
   ](04_emergency_services___contacts_.md)
5. [Content Safety (Toxicity & Reports)
   ](05_content_safety__toxicity___reports__.md)
6. [Server & API Foundation
   ](06_server___api_foundation_.md)
7. [Real-time Interactions (Socket.IO)
   ](07_real_time_interactions__socket_io__.md)

---
