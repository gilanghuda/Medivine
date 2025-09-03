const String prompt = """
PROMPT TEMPLATE FOR GEMINI AI - MEDICAL ORAL ANALYSIS /n

=== INSTRUCTION ===
Analyze the uploaded oral/mouth image and provide a structured medical analysis response. You must respond in EXACT JSON format as specified below. Only analyze oral health conditions visible in the image.

=== REQUIRED JSON RESPONSE FORMAT ===
{
  "primary_diagnosis": {
    "name": "[Primary condition name in Indonesian]",
    "accuracy": "[Percentage number only, e.g., 93]",
    "description": "[Brief description in Indonesian, max 150 characters]"
  },
  "all_detections": [
    {
      "condition": "[Condition name in Indonesian with medical term in parentheses]",
      "percentage": "[Detection percentage, e.g., 93]"
    },
    {
      "condition": "[Secondary condition if any]",
      "percentage": "[Detection percentage, e.g., 3]"
    }
  ],
  "symptoms": [
    "[Symptom 1 in Indonesian, detailed description]",
    "[Symptom 2 in Indonesian, detailed description]"
  ],
  "recommendations": [
    "[Recommendation 1 in Indonesian]",
    "[Recommendation 2 in Indonesian]"
  ]
}

=== EXAMPLE EXPECTED OUTPUT ===
{
  "primary_diagnosis": {
    "name": "Sariawan",
    "accuracy": "93",
    "description": "Anda diduga memiliki sariawan yang disebabkan oleh virus. Disarankan untuk menjaga kebersihan mulut dan menghindari makanan pedas hingga kondisi membaik."
  },
  "all_detections": [
    {
      "condition": "Sariawan (Ulkus Aftosa)",
      "percentage": "93"
    },
    {
      "condition": "Herpes Simpleks (HSV-1 / HSV-2)",
      "percentage": "3"
    }
  ],
  "symptoms": [
    "Luka berwarna putih (chancre) di bibir atau mulut",
    "Timbul plak putih di bibir atau pangkal lidah, kadang menjalar hingga sisi samping lidah"
  ],
  "recommendations": [
    "Jaga kebersihan mulut",
    "Hindari konsumsi makanan pedas"
  ]
}

=== SPECIFIC REQUIREMENTS ===
1. Use Indonesian language for all text
2. Accuracy must be a realistic percentage (70-95% range)
3. Include medical terms in parentheses where appropriate
4. Keep descriptions concise but informative
5. Provide 2-4 symptoms maximum
6. Provide 2-3 recommendations maximum
7. Only detect conditions actually visible in the image
8. Be conservative with diagnosis - prefer common conditions
9. Always include uncertainty/consultation disclaimer in app

=== COMMON ORAL CONDITIONS TO DETECT ===
- Sariawan (Ulkus Aftosa)
- Herpes Simpleks (HSV-1/HSV-2)
- Kandidiasis Oral (Oral Thrush)
- Gingivitis
- Periodontitis
- Leukoplakia
- Stomatitis
- Cheilitis

=== PROMPT TO USE ===
"Please analyze this oral/mouth image for any visible health conditions. Provide your analysis in the exact JSON format specified above. Focus on common oral conditions and provide realistic accuracy percentages. Use Indonesian language and include medical terminology in parentheses where appropriate." 
""";
