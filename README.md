# TaskFlow - Intelligent Project Management

TaskFlow is a Flutter-based project management application that leverages Generative AI (Gemini & Llama 3) to automatically break down high-level project goals into actionable, scheduled tasks. It features a modern Monday.com-style interface, team collaboration, and real-time synchronization.

## 🩷 Architecture

The application follows a **Client-Server** architecture using **Riverpod** for state management and **Repository Pattern** for data handling.

+---------------------+           +---------------------+
| FRONTEND (Flutter)  | <------> | FIREBASE (Data/Auth)|
|   - UI Components   |          +---------------------+
|   - Riverpod State  |
+---------------------+
            |
            | (Request Plan)
            v
+---------------------+
| BACKEND (Python)    |
|   - Flask API       |
|   - Orchestrator    |
+---------------------+
        /     \
       v       v
+-------------+ +---------------------+
| GEMINI      | | GROQ (Llama 3)      |
| (Generator) | | (Auditor / Scorer)  |
+-------------+ +---------------------+

### System Components:
1.  **Frontend (Flutter):**
    * **UI Layer:** Interactive Dashboard, Timeline (Gantt) View, Monday Task View, Authentication, Generation and Settings screens.
    * **State Management:** Riverpod for reactive UI updates and dependency injection.
    * **Data Layer:** Repositories for Firestore interaction and Services for API communication.
2.  **Backend (Python Flask):**
    * **Orchestrator:** Handles requests from the mobile app.
    * **Generative AI:** Calls **Google Gemini 2.5 Flash** to generate project structures.
    * **Auditor:** Calls **Llama 3 (via Groq)** to validate and score the quality of Gemini's plans.
3.  **Database (Firebase):**
    * **Firestore:** Real-time NoSQL database storing Users, Projects, Groups, and Tasks.
    * **Authentication:** Firebase Auth for secure email/password login.


---

## 🩷 Services & APIs

### 1. Backend Service (`app.py`)
A lightweight Flask server acting as the AI Gateway.

* **Endpoint:** `POST /generate-plan`
    * **Input:** `{ "description": "Build a website", "strategy": "Fast" }`
    * **Process:**
        1.  Prompts **Gemini** to generate a JSON plan with phases, tasks, and offsets.
        2.  Sends the plan to **Groq (Llama 3)** to audit logic and feasibility.
        3.  If the audit score is < 80, it auto-heals (asks Gemini to fix specific issues - up to 2 times for efficiency).
    * **Output:** Returns the final Project Plan JSON + Audit Score + Feedback steps.

### 2. Firestore Database
* **Users:** `users/{uid}` (Stores profile details - Display Name, Email, Last Seen - & search history).
* **Projects:** `projects/{projectId}` (Stores metadata like owner & members, as well as Audit Details).
    * **Groups:** `projects/{id}/groups/{groupId}` (Phases like "Planning", "Dev" and their order).
        * **Tasks:** `.../tasks/{taskId}` (Individual items with dates, name, editors, state of the task).

---

## 🩷 Installation & Setup

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10+)
* [Python 3.9+](https://www.python.org/downloads/)
* [Docker](https://www.docker.com/) (Optional, for containerization)
* Firebase Project (with Firestore & Auth enabled)

### 1. Environment Variables
Create a `.env` file in the `services/` directory (or set them in your terminal) for the backend:

```bash
export GEMINI_API_KEY="your_gemini_key"
export GROQ_API_KEY="your_groq_key"
