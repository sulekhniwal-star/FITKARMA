# Research Dimension: AI & Support (2025)

## 1. AI Coaching & Intelligent Features

| Feature | Market Standard (2025) | FitKarma Implementation |
|---------|------------------------|--------------------------|
| **Form Correction** | Computer Vision (CV) skeletal tracking via camera. | On-device Pose Detection (ML Kit) for Yoga and basic lifts to ensure 100% privacy and zero latency. |
| **Adaptive Programming** | Algorithms that adjust weights/reps based on volume. | "Karma-Adjust": AI modifies daily step/workout goals based on user fatigue, sleep scores, and Ayurvedic state (Vikriti). |
| **Dynamic Meal Planning** | Calorie-matched recipe generation. | "Ayur-Chef": AI generates meal suggestions using local Indian ingredients that pacify the user's specific Dosha imbalance. |
| **Recovery Analytics** | Oura/Whoop style recovery scores. | Integration with Health Connect/HealthKit to synthesize sleep, heart rate, and steps into a daily "Readiness" score. |

## 2. Integrated AI Chatbot: "Karma Buddy"

The AI Chatbot serves as a 24/7 wellness companion, handling health queries, logging data via natural language, and providing motivation.

### Key Capabilities:
- **NLP Logging**: "I just had 2 small rotis and a bowl of dal" -> Automatically logged to Hive.
- **Health Queries**: "Is my heart rate of 55 bpm normal during sleep?"
- **Ayurvedic Advice**: "What should I eat for breakfast to reduce Pitta today?"

## 3. Escalation Workflow: AI -> WhatsApp

To ensure user satisfaction and trust, the chatbot follows a strict escalation protocol when it fails to provide a helpful answer.

### Triggering Escalation:
1. **Explicit Request**: Keywords like "human help," "support," "talk to real person."
2. **Sentiment Analysis**: Detecting frustration, anger, or repeated unhelpful marks.
3. **Complexity Threshold**: Queries involving medical emergencies or high-stakes health advice where AI is restricted.
4. **Repeated Gaps**: If the AI responds with "I'm not sure" 2+ times in a single session.

### The Handoff (The "WhatsApp Bridge"):
- **Context Preservation**: The AI generates a 2-sentence summary of the conversation history.
- **Seamless Transition**: The app provides a one-tap button: `[Talk to Support on WhatsApp]`.
- **Deep Linking**: The button triggers a WhatsApp deep link: `https://wa.me/[FitKarma_Support_Number]?text=[Encoded_Context_Summary]`.
- **Backend Sync**: The escalation event is logged in PocketBase for the support team to track high-churn intent.

## 4. Technical Architecture for Chatbot
- **Local (Quick Action)**: Regex + Simple Intent Classification for logging (Offline).
- **Remote (Deep Logic)**: PocketBase + LLM (Sonnet/Gemini via API) for complex health coaching (Online).
- **History Management**: Conversation stored in a `chat_logs` Hive box for offline viewing.
