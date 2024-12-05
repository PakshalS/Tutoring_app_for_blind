const admin = require('firebase-admin');
const fs = require('fs');

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert('./config/firebasesettings.json'),
});

const db = admin.firestore();

async function exportFirestoreToJSON() {
  try {
    const collections = await db.listCollections(); // Get all collections
    let firestoreData = {};

    // Iterate over collections and fetch documents
    for (let collection of collections) {
      const snapshot = await collection.get();
      const docs = snapshot.docs.map(doc => {
        return { id: doc.id, data: doc.data() };  // Store document ID and data
      });
      firestoreData[collection.id] = docs;

      // Optionally: Check for subcollections within each document
      for (let doc of snapshot.docs) {
        const subcollections = await doc.ref.listCollections();
        for (let subcollection of subcollections) {
          const subSnapshot = await subcollection.get();
          const subDocs = subSnapshot.docs.map(subDoc => ({
            id: subDoc.id,
            data: subDoc.data(),
          }));
          firestoreData[`${collection.id}/${doc.id}/${subcollection.id}`] = subDocs;
        }
      }
    }

    // Write the exported data to a JSON file
    fs.writeFileSync('firestore_data.json', JSON.stringify(firestoreData, null, 2));
    console.log("Firestore data exported successfully.");
  } catch (error) {
    console.error("Error exporting Firestore data:", error);
  }
}

exportFirestoreToJSON();



