import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues

class LocalDatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_NAME = "CallRecordDB"
        private const val DATABASE_VERSION = 1
        private const val TABLE_NAME = "call_records"
        private const val COLUMN_ID = "id"
        private const val COLUMN_JSON = "json_data"
    }

    override fun onCreate(db: SQLiteDatabase?) {
        val createTable = "CREATE TABLE $TABLE_NAME ($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_JSON TEXT)"
        db?.execSQL(createTable)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        db?.execSQL("DROP TABLE IF EXISTS $TABLE_NAME")
        onCreate(db)
    }

    fun insertCallRecord(jsonString: String) {
        val db = writableDatabase
        val contentValues = ContentValues()
        contentValues.put(COLUMN_JSON, jsonString)
        db.insert(TABLE_NAME, null, contentValues)
        db.close()
    }

    fun getAllCallRecords(): List<String> {
        val db = readableDatabase
        val cursor = db.rawQuery("SELECT * FROM $TABLE_NAME", null)
        val records = mutableListOf<String>()
        if (cursor.moveToFirst()) {
            do {
                val jsonData = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_JSON))
                records.add(jsonData)
            } while (cursor.moveToNext())
        }
        cursor.close()
        db.close()
        return records
    }

    fun clearCallRecords() {
        val db = writableDatabase
        db.execSQL("DELETE FROM $TABLE_NAME")
        db.close()
    }
}
