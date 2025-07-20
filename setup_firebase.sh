#!/bin/bash

echo "🔥 Setting up Firebase services for Personal Gallery..."

# Enable Firestore
echo "📊 Setting up Firestore Database..."
firebase firestore:databases:create --project=personal-gallery-72e88

# Set up Firestore rules
echo "🔒 Setting up Firestore security rules..."
cat > firestore.rules << 'EOF'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /gallery_images/{document} {
      allow read, write: if true; // For demo - add authentication later
    }
  }
}
EOF

firebase deploy --only firestore:rules --project=personal-gallery-72e88

# Set up Storage rules
echo "📁 Setting up Storage security rules..."
cat > storage.rules << 'EOF'
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /images/{allPaths=**} {
      allow read, write: if true; // For demo - add authentication later
    }
  }
}
EOF

firebase deploy --only storage --project=personal-gallery-72e88

echo "✅ Firebase setup complete!"
echo "🚀 Your app is now connected to real Firebase!"
