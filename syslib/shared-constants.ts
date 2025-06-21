/**
 * Shared constants for multi-worker communication
 */

// SharedArrayBuffer layout offsets
export const FS_OFFSET_REQUEST_ID = 0;
export const FS_OFFSET_OP_TYPE = 1;
export const FS_OFFSET_STATUS = 2;
export const FS_OFFSET_DATA_LENGTH = 3;
export const FS_OFFSET_RESULT_CODE = 4;
export const FS_OFFSET_DATA_START = 5;

// FS Operation types
export const FS_OP_CREATE_DIRECTORY = 1;
export const FS_OP_DIRECTORY_EXISTS = 2;
export const FS_OP_LIST_DIRECTORY = 3;
export const FS_OP_DELETE_DIRECTORY = 4;
export const FS_OP_CREATE_FILE = 5;
export const FS_OP_READ_FILE = 6;
export const FS_OP_WRITE_FILE = 7;
export const FS_OP_DELETE_FILE = 8;
export const FS_OP_FILE_EXISTS = 9;
export const FS_OP_FILE_STAT = 10;

// FS Status codes
export const FS_STATUS_IDLE = 0;
export const FS_STATUS_PENDING = 1;
export const FS_STATUS_COMPLETED = 2;
export const FS_STATUS_ERROR = 3;