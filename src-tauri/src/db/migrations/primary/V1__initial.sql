CREATE TABLE IF NOT EXISTS libraries (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	remote_id TEXT,
	is_primary BOOLEAN NOT NULL DEFAULT TRUE,
	encryption INTEGER NOT NULL DEFAULT 0,
	total_file_count INTEGER NOT NULL DEFAULT "0",
	total_bytes_used TEXT NOT NULL DEFAULT "0",
	total_byte_capacity TEXT NOT NULL DEFAULT "0",
	total_unique_bytes TEXT NOT NULL DEFAULT "0",
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	timezone TEXT
);
CREATE TABLE IF NOT EXISTS spaces (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	encryption INTEGER DEFAULT 0,
	library_id TEXT NOT NULL,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	date_modified DATE NOT NULL DEFAULT (datetime('now')),
	FOREIGN KEY(library_id) REFERENCES libraries(id)
);
CREATE TABLE IF NOT EXISTS files (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	uri TEXT NOT NULL,
	meta_checksum TEXT NOT NULL UNIQUE,
	buffer_checksum TEXT,
	name TEXT,
	extension TEXT,
	size_in_bytes TEXT NOT NULL,
	encryption INTEGER NOT NULL DEFAULT 0,
	ipfs_id TEXT,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	date_modified DATE NOT NULL DEFAULT (datetime('now')),
	date_indexed DATE NOT NULL DEFAULT (datetime('now')),
	library_id INTEGER NOT NULL,
	storage_device_id INTEGER,
	directory_id INTEGER,
	capture_device_id INTEGER,
	parent_file_id INTEGER,
	FOREIGN KEY(library_id) REFERENCES libraries(id),
	FOREIGN KEY(directory_id) REFERENCES directories(id),
	FOREIGN KEY(parent_file_id) REFERENCES files(id),
	FOREIGN KEY(storage_device_id) REFERENCES storage_devices(id),
	FOREIGN KEY(capture_device_id) REFERENCES capture_devices(id)
);
CREATE TABLE IF NOT EXISTS directories (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	uri TEXT NOT NULL,
	watch BOOLEAN NOT NULL DEFAULT FALSE,
	encryption INTEGER DEFAULT 0,
	calculated_size_in_bytes TEXT DEFAULT "0",
	calculated_file_count INTEGER DEFAULT 0,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	date_modified DATE NOT NULL DEFAULT (datetime('now')),
	date_indexed DATE NOT NULL DEFAULT (datetime('now')),
	library_id INTEGER NOT NULL,
	storage_device_id INTEGER,
	parent_directory_id INTEGER,
	FOREIGN KEY(library_id) REFERENCES libraries(id),
	FOREIGN KEY(parent_directory_id) REFERENCES directories(id),
	FOREIGN KEY(storage_device_id) REFERENCES storage_devices(id)
);
CREATE TABLE IF NOT EXISTS tags (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	encryption INTEGER DEFAULT 0,
	total_files INTEGER DEFAULT 0,
	redundancy_goal INTEGER default 1,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	date_modified DATE NOT NULL DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS tags_files (
	tag_id INTEGER NOT NULL,
	file_id INTEGER NOT NULL,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	FOREIGN KEY(tag_id) REFERENCES tags(id),
	FOREIGN KEY(file_id) REFERENCES files(id)
);
CREATE TABLE IF NOT EXISTS tags_directories (
	tag_id INTEGER NOT NULL,
	directory_id INTEGER NOT NULL,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	FOREIGN KEY(tag_id) REFERENCES tags(id),
	FOREIGN KEY(directory_id) REFERENCES files(id)
);
CREATE TABLE IF NOT EXISTS storage_devices (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	date_modified DATE NOT NULL DEFAULT (datetime('now'))
);
CREATE TABLE IF NOT EXISTS capture_devices (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	date_created DATE NOT NULL DEFAULT (datetime('now')),
	date_modified DATE NOT NULL DEFAULT (datetime('now'))
);