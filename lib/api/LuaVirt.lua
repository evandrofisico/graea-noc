require('luarocks.loader')
local ffi = require("ffi")

local ffi = require("ffi")
ffi.cdef[[
typedef void (*virFreeCallback)(void *opaque);
typedef struct _virConnect virConnect;
typedef virConnect *virConnectPtr;
typedef struct _virDomain virDomain;
typedef virDomain *virDomainPtr;
typedef enum {
    VIR_DOMAIN_NOSTATE = 0,    
    VIR_DOMAIN_RUNNING = 1,    
    VIR_DOMAIN_BLOCKED = 2,    
    VIR_DOMAIN_PAUSED  = 3,    
    VIR_DOMAIN_SHUTDOWN= 4,    
    VIR_DOMAIN_SHUTOFF = 5,    
    VIR_DOMAIN_CRASHED = 6,    
    VIR_DOMAIN_PMSUSPENDED = 7,
} virDomainState;

typedef enum {
    VIR_DOMAIN_NOSTATE_UNKNOWN = 0,
    VIR_DOMAIN_NOSTATE_LAST
} virDomainNostateReason;

typedef enum {
    VIR_DOMAIN_RUNNING_UNKNOWN = 0,
    VIR_DOMAIN_RUNNING_BOOTED = 1,          
    VIR_DOMAIN_RUNNING_MIGRATED = 2,        
    VIR_DOMAIN_RUNNING_RESTORED = 3,        
    VIR_DOMAIN_RUNNING_FROM_SNAPSHOT = 4,   
    VIR_DOMAIN_RUNNING_UNPAUSED = 5,        
    VIR_DOMAIN_RUNNING_MIGRATION_CANCELED = 6, 
    VIR_DOMAIN_RUNNING_SAVE_CANCELED = 7,   
    VIR_DOMAIN_RUNNING_WAKEUP = 8,          
    VIR_DOMAIN_RUNNING_CRASHED = 9,         
    VIR_DOMAIN_RUNNING_LAST
} virDomainRunningReason;

typedef enum {
    VIR_DOMAIN_BLOCKED_UNKNOWN = 0,     /* the reason is unknown */
    VIR_DOMAIN_BLOCKED_LAST
} virDomainBlockedReason;

typedef enum {
    VIR_DOMAIN_PAUSED_UNKNOWN = 0,      /* the reason is unknown */
    VIR_DOMAIN_PAUSED_USER = 1,         /* paused on user request */
    VIR_DOMAIN_PAUSED_MIGRATION = 2,    /* paused for offline migration */
    VIR_DOMAIN_PAUSED_SAVE = 3,         /* paused for save */
    VIR_DOMAIN_PAUSED_DUMP = 4,         /* paused for offline core dump */
    VIR_DOMAIN_PAUSED_IOERROR = 5,      /* paused due to a disk I/O error */
    VIR_DOMAIN_PAUSED_WATCHDOG = 6,     /* paused due to a watchdog event */
    VIR_DOMAIN_PAUSED_FROM_SNAPSHOT = 7, /* paused after restoring from snapshot */
    VIR_DOMAIN_PAUSED_SHUTTING_DOWN = 8, /* paused during shutdown process */
    VIR_DOMAIN_PAUSED_SNAPSHOT = 9,      /* paused while creating a snapshot */
    VIR_DOMAIN_PAUSED_CRASHED = 10,     /* paused due to a guest crash */
    VIR_DOMAIN_PAUSED_LAST
} virDomainPausedReason;

typedef enum {
    VIR_DOMAIN_SHUTDOWN_UNKNOWN = 0,    /* the reason is unknown */
    VIR_DOMAIN_SHUTDOWN_USER = 1,       /* shutting down on user request */

    VIR_DOMAIN_SHUTDOWN_LAST
} virDomainShutdownReason;

typedef enum {
    VIR_DOMAIN_SHUTOFF_UNKNOWN = 0,     /* the reason is unknown */
    VIR_DOMAIN_SHUTOFF_SHUTDOWN = 1,    /* normal shutdown */
    VIR_DOMAIN_SHUTOFF_DESTROYED = 2,   /* forced poweroff */
    VIR_DOMAIN_SHUTOFF_CRASHED = 3,     /* domain crashed */
    VIR_DOMAIN_SHUTOFF_MIGRATED = 4,    /* migrated to another host */
    VIR_DOMAIN_SHUTOFF_SAVED = 5,       /* saved to a file */
    VIR_DOMAIN_SHUTOFF_FAILED = 6,      /* domain failed to start */
    VIR_DOMAIN_SHUTOFF_FROM_SNAPSHOT = 7, /* restored from a snapshot which was
    VIR_DOMAIN_SHUTOFF_LAST
} virDomainShutoffReason;

typedef enum {
    VIR_DOMAIN_CRASHED_UNKNOWN = 0,     /* crashed for unknown reason */
    VIR_DOMAIN_CRASHED_PANICKED = 1,    /* domain panicked */
    VIR_DOMAIN_CRASHED_LAST
} virDomainCrashedReason;

typedef enum {
    VIR_DOMAIN_PMSUSPENDED_UNKNOWN = 0,
    VIR_DOMAIN_PMSUSPENDED_LAST
} virDomainPMSuspendedReason;

typedef enum {
    VIR_DOMAIN_PMSUSPENDED_DISK_UNKNOWN = 0,
    VIR_DOMAIN_PMSUSPENDED_DISK_LAST
} virDomainPMSuspendedDiskReason;

typedef enum {
    VIR_DOMAIN_CONTROL_OK = 0,       
    VIR_DOMAIN_CONTROL_JOB = 1,      
    VIR_DOMAIN_CONTROL_OCCUPIED = 2, 
    VIR_DOMAIN_CONTROL_ERROR = 3,    
    VIR_DOMAIN_CONTROL_LAST
} virDomainControlState;

typedef struct _virDomainControlInfo virDomainControlInfo;
struct _virDomainControlInfo {
    unsigned int state;     	    
    unsigned int details;   	    
    unsigned long long stateTime;   
};

typedef virDomainControlInfo *virDomainControlInfoPtr;

typedef enum {
    VIR_DOMAIN_AFFECT_CURRENT = 0,      /* Affect current domain state.  */
    VIR_DOMAIN_AFFECT_LIVE    = 1 << 0, /* Affect running domain state.  */
    VIR_DOMAIN_AFFECT_CONFIG  = 1 << 1, /* Affect persistent domain state.  */
} virDomainModificationImpact;


typedef struct _virDomainInfo virDomainInfo;

struct _virDomainInfo {
    unsigned char state;        /* the running state, one of virDomainState */
    unsigned long maxMem;       /* the maximum memory in KBytes allowed */
    unsigned long memory;       /* the memory in KBytes used by the domain */
    unsigned short nrVirtCpu;   /* the number of virtual CPUs for the domain */
    unsigned long long cpuTime; /* the CPU time used in nanoseconds */
};

typedef virDomainInfo *virDomainInfoPtr;

typedef enum {
    VIR_DOMAIN_NONE               = 0,      /* Default behavior */
    VIR_DOMAIN_START_PAUSED       = 1 << 0, /* Launch guest in paused state */
    VIR_DOMAIN_START_AUTODESTROY  = 1 << 1, /* Automatically kill guest when virConnectPtr is closed */
    VIR_DOMAIN_START_BYPASS_CACHE = 1 << 2, /* Avoid file system cache pollution */
    VIR_DOMAIN_START_FORCE_BOOT   = 1 << 3, /* Boot, discarding any managed save */
} virDomainCreateFlags;

typedef enum {
    VIR_NODE_SUSPEND_TARGET_MEM     = 0,
    VIR_NODE_SUSPEND_TARGET_DISK    = 1,
    VIR_NODE_SUSPEND_TARGET_HYBRID  = 2,
    VIR_NODE_SUSPEND_TARGET_LAST /* This constant is subject to change */
} virNodeSuspendTarget;

typedef struct _virStream virStream;

typedef virStream *virStreamPtr;

typedef struct _virSecurityLabel {
    char label[4097];    /* security label string */
    int enforcing;                            /* 1 if security policy is being enforced for domain */
} virSecurityLabel;

typedef virSecurityLabel *virSecurityLabelPtr;


typedef struct _virSecurityModel {
    char model[257];      /* security model string */
    char doi[257];          /* domain of interpetation */
} virSecurityModel;

typedef virSecurityModel *virSecurityModelPtr;

typedef enum {
    VIR_TYPED_PARAM_INT     = 1, /* integer case */
    VIR_TYPED_PARAM_UINT    = 2, /* unsigned integer case */
    VIR_TYPED_PARAM_LLONG   = 3, /* long long case */
    VIR_TYPED_PARAM_ULLONG  = 4, /* unsigned long long case */
    VIR_TYPED_PARAM_DOUBLE  = 5, /* double case */
    VIR_TYPED_PARAM_BOOLEAN = 6, /* boolean(character) case */
    VIR_TYPED_PARAM_STRING  = 7, /* string case */
    VIR_TYPED_PARAM_LAST
} virTypedParameterType;

typedef enum {
    VIR_TYPED_PARAM_STRING_OKAY = 1 << 2,
} virTypedParameterFlags;

typedef struct _virTypedParameter virTypedParameter;
struct _virTypedParameter {
    char field[80];  /* parameter name */
    int type;   /* parameter type, virTypedParameterType */
    union {
        int i;                      /* type is INT */
        unsigned int ui;            /* type is UINT */
        long long int l;            /* type is LLONG */
        unsigned long long int ul;  /* type is ULLONG */
        double d;                   /* type is DOUBLE */
        char b;                     /* type is BOOLEAN */
        char *s;                    /* type is STRING, may not be NULL */
    } value; /* parameter value */
};

typedef virTypedParameter *virTypedParameterPtr;


virTypedParameterPtr
virTypedParamsGet       (virTypedParameterPtr params,
                         int nparams,
                         const char *name);
int
virTypedParamsGetInt    (virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         int *value);
int
virTypedParamsGetUInt   (virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         unsigned int *value);
int
virTypedParamsGetLLong  (virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         long long *value);
int
virTypedParamsGetULLong (virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         unsigned long long *value);
int
virTypedParamsGetDouble (virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         double *value);
int
virTypedParamsGetBoolean(virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         int *value);
int
virTypedParamsGetString (virTypedParameterPtr params,
                         int nparams,
                         const char *name,
                         const char **value);
int
virTypedParamsAddInt    (virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         int value);
int
virTypedParamsAddUInt   (virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         unsigned int value);
int
virTypedParamsAddLLong  (virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         long long value);
int
virTypedParamsAddULLong (virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         unsigned long long value);
int
virTypedParamsAddDouble (virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         double value);
int
virTypedParamsAddBoolean(virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         int value);
int
virTypedParamsAddString (virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         const char *value);
int
virTypedParamsAddFromString(virTypedParameterPtr *params,
                         int *nparams,
                         int *maxparams,
                         const char *name,
                         int type,
                         const char *value);
void
virTypedParamsClear     (virTypedParameterPtr params,
                         int nparams);
void
virTypedParamsFree      (virTypedParameterPtr params,
                         int nparams);



typedef struct _virNodeInfo virNodeInfo;

struct _virNodeInfo {
    char model[32];       /* string indicating the CPU model */
    unsigned long memory; /* memory size in kilobytes */
    unsigned int cpus;    /* the number of active CPUs */
    unsigned int mhz;     /* expected CPU frequency */
    unsigned int nodes;   /* the number of NUMA cell, 1 for unusual NUMA
                             topologies or uniform memory access; check
                             capabilities XML for the actual NUMA topology */
    unsigned int sockets; /* number of CPU sockets per node if nodes > 1,
                             1 in case of unusual NUMA topology */
    unsigned int cores;   /* number of cores per socket, total number of
                             processors in case of unusual NUMA topology*/
    unsigned int threads; /* number of threads per core, 1 in case of
                             unusual numa topology */
};

typedef enum {
    VIR_NODE_CPU_STATS_ALL_CPUS = -1,
} virNodeGetCPUStatsAllCPUs;

typedef struct _virNodeCPUStats virNodeCPUStats;

struct _virNodeCPUStats {
    char field[80];
    unsigned long long value;
};

typedef enum {
    VIR_NODE_MEMORY_STATS_ALL_CELLS = -1,
} virNodeGetMemoryStatsAllCells;

typedef struct _virNodeMemoryStats virNodeMemoryStats;

struct _virNodeMemoryStats {
    char field[80];
    unsigned long long value;
};

int virNodeGetMemoryParameters(virConnectPtr conn,
                               virTypedParameterPtr params,
                               int *nparams,
                               unsigned int flags);

int virNodeSetMemoryParameters(virConnectPtr conn,
                               virTypedParameterPtr params,
                               int nparams,
                               unsigned int flags);

int virNodeGetCPUMap(virConnectPtr conn,
                     unsigned char **cpumap,
                     unsigned int *online,
                     unsigned int flags);



int     virDomainGetSchedulerParameters (virDomainPtr domain,
                                         virTypedParameterPtr params,
                                         int *nparams);
int     virDomainGetSchedulerParametersFlags (virDomainPtr domain,
                                              virTypedParameterPtr params,
                                              int *nparams,
                                              unsigned int flags);

int     virDomainSetSchedulerParameters (virDomainPtr domain,
                                         virTypedParameterPtr params,
                                         int nparams);
int     virDomainSetSchedulerParametersFlags (virDomainPtr domain,
                                              virTypedParameterPtr params,
                                              int nparams,
                                              unsigned int flags);

typedef struct _virDomainBlockStats virDomainBlockStatsStruct;

struct _virDomainBlockStats {
    long long rd_req; /* number of read requests */
    long long rd_bytes; /* number of read bytes */
    long long wr_req; /* number of write requests */
    long long wr_bytes; /* number of written bytes */
    long long errs;   /* In Xen this returns the mysterious 'oo_req'. */
};

typedef virDomainBlockStatsStruct *virDomainBlockStatsPtr;


typedef struct _virDomainInterfaceStats virDomainInterfaceStatsStruct;

struct _virDomainInterfaceStats {
    long long rx_bytes;
    long long rx_packets;
    long long rx_errs;
    long long rx_drop;
    long long tx_bytes;
    long long tx_packets;
    long long tx_errs;
    long long tx_drop;
};

typedef virDomainInterfaceStatsStruct *virDomainInterfaceStatsPtr;

typedef enum {
    /* The total amount of data read from swap space (in kB). */
    VIR_DOMAIN_MEMORY_STAT_SWAP_IN         = 0,
    /* The total amount of memory written out to swap space (in kB). */
    VIR_DOMAIN_MEMORY_STAT_SWAP_OUT        = 1,

    /*
     * Page faults occur when a process makes a valid access to virtual memory
     * that is not available.  When servicing the page fault, if disk IO is
     * required, it is considered a major fault.  If not, it is a minor fault.
     * These are expressed as the number of faults that have occurred.
     */
    VIR_DOMAIN_MEMORY_STAT_MAJOR_FAULT     = 2,
    VIR_DOMAIN_MEMORY_STAT_MINOR_FAULT     = 3,

    /*
     * The amount of memory left completely unused by the system.  Memory that
     * is available but used for reclaimable caches should NOT be reported as
     * free.  This value is expressed in kB.
     */
    VIR_DOMAIN_MEMORY_STAT_UNUSED          = 4,

    /*
     * The total amount of usable memory as seen by the domain.  This value
     * may be less than the amount of memory assigned to the domain if a
     * balloon driver is in use or if the guest OS does not initialize all
     * assigned pages.  This value is expressed in kB.
     */
    VIR_DOMAIN_MEMORY_STAT_AVAILABLE       = 5,

    /* Current balloon value (in KB). */
    VIR_DOMAIN_MEMORY_STAT_ACTUAL_BALLOON  = 6,

    /* Resident Set Size of the process running the domain. This value
     * is in kB */
    VIR_DOMAIN_MEMORY_STAT_RSS             = 7,

    /*
     * The number of statistics supported by this version of the interface.
     * To add new statistics, add them to the enum and increase this value.
     */
    VIR_DOMAIN_MEMORY_STAT_NR              = 8,
    VIR_DOMAIN_MEMORY_STAT_LAST = VIR_DOMAIN_MEMORY_STAT_NR
} virDomainMemoryStatTags;

typedef struct _virDomainMemoryStat virDomainMemoryStatStruct;

struct _virDomainMemoryStat {
    int tag;
    unsigned long long val;
};

typedef virDomainMemoryStatStruct *virDomainMemoryStatPtr;


typedef enum {
    VIR_DUMP_CRASH        = (1 << 0), /* crash after dump */
    VIR_DUMP_LIVE         = (1 << 1), /* live dump */
    VIR_DUMP_BYPASS_CACHE = (1 << 2), /* avoid file system cache pollution */
    VIR_DUMP_RESET        = (1 << 3), /* reset domain after dump finishes */
    VIR_DUMP_MEMORY_ONLY  = (1 << 4), /* use dump-guest-memory */
} virDomainCoreDumpFlags;

typedef enum {
    VIR_DOMAIN_CORE_DUMP_FORMAT_RAW,          /* dump guest memory in raw format */
    VIR_DOMAIN_CORE_DUMP_FORMAT_KDUMP_ZLIB,   /* kdump-compressed format, with
                                               * zlib compression */
    VIR_DOMAIN_CORE_DUMP_FORMAT_KDUMP_LZO,    /* kdump-compressed format, with
                                               * lzo compression */
    VIR_DOMAIN_CORE_DUMP_FORMAT_KDUMP_SNAPPY, /* kdump-compressed format, with
                                               * snappy compression */
    VIR_DOMAIN_CORE_DUMP_FORMAT_LAST
} virDomainCoreDumpFormat;

typedef enum {
    VIR_MIGRATE_LIVE              = (1 << 0), /* live migration */
    VIR_MIGRATE_PEER2PEER         = (1 << 1), /* direct source -> dest host control channel */
    /* Note the less-common spelling that we're stuck with:
       VIR_MIGRATE_TUNNELLED should be VIR_MIGRATE_TUNNELED */
    VIR_MIGRATE_TUNNELLED         = (1 << 2), /* tunnel migration data over libvirtd connection */
    VIR_MIGRATE_PERSIST_DEST      = (1 << 3), /* persist the VM on the destination */
    VIR_MIGRATE_UNDEFINE_SOURCE   = (1 << 4), /* undefine the VM on the source */
    VIR_MIGRATE_PAUSED            = (1 << 5), /* pause on remote side */
    VIR_MIGRATE_NON_SHARED_DISK   = (1 << 6), /* migration with non-shared storage with full disk copy */
    VIR_MIGRATE_NON_SHARED_INC    = (1 << 7), /* migration with non-shared storage with incremental copy */
                                              /* (same base image shared between source and destination) */
    VIR_MIGRATE_CHANGE_PROTECTION = (1 << 8), /* protect for changing domain configuration through the
                                               * whole migration process; this will be used automatically
                                               * when supported */
    VIR_MIGRATE_UNSAFE            = (1 << 9), /* force migration even if it is considered unsafe */
    VIR_MIGRATE_OFFLINE           = (1 << 10), /* offline migrate */
    VIR_MIGRATE_COMPRESSED        = (1 << 11), /* compress data during migration */
    VIR_MIGRATE_ABORT_ON_ERROR    = (1 << 12), /* abort migration on I/O errors happened during migration */
    VIR_MIGRATE_AUTO_CONVERGE     = (1 << 13), /* force convergence */
} virDomainMigrateFlags;


virDomainPtr virDomainMigrate (virDomainPtr domain, virConnectPtr dconn,
                               unsigned long flags, const char *dname,
                               const char *uri, unsigned long bandwidth);
virDomainPtr virDomainMigrate2(virDomainPtr domain, virConnectPtr dconn,
                               const char *dxml,
                               unsigned long flags, const char *dname,
                               const char *uri, unsigned long bandwidth);
virDomainPtr virDomainMigrate3(virDomainPtr domain,
                               virConnectPtr dconn,
                               virTypedParameterPtr params,
                               unsigned int nparams,
                               unsigned int flags);

int virDomainMigrateToURI (virDomainPtr domain, const char *duri,
                           unsigned long flags, const char *dname,
                           unsigned long bandwidth);

int virDomainMigrateToURI2(virDomainPtr domain,
                           const char *dconnuri,
                           const char *miguri,
                           const char *dxml,
                           unsigned long flags,
                           const char *dname,
                           unsigned long bandwidth);
int virDomainMigrateToURI3(virDomainPtr domain,
                           const char *dconnuri,
                           virTypedParameterPtr params,
                           unsigned int nparams,
                           unsigned int flags);

int virDomainMigrateSetMaxDowntime (virDomainPtr domain,
                                    unsigned long long downtime,
                                    unsigned int flags);

int virDomainMigrateGetCompressionCache(virDomainPtr domain,
                                        unsigned long long *cacheSize,
                                        unsigned int flags);
int virDomainMigrateSetCompressionCache(virDomainPtr domain,
                                        unsigned long long cacheSize,
                                        unsigned int flags);

int virDomainMigrateSetMaxSpeed(virDomainPtr domain,
                                unsigned long bandwidth,
                                unsigned int flags);

int virDomainMigrateGetMaxSpeed(virDomainPtr domain,
                                unsigned long *bandwidth,
                                unsigned int flags);

typedef virNodeInfo *virNodeInfoPtr;
typedef virNodeCPUStats *virNodeCPUStatsPtr;
typedef virNodeMemoryStats *virNodeMemoryStatsPtr;
typedef enum {
    VIR_CONNECT_RO         = (1 << 0),  
    VIR_CONNECT_NO_ALIASES = (1 << 1), 
} virConnectFlags;


typedef enum {
    VIR_CRED_USERNAME = 1,     /* Identity to act as */
    VIR_CRED_AUTHNAME = 2,     /* Identify to authorize as */
    VIR_CRED_LANGUAGE = 3,     /* RFC 1766 languages, comma separated */
    VIR_CRED_CNONCE = 4,       /* client supplies a nonce */
    VIR_CRED_PASSPHRASE = 5,   /* Passphrase secret */
    VIR_CRED_ECHOPROMPT = 6,   /* Challenge response */
    VIR_CRED_NOECHOPROMPT = 7, /* Challenge response */
    VIR_CRED_REALM = 8,        /* Authentication realm */
    VIR_CRED_EXTERNAL = 9,     /* Externally managed credential */
    VIR_CRED_LAST              /* More may be added - expect the unexpected */
} virConnectCredentialType;

struct _virConnectCredential {
    int type; /* One of virConnectCredentialType constants */
    const char *prompt; /* Prompt to show to user */
    const char *challenge; /* Additional challenge to show */
    const char *defresult; /* Optional default result */
    char *result; /* Result to be filled with user response (or defresult) */
    unsigned int resultlen; /* Length of the result */
};

typedef struct _virConnectCredential virConnectCredential;
typedef virConnectCredential *virConnectCredentialPtr;


typedef int (*virConnectAuthCallbackPtr)(virConnectCredentialPtr cred,
                                         unsigned int ncred,
                                         void *cbdata);

struct _virConnectAuth {
    int *credtype; /* List of supported virConnectCredentialType values */
    unsigned int ncredtype;

    virConnectAuthCallbackPtr cb; /* Callback used to collect credentials */
    void *cbdata;
};


typedef struct _virConnectAuth virConnectAuth;
typedef virConnectAuth *virConnectAuthPtr;

extern virConnectAuthPtr virConnectAuthPtrDefault;
int                     virGetVersion           (unsigned long *libVer,
                                                 const char *type,
                                                 unsigned long *typeVer);

int                     virInitialize           (void);

virConnectPtr           virConnectOpen          (const char *name);
virConnectPtr           virConnectOpenReadOnly  (const char *name);
virConnectPtr           virConnectOpenAuth      (const char *name,
                                                 virConnectAuthPtr auth,
                                                 unsigned int flags);
int                     virConnectRef           (virConnectPtr conn);
int                     virConnectClose         (virConnectPtr conn);
const char *            virConnectGetType       (virConnectPtr conn);
int                     virConnectGetVersion    (virConnectPtr conn,
                                                 unsigned long *hvVer);
int                     virConnectGetLibVersion (virConnectPtr conn,
                                                 unsigned long *libVer);
char *                  virConnectGetHostname   (virConnectPtr conn);
char *                  virConnectGetURI        (virConnectPtr conn);
char *                  virConnectGetSysinfo    (virConnectPtr conn,
                                                 unsigned int flags);

int virConnectSetKeepAlive(virConnectPtr conn,
                           int interval,
                           unsigned int count);

typedef enum {
    VIR_CONNECT_CLOSE_REASON_ERROR     = 0, /* Misc I/O error */
    VIR_CONNECT_CLOSE_REASON_EOF       = 1, /* End-of-file from server */
    VIR_CONNECT_CLOSE_REASON_KEEPALIVE = 2, /* Keepalive timer triggered */
    VIR_CONNECT_CLOSE_REASON_CLIENT    = 3, /* Client requested it */

    VIR_CONNECT_CLOSE_REASON_LAST
} virConnectCloseReason;

typedef void (*virConnectCloseFunc)(virConnectPtr conn,
                                    int reason,
                                    void *opaque);

int virConnectRegisterCloseCallback(virConnectPtr conn,
                                    virConnectCloseFunc cb,
                                    void *opaque,
                                    virFreeCallback freecb);
int virConnectUnregisterCloseCallback(virConnectPtr conn,
                                      virConnectCloseFunc cb);


int                     virConnectGetMaxVcpus   (virConnectPtr conn,
                                                 const char *type);
int                     virNodeGetInfo          (virConnectPtr conn,
                                                 virNodeInfoPtr info);
char *                  virConnectGetCapabilities (virConnectPtr conn);

int                     virNodeGetCPUStats (virConnectPtr conn,
                                            int cpuNum,
                                            virNodeCPUStatsPtr params,
                                            int *nparams,
                                            unsigned int flags);

int                     virNodeGetMemoryStats (virConnectPtr conn,
                                               int cellNum,
                                               virNodeMemoryStatsPtr params,
                                               int *nparams,
                                               unsigned int flags);

unsigned long long      virNodeGetFreeMemory    (virConnectPtr conn);

int                     virNodeGetSecurityModel (virConnectPtr conn,
                                                 virSecurityModelPtr secmodel);

int                     virNodeSuspendForDuration (virConnectPtr conn,
                                                   unsigned int target,
                                                   unsigned long long duration,
                                                   unsigned int flags);

int                     virConnectListDomains   (virConnectPtr conn,
                                                 int *ids,
                                                 int maxids);

int                     virConnectNumOfDomains  (virConnectPtr conn);


virConnectPtr           virDomainGetConnect     (virDomainPtr domain);


virDomainPtr            virDomainCreateXML      (virConnectPtr conn,
                                                 const char *xmlDesc,
                                                 unsigned int flags);
virDomainPtr            virDomainCreateXMLWithFiles(virConnectPtr conn,
                                                    const char *xmlDesc,
                                                    unsigned int nfiles,
                                                    int *files,
                                                    unsigned int flags);
virDomainPtr            virDomainLookupByName   (virConnectPtr conn,
                                                 const char *name);
virDomainPtr            virDomainLookupByID     (virConnectPtr conn,
                                                 int id);
virDomainPtr            virDomainLookupByUUID   (virConnectPtr conn,
                                                 const unsigned char *uuid);
virDomainPtr            virDomainLookupByUUIDString     (virConnectPtr conn,
                                                         const char *uuid);

typedef enum {
    VIR_DOMAIN_SHUTDOWN_DEFAULT        = 0,        /* hypervisor choice */
    VIR_DOMAIN_SHUTDOWN_ACPI_POWER_BTN = (1 << 0), /* Send ACPI event */
    VIR_DOMAIN_SHUTDOWN_GUEST_AGENT    = (1 << 1), /* Use guest agent */
    VIR_DOMAIN_SHUTDOWN_INITCTL        = (1 << 2), /* Use initctl */
    VIR_DOMAIN_SHUTDOWN_SIGNAL         = (1 << 3), /* Send a signal */
    VIR_DOMAIN_SHUTDOWN_PARAVIRT       = (1 << 4), /* Use paravirt guest control */
} virDomainShutdownFlagValues;

int                     virDomainShutdown       (virDomainPtr domain);
int                     virDomainShutdownFlags  (virDomainPtr domain,
                                                 unsigned int flags);

typedef enum {
    VIR_DOMAIN_REBOOT_DEFAULT        = 0,        /* hypervisor choice */
    VIR_DOMAIN_REBOOT_ACPI_POWER_BTN = (1 << 0), /* Send ACPI event */
    VIR_DOMAIN_REBOOT_GUEST_AGENT    = (1 << 1), /* Use guest agent */
    VIR_DOMAIN_REBOOT_INITCTL        = (1 << 2), /* Use initctl */
    VIR_DOMAIN_REBOOT_SIGNAL         = (1 << 3), /* Send a signal */
    VIR_DOMAIN_REBOOT_PARAVIRT       = (1 << 4), /* Use paravirt guest control */
} virDomainRebootFlagValues;

int                     virDomainReboot         (virDomainPtr domain,
                                                 unsigned int flags);
int                     virDomainReset          (virDomainPtr domain,
                                                 unsigned int flags);

int                     virDomainDestroy        (virDomainPtr domain);

typedef enum {
    VIR_DOMAIN_DESTROY_DEFAULT   = 0,      /* Default behavior - could lead to data loss!! */
    VIR_DOMAIN_DESTROY_GRACEFUL  = 1 << 0, /* only SIGTERM, no SIGKILL */
} virDomainDestroyFlagsValues;

int                     virDomainDestroyFlags   (virDomainPtr domain,
                                                 unsigned int flags);
int                     virDomainRef            (virDomainPtr domain);
int                     virDomainFree           (virDomainPtr domain);

int                     virDomainSuspend        (virDomainPtr domain);
int                     virDomainResume         (virDomainPtr domain);
int                     virDomainPMSuspendForDuration (virDomainPtr domain,
                                                       unsigned int target,
                                                       unsigned long long duration,
                                                       unsigned int flags);
int                     virDomainPMWakeup       (virDomainPtr domain,
                                                 unsigned int flags);

typedef enum {
    VIR_DOMAIN_SAVE_BYPASS_CACHE = 1 << 0, /* Avoid file system cache pollution */
    VIR_DOMAIN_SAVE_RUNNING      = 1 << 1, /* Favor running over paused */
    VIR_DOMAIN_SAVE_PAUSED       = 1 << 2, /* Favor paused over running */
} virDomainSaveRestoreFlags;

int                     virDomainSave           (virDomainPtr domain,
                                                 const char *to);
int                     virDomainSaveFlags      (virDomainPtr domain,
                                                 const char *to,
                                                 const char *dxml,
                                                 unsigned int flags);
int                     virDomainRestore        (virConnectPtr conn,
                                                 const char *from);
int                     virDomainRestoreFlags   (virConnectPtr conn,
                                                 const char *from,
                                                 const char *dxml,
                                                 unsigned int flags);

char *          virDomainSaveImageGetXMLDesc    (virConnectPtr conn,
                                                 const char *file,
                                                 unsigned int flags);
int             virDomainSaveImageDefineXML     (virConnectPtr conn,
                                                 const char *file,
                                                 const char *dxml,
                                                 unsigned int flags);

int                    virDomainManagedSave     (virDomainPtr dom,
                                                 unsigned int flags);
int                    virDomainHasManagedSaveImage(virDomainPtr dom,
                                                    unsigned int flags);
int                    virDomainManagedSaveRemove(virDomainPtr dom,
                                                  unsigned int flags);

int                     virDomainCoreDump       (virDomainPtr domain,
                                                 const char *to,
                                                 unsigned int flags);

int                 virDomainCoreDumpWithFormat (virDomainPtr domain,
                                                 const char *to,
                                                 unsigned int dumpformat,
                                                 unsigned int flags);

char *                  virDomainScreenshot     (virDomainPtr domain,
                                                 virStreamPtr stream,
                                                 unsigned int screen,
                                                 unsigned int flags);


int                     virDomainGetInfo        (virDomainPtr domain,
                                                 virDomainInfoPtr info);
int                     virDomainGetState       (virDomainPtr domain,
                                                 int *state,
                                                 int *reason,
                                                 unsigned int flags);

int virDomainGetCPUStats(virDomainPtr domain,
                         virTypedParameterPtr params,
                         unsigned int nparams,
                         int start_cpu,
                         unsigned int ncpus,
                         unsigned int flags);

int                     virDomainGetControlInfo (virDomainPtr domain,
                                                 virDomainControlInfoPtr info,
                                                 unsigned int flags);

char *                  virDomainGetSchedulerType(virDomainPtr domain,
                                                  int *nparams);



int     virDomainSetBlkioParameters(virDomainPtr domain,
                                    virTypedParameterPtr params,
                                    int nparams, unsigned int flags);
int     virDomainGetBlkioParameters(virDomainPtr domain,
                                    virTypedParameterPtr params,
                                    int *nparams, unsigned int flags);




int     virDomainSetMemoryParameters(virDomainPtr domain,
                                     virTypedParameterPtr params,
                                     int nparams, unsigned int flags);
int     virDomainGetMemoryParameters(virDomainPtr domain,
                                     virTypedParameterPtr params,
                                     int *nparams, unsigned int flags);

typedef enum {
    /* See virDomainModificationImpact for these flags.  */
    VIR_DOMAIN_MEM_CURRENT = VIR_DOMAIN_AFFECT_CURRENT,
    VIR_DOMAIN_MEM_LIVE    = VIR_DOMAIN_AFFECT_LIVE,
    VIR_DOMAIN_MEM_CONFIG  = VIR_DOMAIN_AFFECT_CONFIG,

    /* Additionally, these flags may be bitwise-OR'd in.  */
    VIR_DOMAIN_MEM_MAXIMUM = (1 << 2), /* affect Max rather than current */
} virDomainMemoryModFlags;



typedef enum {
    VIR_DOMAIN_NUMATUNE_MEM_STRICT      = 0,
    VIR_DOMAIN_NUMATUNE_MEM_PREFERRED   = 1,
    VIR_DOMAIN_NUMATUNE_MEM_INTERLEAVE  = 2,

    VIR_DOMAIN_NUMATUNE_MEM_LAST /* This constant is subject to change */
} virDomainNumatuneMemMode;



int     virDomainSetNumaParameters(virDomainPtr domain,
                                   virTypedParameterPtr params,
                                   int nparams, unsigned int flags);
int     virDomainGetNumaParameters(virDomainPtr domain,
                                   virTypedParameterPtr params,
                                   int *nparams, unsigned int flags);

const char *            virDomainGetName        (virDomainPtr domain);
unsigned int            virDomainGetID          (virDomainPtr domain);
int                     virDomainGetUUID        (virDomainPtr domain,
                                                 unsigned char *uuid);
int                     virDomainGetUUIDString  (virDomainPtr domain,
                                                 char *buf);
char *                  virDomainGetOSType      (virDomainPtr domain);
unsigned long           virDomainGetMaxMemory   (virDomainPtr domain);
int                     virDomainSetMaxMemory   (virDomainPtr domain,
                                                 unsigned long memory);
int                     virDomainSetMemory      (virDomainPtr domain,
                                                 unsigned long memory);
int                     virDomainSetMemoryFlags (virDomainPtr domain,
                                                 unsigned long memory,
                                                 unsigned int flags);
int                     virDomainSetMemoryStatsPeriod (virDomainPtr domain,
                                                       int period,
                                                       unsigned int flags);
int                     virDomainGetMaxVcpus    (virDomainPtr domain);
int                     virDomainGetSecurityLabel (virDomainPtr domain,
                                                   virSecurityLabelPtr seclabel);
char *                  virDomainGetHostname    (virDomainPtr domain,
                                                 unsigned int flags);
int                     virDomainGetSecurityLabelList (virDomainPtr domain,
                                                       virSecurityLabelPtr* seclabels);

typedef enum {
    VIR_DOMAIN_METADATA_DESCRIPTION = 0, /* Operate on <description> */
    VIR_DOMAIN_METADATA_TITLE       = 1, /* Operate on <title> */
    VIR_DOMAIN_METADATA_ELEMENT     = 2, /* Operate on <metadata> */

    VIR_DOMAIN_METADATA_LAST
} virDomainMetadataType;

int
virDomainSetMetadata(virDomainPtr domain,
                     int type,
                     const char *metadata,
                     const char *key,
                     const char *uri,
                     unsigned int flags);

char *
virDomainGetMetadata(virDomainPtr domain,
                     int type,
                     const char *uri,
                     unsigned int flags);


typedef enum {
    VIR_DOMAIN_XML_SECURE       = (1 << 0), /* dump security sensitive information too */
    VIR_DOMAIN_XML_INACTIVE     = (1 << 1), /* dump inactive domain information */
    VIR_DOMAIN_XML_UPDATE_CPU   = (1 << 2), /* update guest CPU requirements according to host CPU */
    VIR_DOMAIN_XML_MIGRATABLE   = (1 << 3), /* dump XML suitable for migration */
} virDomainXMLFlags;

char *                  virDomainGetXMLDesc     (virDomainPtr domain,
                                                 unsigned int flags);


char *                  virConnectDomainXMLFromNative(virConnectPtr conn,
                                                      const char *nativeFormat,
                                                      const char *nativeConfig,
                                                      unsigned int flags);
char *                  virConnectDomainXMLToNative(virConnectPtr conn,
                                                    const char *nativeFormat,
                                                    const char *domainXml,
                                                    unsigned int flags);

int                     virDomainBlockStats     (virDomainPtr dom,
                                                 const char *disk,
                                                 virDomainBlockStatsPtr stats,
                                                 size_t size);
int                     virDomainBlockStatsFlags (virDomainPtr dom,
                                                  const char *disk,
                                                  virTypedParameterPtr params,
                                                  int *nparams,
                                                  unsigned int flags);
int                     virDomainInterfaceStats (virDomainPtr dom,
                                                 const char *path,
                                                 virDomainInterfaceStatsPtr stats,
                                                 size_t size);



int                     virDomainSetInterfaceParameters (virDomainPtr dom,
                                                         const char *device,
                                                         virTypedParameterPtr params,
                                                         int nparams, unsigned int flags);
int                     virDomainGetInterfaceParameters (virDomainPtr dom,
                                                         const char *device,
                                                         virTypedParameterPtr params,
                                                         int *nparams, unsigned int flags);


int                     virDomainBlockPeek (virDomainPtr dom,
                                            const char *disk,
                                            unsigned long long offset,
                                            size_t size,
                                            void *buffer,
                                            unsigned int flags);

typedef enum {
    VIR_DOMAIN_BLOCK_RESIZE_BYTES = 1 << 0, /* size in bytes instead of KiB */
} virDomainBlockResizeFlags;

int                     virDomainBlockResize (virDomainPtr dom,
                                              const char *disk,
                                              unsigned long long size,
                                              unsigned int flags);

typedef struct _virDomainBlockInfo virDomainBlockInfo;
typedef virDomainBlockInfo *virDomainBlockInfoPtr;
struct _virDomainBlockInfo {
    unsigned long long capacity;   /* logical size in bytes of the block device backing image */
    unsigned long long allocation; /* highest allocated extent in bytes of the block device backing image */
    unsigned long long physical;   /* physical size in bytes of the container of the backing image */
};

int                     virDomainGetBlockInfo(virDomainPtr dom,
                                              const char *disk,
                                              virDomainBlockInfoPtr info,
                                              unsigned int flags);


int                     virDomainMemoryStats (virDomainPtr dom,
                                              virDomainMemoryStatPtr stats,
                                              unsigned int nr_stats,
                                              unsigned int flags);


typedef enum {
    VIR_MEMORY_VIRTUAL            = 1 << 0, /* addresses are virtual addresses */
    VIR_MEMORY_PHYSICAL           = 1 << 1, /* addresses are physical addresses */
} virDomainMemoryFlags;

int                     virDomainMemoryPeek (virDomainPtr dom,
                                             unsigned long long start,
                                             size_t size,
                                             void *buffer,
                                             unsigned int flags);

virDomainPtr            virDomainDefineXML      (virConnectPtr conn,
                                                 const char *xml);
int                     virDomainUndefine       (virDomainPtr domain);

typedef enum {
    VIR_DOMAIN_UNDEFINE_MANAGED_SAVE       = (1 << 0), /* Also remove any
                                                          managed save */
    VIR_DOMAIN_UNDEFINE_SNAPSHOTS_METADATA = (1 << 1), /* If last use of domain,
                                                          then also remove any
                                                          snapshot metadata */

    /* Future undefine control flags should come here. */
} virDomainUndefineFlagsValues;


int                     virDomainUndefineFlags   (virDomainPtr domain,
                                                  unsigned int flags);
int                     virConnectNumOfDefinedDomains  (virConnectPtr conn);
int                     virConnectListDefinedDomains (virConnectPtr conn,
                                                      char **const names,
                                                      int maxnames);
typedef enum {
    VIR_CONNECT_LIST_DOMAINS_ACTIVE         = 1 << 0,
    VIR_CONNECT_LIST_DOMAINS_INACTIVE       = 1 << 1,

    VIR_CONNECT_LIST_DOMAINS_PERSISTENT     = 1 << 2,
    VIR_CONNECT_LIST_DOMAINS_TRANSIENT      = 1 << 3,

    VIR_CONNECT_LIST_DOMAINS_RUNNING        = 1 << 4,
    VIR_CONNECT_LIST_DOMAINS_PAUSED         = 1 << 5,
    VIR_CONNECT_LIST_DOMAINS_SHUTOFF        = 1 << 6,
    VIR_CONNECT_LIST_DOMAINS_OTHER          = 1 << 7,

    VIR_CONNECT_LIST_DOMAINS_MANAGEDSAVE    = 1 << 8,
    VIR_CONNECT_LIST_DOMAINS_NO_MANAGEDSAVE = 1 << 9,

    VIR_CONNECT_LIST_DOMAINS_AUTOSTART      = 1 << 10,
    VIR_CONNECT_LIST_DOMAINS_NO_AUTOSTART   = 1 << 11,

    VIR_CONNECT_LIST_DOMAINS_HAS_SNAPSHOT   = 1 << 12,
    VIR_CONNECT_LIST_DOMAINS_NO_SNAPSHOT    = 1 << 13,
} virConnectListAllDomainsFlags;

int                     virConnectListAllDomains (virConnectPtr conn,
                                                  virDomainPtr **domains,
                                                  unsigned int flags);
int                     virDomainCreate         (virDomainPtr domain);
int                     virDomainCreateWithFlags (virDomainPtr domain,
                                                  unsigned int flags);

int                     virDomainCreateWithFiles (virDomainPtr domain,
                                                  unsigned int nfiles,
                                                  int *files,
                                                  unsigned int flags);

int                     virDomainGetAutostart   (virDomainPtr domain,
                                                 int *autostart);
int                     virDomainSetAutostart   (virDomainPtr domain,
                                                 int autostart);


typedef enum {
    VIR_VCPU_OFFLINE    = 0,    /* the virtual CPU is offline */
    VIR_VCPU_RUNNING    = 1,    /* the virtual CPU is running */
    VIR_VCPU_BLOCKED    = 2,    /* the virtual CPU is blocked on resource */

    VIR_VCPU_LAST
} virVcpuState;

typedef struct _virVcpuInfo virVcpuInfo;
struct _virVcpuInfo {
    unsigned int number;        /* virtual CPU number */
    int state;                  /* value from virVcpuState */
    unsigned long long cpuTime; /* CPU time used, in nanoseconds */
    int cpu;                    /* real CPU number, or -1 if offline */
};
typedef virVcpuInfo *virVcpuInfoPtr;

typedef enum {
    /* See virDomainModificationImpact for these flags.  */
    VIR_DOMAIN_VCPU_CURRENT = VIR_DOMAIN_AFFECT_CURRENT,
    VIR_DOMAIN_VCPU_LIVE    = VIR_DOMAIN_AFFECT_LIVE,
    VIR_DOMAIN_VCPU_CONFIG  = VIR_DOMAIN_AFFECT_CONFIG,

    /* Additionally, these flags may be bitwise-OR'd in.  */
    VIR_DOMAIN_VCPU_MAXIMUM = (1 << 2), /* Max rather than current count */
    VIR_DOMAIN_VCPU_GUEST   = (1 << 3), /* Modify state of the cpu in the guest */
} virDomainVcpuFlags;

int                     virDomainSetVcpus       (virDomainPtr domain,
                                                 unsigned int nvcpus);
int                     virDomainSetVcpusFlags  (virDomainPtr domain,
                                                 unsigned int nvcpus,
                                                 unsigned int flags);
int                     virDomainGetVcpusFlags  (virDomainPtr domain,
                                                 unsigned int flags);

int                     virDomainPinVcpu        (virDomainPtr domain,
                                                 unsigned int vcpu,
                                                 unsigned char *cpumap,
                                                 int maplen);
int                     virDomainPinVcpuFlags   (virDomainPtr domain,
                                                 unsigned int vcpu,
                                                 unsigned char *cpumap,
                                                 int maplen,
                                                 unsigned int flags);

int                     virDomainGetVcpuPinInfo (virDomainPtr domain,
                                                 int ncpumaps,
                                                 unsigned char *cpumaps,
                                                 int maplen,
                                                 unsigned int flags);

int                     virDomainPinEmulator   (virDomainPtr domain,
                                                unsigned char *cpumap,
                                                int maplen,
                                                unsigned int flags);

int                     virDomainGetEmulatorPinInfo (virDomainPtr domain,
                                                     unsigned char *cpumaps,
                                                     int maplen,
                                                     unsigned int flags);



int                     virDomainGetVcpus       (virDomainPtr domain,
                                                 virVcpuInfoPtr info,
                                                 int maxinfo,
                                                 unsigned char *cpumaps,
                                                 int maplen);




typedef enum {
    /* See virDomainModificationImpact for these flags.  */
    VIR_DOMAIN_DEVICE_MODIFY_CURRENT = VIR_DOMAIN_AFFECT_CURRENT,
    VIR_DOMAIN_DEVICE_MODIFY_LIVE    = VIR_DOMAIN_AFFECT_LIVE,
    VIR_DOMAIN_DEVICE_MODIFY_CONFIG  = VIR_DOMAIN_AFFECT_CONFIG,

    /* Additionally, these flags may be bitwise-OR'd in.  */
    VIR_DOMAIN_DEVICE_MODIFY_FORCE = (1 << 2), /* Forcibly modify device
                                                  (ex. force eject a cdrom) */
} virDomainDeviceModifyFlags;

int virDomainAttachDevice(virDomainPtr domain, const char *xml);
int virDomainDetachDevice(virDomainPtr domain, const char *xml);

int virDomainAttachDeviceFlags(virDomainPtr domain,
                               const char *xml, unsigned int flags);
int virDomainDetachDeviceFlags(virDomainPtr domain,
                               const char *xml, unsigned int flags);
int virDomainUpdateDeviceFlags(virDomainPtr domain,
                               const char *xml, unsigned int flags);


typedef enum {
    VIR_DOMAIN_BLOCK_JOB_TYPE_UNKNOWN = 0,
    VIR_DOMAIN_BLOCK_JOB_TYPE_PULL = 1,
    VIR_DOMAIN_BLOCK_JOB_TYPE_COPY = 2,
    VIR_DOMAIN_BLOCK_JOB_TYPE_COMMIT = 3,

    VIR_DOMAIN_BLOCK_JOB_TYPE_LAST
} virDomainBlockJobType;

typedef enum {
    VIR_DOMAIN_BLOCK_JOB_ABORT_ASYNC = 1 << 0,
    VIR_DOMAIN_BLOCK_JOB_ABORT_PIVOT = 1 << 1,
} virDomainBlockJobAbortFlags;

typedef unsigned long long virDomainBlockJobCursor;

typedef struct _virDomainBlockJobInfo virDomainBlockJobInfo;
struct _virDomainBlockJobInfo {
    virDomainBlockJobType type;
    unsigned long bandwidth;
    /*
     * The following fields provide an indication of block job progress.  @cur
     * indicates the current position and will be between 0 and @end.  @end is
     * the final cursor position for this operation and represents completion.
     * To approximate progress, divide @cur by @end.
     */
    virDomainBlockJobCursor cur;
    virDomainBlockJobCursor end;
};
typedef virDomainBlockJobInfo *virDomainBlockJobInfoPtr;

int       virDomainBlockJobAbort(virDomainPtr dom, const char *disk,
                                 unsigned int flags);
int     virDomainGetBlockJobInfo(virDomainPtr dom, const char *disk,
                                 virDomainBlockJobInfoPtr info,
                                 unsigned int flags);
int    virDomainBlockJobSetSpeed(virDomainPtr dom, const char *disk,
                                 unsigned long bandwidth, unsigned int flags);

int           virDomainBlockPull(virDomainPtr dom, const char *disk,
                                 unsigned long bandwidth, unsigned int flags);

typedef enum {
    VIR_DOMAIN_BLOCK_REBASE_SHALLOW   = 1 << 0, /* Limit copy to top of source
                                                   backing chain */
    VIR_DOMAIN_BLOCK_REBASE_REUSE_EXT = 1 << 1, /* Reuse existing external
                                                   file for a copy */
    VIR_DOMAIN_BLOCK_REBASE_COPY_RAW  = 1 << 2, /* Make destination file raw */
    VIR_DOMAIN_BLOCK_REBASE_COPY      = 1 << 3, /* Start a copy job */
} virDomainBlockRebaseFlags;

int           virDomainBlockRebase(virDomainPtr dom, const char *disk,
                                   const char *base, unsigned long bandwidth,
                                   unsigned int flags);

typedef enum {
    VIR_DOMAIN_BLOCK_COMMIT_SHALLOW = 1 << 0, /* NULL base means next backing
                                                 file, not whole chain */
    VIR_DOMAIN_BLOCK_COMMIT_DELETE  = 1 << 1, /* Delete any files that are now
                                                 invalid after their contents
                                                 have been committed */
} virDomainBlockCommitFlags;

int virDomainBlockCommit(virDomainPtr dom, const char *disk, const char *base,
                         const char *top, unsigned long bandwidth,
                         unsigned int flags);




int
virDomainSetBlockIoTune(virDomainPtr dom,
                        const char *disk,
                        virTypedParameterPtr params,
                        int nparams,
                        unsigned int flags);
int
virDomainGetBlockIoTune(virDomainPtr dom,
                        const char *disk,
                        virTypedParameterPtr params,
                        int *nparams,
                        unsigned int flags);

typedef enum {
    VIR_DOMAIN_DISK_ERROR_NONE      = 0, /* no error */
    VIR_DOMAIN_DISK_ERROR_UNSPEC    = 1, /* unspecified I/O error */
    VIR_DOMAIN_DISK_ERROR_NO_SPACE  = 2, /* no space left on the device */

    VIR_DOMAIN_DISK_ERROR_LAST
} virDomainDiskErrorCode;

typedef struct _virDomainDiskError virDomainDiskError;
typedef virDomainDiskError *virDomainDiskErrorPtr;

struct _virDomainDiskError {
    char *disk; /* disk target */
    int error;  /* virDomainDiskErrorCode */
};

int virDomainGetDiskErrors(virDomainPtr dom,
                           virDomainDiskErrorPtr errors,
                           unsigned int maxerrors,
                           unsigned int flags);



int                      virNodeGetCellsFreeMemory(virConnectPtr conn,
                                                   unsigned long long *freeMems,
                                                   int startCell,
                                                   int maxCells);


typedef enum {
    VIR_NETWORK_XML_INACTIVE = (1 << 0), /* dump inactive network information */
} virNetworkXMLFlags;

typedef struct _virNetwork virNetwork;

typedef virNetwork *virNetworkPtr;

virConnectPtr           virNetworkGetConnect    (virNetworkPtr network);

int                     virConnectNumOfNetworks (virConnectPtr conn);
int                     virConnectListNetworks  (virConnectPtr conn,
                                                 char **const names,
                                                 int maxnames);

int                     virConnectNumOfDefinedNetworks  (virConnectPtr conn);
int                     virConnectListDefinedNetworks   (virConnectPtr conn,
                                                         char **const names,
                                                         int maxnames);
typedef enum {
    VIR_CONNECT_LIST_NETWORKS_INACTIVE      = 1 << 0,
    VIR_CONNECT_LIST_NETWORKS_ACTIVE        = 1 << 1,

    VIR_CONNECT_LIST_NETWORKS_PERSISTENT    = 1 << 2,
    VIR_CONNECT_LIST_NETWORKS_TRANSIENT     = 1 << 3,

    VIR_CONNECT_LIST_NETWORKS_AUTOSTART     = 1 << 4,
    VIR_CONNECT_LIST_NETWORKS_NO_AUTOSTART  = 1 << 5,
} virConnectListAllNetworksFlags;

int                     virConnectListAllNetworks       (virConnectPtr conn,
                                                         virNetworkPtr **nets,
                                                         unsigned int flags);

virNetworkPtr           virNetworkLookupByName          (virConnectPtr conn,
                                                         const char *name);
virNetworkPtr           virNetworkLookupByUUID          (virConnectPtr conn,
                                                         const unsigned char *uuid);
virNetworkPtr           virNetworkLookupByUUIDString    (virConnectPtr conn,
                                                         const char *uuid);

virNetworkPtr           virNetworkCreateXML     (virConnectPtr conn,
                                                 const char *xmlDesc);

virNetworkPtr           virNetworkDefineXML     (virConnectPtr conn,
                                                 const char *xmlDesc);

int                     virNetworkUndefine      (virNetworkPtr network);

typedef enum {
    VIR_NETWORK_UPDATE_COMMAND_NONE      = 0, /* (invalid) */
    VIR_NETWORK_UPDATE_COMMAND_MODIFY    = 1, /* modify an existing element */
    VIR_NETWORK_UPDATE_COMMAND_DELETE    = 2, /* delete an existing element */
    VIR_NETWORK_UPDATE_COMMAND_ADD_LAST  = 3, /* add an element at end of list */
    VIR_NETWORK_UPDATE_COMMAND_ADD_FIRST = 4, /* add an element at start of list */
    VIR_NETWORK_UPDATE_COMMAND_LAST
} virNetworkUpdateCommand;

typedef enum {
    VIR_NETWORK_SECTION_NONE              =  0, /* (invalid) */
    VIR_NETWORK_SECTION_BRIDGE            =  1, /* <bridge> */
    VIR_NETWORK_SECTION_DOMAIN            =  2, /* <domain> */
    VIR_NETWORK_SECTION_IP                =  3, /* <ip> */
    VIR_NETWORK_SECTION_IP_DHCP_HOST      =  4, /* <ip>/<dhcp>/<host> */
    VIR_NETWORK_SECTION_IP_DHCP_RANGE     =  5, /* <ip>/<dhcp>/<range> */
    VIR_NETWORK_SECTION_FORWARD           =  6, /* <forward> */
    VIR_NETWORK_SECTION_FORWARD_INTERFACE =  7, /* <forward>/<interface> */
    VIR_NETWORK_SECTION_FORWARD_PF        =  8, /* <forward>/<pf> */
    VIR_NETWORK_SECTION_PORTGROUP         =  9, /* <portgroup> */
    VIR_NETWORK_SECTION_DNS_HOST          = 10, /* <dns>/<host> */
    VIR_NETWORK_SECTION_DNS_TXT           = 11, /* <dns>/<txt> */
    VIR_NETWORK_SECTION_DNS_SRV           = 12, /* <dns>/<srv> */
    VIR_NETWORK_SECTION_LAST
} virNetworkUpdateSection;

typedef enum {
    VIR_NETWORK_UPDATE_AFFECT_CURRENT = 0,      /* affect live if network is active,
                                                   config if it's not active */
    VIR_NETWORK_UPDATE_AFFECT_LIVE    = 1 << 0, /* affect live state of network only */
    VIR_NETWORK_UPDATE_AFFECT_CONFIG  = 1 << 1, /* affect persistent config only */
} virNetworkUpdateFlags;

int                     virNetworkUpdate(virNetworkPtr network,
                                         unsigned int command, /* virNetworkUpdateCommand */
                                         unsigned int section, /* virNetworkUpdateSection */
                                         int parentIndex,
                                         const char *xml,
                                         unsigned int flags);

int                     virNetworkCreate        (virNetworkPtr network);

int                     virNetworkDestroy       (virNetworkPtr network);
int                     virNetworkRef           (virNetworkPtr network);
int                     virNetworkFree          (virNetworkPtr network);

const char*             virNetworkGetName       (virNetworkPtr network);
int                     virNetworkGetUUID       (virNetworkPtr network,
                                                 unsigned char *uuid);
int                     virNetworkGetUUIDString (virNetworkPtr network,
                                                 char *buf);
char *                  virNetworkGetXMLDesc    (virNetworkPtr network,
                                                 unsigned int flags);
char *                  virNetworkGetBridgeName (virNetworkPtr network);

int                     virNetworkGetAutostart  (virNetworkPtr network,
                                                 int *autostart);
int                     virNetworkSetAutostart  (virNetworkPtr network,
                                                 int autostart);


typedef struct _virInterface virInterface;

typedef virInterface *virInterfacePtr;

virConnectPtr           virInterfaceGetConnect    (virInterfacePtr iface);

int                     virConnectNumOfInterfaces (virConnectPtr conn);
int                     virConnectListInterfaces  (virConnectPtr conn,
                                                   char **const names,
                                                   int maxnames);

int                     virConnectNumOfDefinedInterfaces (virConnectPtr conn);
int                     virConnectListDefinedInterfaces  (virConnectPtr conn,
                                                          char **const names,
                                                          int maxnames);
typedef enum {
    VIR_CONNECT_LIST_INTERFACES_INACTIVE      = 1 << 0,
    VIR_CONNECT_LIST_INTERFACES_ACTIVE        = 1 << 1,
} virConnectListAllInterfacesFlags;

int                     virConnectListAllInterfaces (virConnectPtr conn,
                                                     virInterfacePtr **ifaces,
                                                     unsigned int flags);

virInterfacePtr         virInterfaceLookupByName  (virConnectPtr conn,
                                                   const char *name);
virInterfacePtr         virInterfaceLookupByMACString (virConnectPtr conn,
                                                       const char *mac);

const char*             virInterfaceGetName       (virInterfacePtr iface);
const char*             virInterfaceGetMACString  (virInterfacePtr iface);

typedef enum {
    VIR_INTERFACE_XML_INACTIVE = 1 << 0 /* dump inactive interface information */
} virInterfaceXMLFlags;

char *                  virInterfaceGetXMLDesc    (virInterfacePtr iface,
                                                   unsigned int flags);
virInterfacePtr         virInterfaceDefineXML     (virConnectPtr conn,
                                                   const char *xmlDesc,
                                                   unsigned int flags);

int                     virInterfaceUndefine      (virInterfacePtr iface);

int                     virInterfaceCreate        (virInterfacePtr iface,
                                                   unsigned int flags);

int                     virInterfaceDestroy       (virInterfacePtr iface,
                                                   unsigned int flags);

int                     virInterfaceRef           (virInterfacePtr iface);
int                     virInterfaceFree          (virInterfacePtr iface);

int                     virInterfaceChangeBegin   (virConnectPtr conn,
                                                   unsigned int flags);
int                     virInterfaceChangeCommit  (virConnectPtr conn,
                                                   unsigned int flags);
int                     virInterfaceChangeRollback(virConnectPtr conn,
                                                   unsigned int flags);

typedef struct _virStoragePool virStoragePool;

typedef virStoragePool *virStoragePoolPtr;


typedef enum {
    VIR_STORAGE_POOL_INACTIVE = 0, /* Not running */
    VIR_STORAGE_POOL_BUILDING = 1, /* Initializing pool, not available */
    VIR_STORAGE_POOL_RUNNING = 2,  /* Running normally */
    VIR_STORAGE_POOL_DEGRADED = 3, /* Running degraded */
    VIR_STORAGE_POOL_INACCESSIBLE = 4, /* Running, but not accessible */

    VIR_STORAGE_POOL_STATE_LAST
} virStoragePoolState;


typedef enum {
    VIR_STORAGE_POOL_BUILD_NEW  = 0,   /* Regular build from scratch */
    VIR_STORAGE_POOL_BUILD_REPAIR = (1 << 0), /* Repair / reinitialize */
    VIR_STORAGE_POOL_BUILD_RESIZE = (1 << 1),  /* Extend existing pool */
    VIR_STORAGE_POOL_BUILD_NO_OVERWRITE = (1 << 2),  /* Do not overwrite existing pool */
    VIR_STORAGE_POOL_BUILD_OVERWRITE = (1 << 3),  /* Overwrite data */
} virStoragePoolBuildFlags;

typedef enum {
    VIR_STORAGE_POOL_DELETE_NORMAL = 0, /* Delete metadata only    (fast) */
    VIR_STORAGE_POOL_DELETE_ZEROED = 1 << 0,  /* Clear all data to zeros (slow) */
} virStoragePoolDeleteFlags;

typedef struct _virStoragePoolInfo virStoragePoolInfo;

struct _virStoragePoolInfo {
    int state;                     /* virStoragePoolState flags */
    unsigned long long capacity;   /* Logical size bytes */
    unsigned long long allocation; /* Current allocation bytes */
    unsigned long long available;  /* Remaining free space bytes */
};

typedef virStoragePoolInfo *virStoragePoolInfoPtr;


typedef struct _virStorageVol virStorageVol;

typedef virStorageVol *virStorageVolPtr;


typedef enum {
    VIR_STORAGE_VOL_FILE = 0,     /* Regular file based volumes */
    VIR_STORAGE_VOL_BLOCK = 1,    /* Block based volumes */
    VIR_STORAGE_VOL_DIR = 2,      /* Directory-passthrough based volume */
    VIR_STORAGE_VOL_NETWORK = 3,  /* Network volumes like RBD (RADOS Block Device) */
    VIR_STORAGE_VOL_NETDIR = 4,   /* Network accessible directory that can
                                   * contain other network volumes */

    VIR_STORAGE_VOL_LAST
} virStorageVolType;

typedef enum {
    VIR_STORAGE_VOL_DELETE_NORMAL = 0, /* Delete metadata only    (fast) */
    VIR_STORAGE_VOL_DELETE_ZEROED = 1 << 0,  /* Clear all data to zeros (slow) */
} virStorageVolDeleteFlags;

typedef enum {
    VIR_STORAGE_VOL_WIPE_ALG_ZERO = 0, /* 1-pass, all zeroes */
    VIR_STORAGE_VOL_WIPE_ALG_NNSA = 1, /* 4-pass  NNSA Policy Letter
                                          NAP-14.1-C (XVI-8) */
    VIR_STORAGE_VOL_WIPE_ALG_DOD = 2, /* 4-pass DoD 5220.22-M section
                                         8-306 procedure */
    VIR_STORAGE_VOL_WIPE_ALG_BSI = 3, /* 9-pass method recommended by the
                                         German Center of Security in
                                         Information Technologies */
    VIR_STORAGE_VOL_WIPE_ALG_GUTMANN = 4, /* The canonical 35-pass sequence */
    VIR_STORAGE_VOL_WIPE_ALG_SCHNEIER = 5, /* 7-pass method described by
                                              Bruce Schneier in "Applied
                                              Cryptography" (1996) */
    VIR_STORAGE_VOL_WIPE_ALG_PFITZNER7 = 6, /* 7-pass random */

    VIR_STORAGE_VOL_WIPE_ALG_PFITZNER33 = 7, /* 33-pass random */

    VIR_STORAGE_VOL_WIPE_ALG_RANDOM = 8, /* 1-pass random */

    VIR_STORAGE_VOL_WIPE_ALG_LAST
    /*
     * NB: this enum value will increase over time as new algorithms are
     * added to the libvirt API. It reflects the last algorithm supported
     * by this version of the libvirt API.
     */
} virStorageVolWipeAlgorithm;

typedef struct _virStorageVolInfo virStorageVolInfo;

struct _virStorageVolInfo {
    int type;                      /* virStorageVolType flags */
    unsigned long long capacity;   /* Logical size bytes */
    unsigned long long allocation; /* Current allocation bytes */
};

typedef virStorageVolInfo *virStorageVolInfoPtr;

typedef enum {
    VIR_STORAGE_XML_INACTIVE    = (1 << 0), /* dump inactive pool/volume information */
} virStorageXMLFlags;

virConnectPtr           virStoragePoolGetConnect        (virStoragePoolPtr pool);

int                     virConnectNumOfStoragePools     (virConnectPtr conn);
int                     virConnectListStoragePools      (virConnectPtr conn,
                                                         char **const names,
                                                         int maxnames);

int                     virConnectNumOfDefinedStoragePools(virConnectPtr conn);
int                     virConnectListDefinedStoragePools(virConnectPtr conn,
                                                          char **const names,
                                                          int maxnames);

typedef enum {
    VIR_CONNECT_LIST_STORAGE_POOLS_INACTIVE      = 1 << 0,
    VIR_CONNECT_LIST_STORAGE_POOLS_ACTIVE        = 1 << 1,

    VIR_CONNECT_LIST_STORAGE_POOLS_PERSISTENT    = 1 << 2,
    VIR_CONNECT_LIST_STORAGE_POOLS_TRANSIENT     = 1 << 3,

    VIR_CONNECT_LIST_STORAGE_POOLS_AUTOSTART     = 1 << 4,
    VIR_CONNECT_LIST_STORAGE_POOLS_NO_AUTOSTART  = 1 << 5,

    /* List pools by type */
    VIR_CONNECT_LIST_STORAGE_POOLS_DIR           = 1 << 6,
    VIR_CONNECT_LIST_STORAGE_POOLS_FS            = 1 << 7,
    VIR_CONNECT_LIST_STORAGE_POOLS_NETFS         = 1 << 8,
    VIR_CONNECT_LIST_STORAGE_POOLS_LOGICAL       = 1 << 9,
    VIR_CONNECT_LIST_STORAGE_POOLS_DISK          = 1 << 10,
    VIR_CONNECT_LIST_STORAGE_POOLS_ISCSI         = 1 << 11,
    VIR_CONNECT_LIST_STORAGE_POOLS_SCSI          = 1 << 12,
    VIR_CONNECT_LIST_STORAGE_POOLS_MPATH         = 1 << 13,
    VIR_CONNECT_LIST_STORAGE_POOLS_RBD           = 1 << 14,
    VIR_CONNECT_LIST_STORAGE_POOLS_SHEEPDOG      = 1 << 15,
    VIR_CONNECT_LIST_STORAGE_POOLS_GLUSTER       = 1 << 16,
} virConnectListAllStoragePoolsFlags;

int                     virConnectListAllStoragePools(virConnectPtr conn,
                                                      virStoragePoolPtr **pools,
                                                      unsigned int flags);
char *                  virConnectFindStoragePoolSources(virConnectPtr conn,
                                                         const char *type,
                                                         const char *srcSpec,
                                                         unsigned int flags);

virStoragePoolPtr       virStoragePoolLookupByName      (virConnectPtr conn,
                                                         const char *name);
virStoragePoolPtr       virStoragePoolLookupByUUID      (virConnectPtr conn,
                                                         const unsigned char *uuid);
virStoragePoolPtr       virStoragePoolLookupByUUIDString(virConnectPtr conn,
                                                         const char *uuid);
virStoragePoolPtr       virStoragePoolLookupByVolume    (virStorageVolPtr vol);

virStoragePoolPtr       virStoragePoolCreateXML         (virConnectPtr conn,
                                                         const char *xmlDesc,
                                                         unsigned int flags);
virStoragePoolPtr       virStoragePoolDefineXML         (virConnectPtr conn,
                                                         const char *xmlDesc,
                                                         unsigned int flags);
int                     virStoragePoolBuild             (virStoragePoolPtr pool,
                                                         unsigned int flags);
int                     virStoragePoolUndefine          (virStoragePoolPtr pool);
int                     virStoragePoolCreate            (virStoragePoolPtr pool,
                                                         unsigned int flags);
int                     virStoragePoolDestroy           (virStoragePoolPtr pool);
int                     virStoragePoolDelete            (virStoragePoolPtr pool,
                                                         unsigned int flags);
int                     virStoragePoolRef               (virStoragePoolPtr pool);
int                     virStoragePoolFree              (virStoragePoolPtr pool);
int                     virStoragePoolRefresh           (virStoragePoolPtr pool,
                                                         unsigned int flags);

const char*             virStoragePoolGetName           (virStoragePoolPtr pool);
int                     virStoragePoolGetUUID           (virStoragePoolPtr pool,
                                                         unsigned char *uuid);
int                     virStoragePoolGetUUIDString     (virStoragePoolPtr pool,
                                                         char *buf);

int                     virStoragePoolGetInfo           (virStoragePoolPtr vol,
                                                         virStoragePoolInfoPtr info);

char *                  virStoragePoolGetXMLDesc        (virStoragePoolPtr pool,
                                                         unsigned int flags);

int                     virStoragePoolGetAutostart      (virStoragePoolPtr pool,
                                                         int *autostart);
int                     virStoragePoolSetAutostart      (virStoragePoolPtr pool,
                                                         int autostart);

int                     virStoragePoolNumOfVolumes      (virStoragePoolPtr pool);
int                     virStoragePoolListVolumes       (virStoragePoolPtr pool,
                                                         char **const names,
                                                         int maxnames);
int                     virStoragePoolListAllVolumes    (virStoragePoolPtr pool,
                                                         virStorageVolPtr **vols,
                                                         unsigned int flags);

virConnectPtr           virStorageVolGetConnect         (virStorageVolPtr vol);

virStorageVolPtr        virStorageVolLookupByName       (virStoragePoolPtr pool,
                                                         const char *name);
virStorageVolPtr        virStorageVolLookupByKey        (virConnectPtr conn,
                                                         const char *key);
virStorageVolPtr        virStorageVolLookupByPath       (virConnectPtr conn,
                                                         const char *path);


const char*             virStorageVolGetName            (virStorageVolPtr vol);
const char*             virStorageVolGetKey             (virStorageVolPtr vol);

typedef enum {
    VIR_STORAGE_VOL_CREATE_PREALLOC_METADATA = 1 << 0,
} virStorageVolCreateFlags;

virStorageVolPtr        virStorageVolCreateXML          (virStoragePoolPtr pool,
                                                         const char *xmldesc,
                                                         unsigned int flags);
virStorageVolPtr        virStorageVolCreateXMLFrom      (virStoragePoolPtr pool,
                                                         const char *xmldesc,
                                                         virStorageVolPtr clonevol,
                                                         unsigned int flags);
int                     virStorageVolDownload           (virStorageVolPtr vol,
                                                         virStreamPtr stream,
                                                         unsigned long long offset,
                                                         unsigned long long length,
                                                         unsigned int flags);
int                     virStorageVolUpload             (virStorageVolPtr vol,
                                                         virStreamPtr stream,
                                                         unsigned long long offset,
                                                         unsigned long long length,
                                                         unsigned int flags);
int                     virStorageVolDelete             (virStorageVolPtr vol,
                                                         unsigned int flags);
int                     virStorageVolWipe               (virStorageVolPtr vol,
                                                         unsigned int flags);
int                     virStorageVolWipePattern        (virStorageVolPtr vol,
                                                         unsigned int algorithm,
                                                         unsigned int flags);
int                     virStorageVolRef                (virStorageVolPtr vol);
int                     virStorageVolFree               (virStorageVolPtr vol);

int                     virStorageVolGetInfo            (virStorageVolPtr vol,
                                                         virStorageVolInfoPtr info);
char *                  virStorageVolGetXMLDesc         (virStorageVolPtr pool,
                                                         unsigned int flags);

char *                  virStorageVolGetPath            (virStorageVolPtr vol);

typedef enum {
    VIR_STORAGE_VOL_RESIZE_ALLOCATE = 1 << 0, /* force allocation of new size */
    VIR_STORAGE_VOL_RESIZE_DELTA    = 1 << 1, /* size is relative to current */
    VIR_STORAGE_VOL_RESIZE_SHRINK   = 1 << 2, /* allow decrease in capacity */
} virStorageVolResizeFlags;

int                     virStorageVolResize             (virStorageVolPtr vol,
                                                         unsigned long long capacity,
                                                         unsigned int flags);


typedef enum {
    VIR_KEYCODE_SET_LINUX          = 0,
    VIR_KEYCODE_SET_XT             = 1,
    VIR_KEYCODE_SET_ATSET1         = 2,
    VIR_KEYCODE_SET_ATSET2         = 3,
    VIR_KEYCODE_SET_ATSET3         = 4,
    VIR_KEYCODE_SET_OSX            = 5,
    VIR_KEYCODE_SET_XT_KBD         = 6,
    VIR_KEYCODE_SET_USB            = 7,
    VIR_KEYCODE_SET_WIN32          = 8,
    VIR_KEYCODE_SET_RFB            = 9,

    VIR_KEYCODE_SET_LAST
    /*
     * NB: this enum value will increase over time as new events are
     * added to the libvirt API. It reflects the last keycode set supported
     * by this version of the libvirt API.
     */
} virKeycodeSet;


int virDomainSendKey(virDomainPtr domain,
                     unsigned int codeset,
                     unsigned int holdtime,
                     unsigned int *keycodes,
                     int nkeycodes,
                     unsigned int flags);

typedef enum {
    VIR_DOMAIN_PROCESS_SIGNAL_NOP        =  0, /* No constant in POSIX/Linux */
    VIR_DOMAIN_PROCESS_SIGNAL_HUP        =  1, /* SIGHUP */
    VIR_DOMAIN_PROCESS_SIGNAL_INT        =  2, /* SIGINT */
    VIR_DOMAIN_PROCESS_SIGNAL_QUIT       =  3, /* SIGQUIT */
    VIR_DOMAIN_PROCESS_SIGNAL_ILL        =  4, /* SIGILL */
    VIR_DOMAIN_PROCESS_SIGNAL_TRAP       =  5, /* SIGTRAP */
    VIR_DOMAIN_PROCESS_SIGNAL_ABRT       =  6, /* SIGABRT */
    VIR_DOMAIN_PROCESS_SIGNAL_BUS        =  7, /* SIGBUS */
    VIR_DOMAIN_PROCESS_SIGNAL_FPE        =  8, /* SIGFPE */
    VIR_DOMAIN_PROCESS_SIGNAL_KILL       =  9, /* SIGKILL */

    VIR_DOMAIN_PROCESS_SIGNAL_USR1       = 10, /* SIGUSR1 */
    VIR_DOMAIN_PROCESS_SIGNAL_SEGV       = 11, /* SIGSEGV */
    VIR_DOMAIN_PROCESS_SIGNAL_USR2       = 12, /* SIGUSR2 */
    VIR_DOMAIN_PROCESS_SIGNAL_PIPE       = 13, /* SIGPIPE */
    VIR_DOMAIN_PROCESS_SIGNAL_ALRM       = 14, /* SIGALRM */
    VIR_DOMAIN_PROCESS_SIGNAL_TERM       = 15, /* SIGTERM */
    VIR_DOMAIN_PROCESS_SIGNAL_STKFLT     = 16, /* Not in POSIX (SIGSTKFLT on Linux )*/
    VIR_DOMAIN_PROCESS_SIGNAL_CHLD       = 17, /* SIGCHLD */
    VIR_DOMAIN_PROCESS_SIGNAL_CONT       = 18, /* SIGCONT */
    VIR_DOMAIN_PROCESS_SIGNAL_STOP       = 19, /* SIGSTOP */

    VIR_DOMAIN_PROCESS_SIGNAL_TSTP       = 20, /* SIGTSTP */
    VIR_DOMAIN_PROCESS_SIGNAL_TTIN       = 21, /* SIGTTIN */
    VIR_DOMAIN_PROCESS_SIGNAL_TTOU       = 22, /* SIGTTOU */
    VIR_DOMAIN_PROCESS_SIGNAL_URG        = 23, /* SIGURG */
    VIR_DOMAIN_PROCESS_SIGNAL_XCPU       = 24, /* SIGXCPU */
    VIR_DOMAIN_PROCESS_SIGNAL_XFSZ       = 25, /* SIGXFSZ */
    VIR_DOMAIN_PROCESS_SIGNAL_VTALRM     = 26, /* SIGVTALRM */
    VIR_DOMAIN_PROCESS_SIGNAL_PROF       = 27, /* SIGPROF */
    VIR_DOMAIN_PROCESS_SIGNAL_WINCH      = 28, /* Not in POSIX (SIGWINCH on Linux) */
    VIR_DOMAIN_PROCESS_SIGNAL_POLL       = 29, /* SIGPOLL (also known as SIGIO on Linux) */

    VIR_DOMAIN_PROCESS_SIGNAL_PWR        = 30, /* Not in POSIX (SIGPWR on Linux) */
    VIR_DOMAIN_PROCESS_SIGNAL_SYS        = 31, /* SIGSYS (also known as SIGUNUSED on Linux) */
    VIR_DOMAIN_PROCESS_SIGNAL_RT0        = 32, /* SIGRTMIN */
    VIR_DOMAIN_PROCESS_SIGNAL_RT1        = 33, /* SIGRTMIN + 1 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT2        = 34, /* SIGRTMIN + 2 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT3        = 35, /* SIGRTMIN + 3 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT4        = 36, /* SIGRTMIN + 4 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT5        = 37, /* SIGRTMIN + 5 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT6        = 38, /* SIGRTMIN + 6 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT7        = 39, /* SIGRTMIN + 7 */

    VIR_DOMAIN_PROCESS_SIGNAL_RT8        = 40, /* SIGRTMIN + 8 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT9        = 41, /* SIGRTMIN + 9 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT10       = 42, /* SIGRTMIN + 10 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT11       = 43, /* SIGRTMIN + 11 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT12       = 44, /* SIGRTMIN + 12 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT13       = 45, /* SIGRTMIN + 13 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT14       = 46, /* SIGRTMIN + 14 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT15       = 47, /* SIGRTMIN + 15 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT16       = 48, /* SIGRTMIN + 16 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT17       = 49, /* SIGRTMIN + 17 */

    VIR_DOMAIN_PROCESS_SIGNAL_RT18       = 50, /* SIGRTMIN + 18 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT19       = 51, /* SIGRTMIN + 19 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT20       = 52, /* SIGRTMIN + 20 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT21       = 53, /* SIGRTMIN + 21 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT22       = 54, /* SIGRTMIN + 22 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT23       = 55, /* SIGRTMIN + 23 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT24       = 56, /* SIGRTMIN + 24 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT25       = 57, /* SIGRTMIN + 25 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT26       = 58, /* SIGRTMIN + 26 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT27       = 59, /* SIGRTMIN + 27 */

    VIR_DOMAIN_PROCESS_SIGNAL_RT28       = 60, /* SIGRTMIN + 28 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT29       = 61, /* SIGRTMIN + 29 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT30       = 62, /* SIGRTMIN + 30 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT31       = 63, /* SIGRTMIN + 31 */
    VIR_DOMAIN_PROCESS_SIGNAL_RT32       = 64, /* SIGRTMIN + 32 / SIGRTMAX */

    VIR_DOMAIN_PROCESS_SIGNAL_LAST
} virDomainProcessSignal;

int virDomainSendProcessSignal(virDomainPtr domain,
                               long long pid_value,
                               unsigned int signum,
                               unsigned int flags);

virDomainPtr            virDomainCreateLinux    (virConnectPtr conn,
                                                 const char *xmlDesc,
                                                 unsigned int flags);



typedef struct _virNodeDevice virNodeDevice;


typedef virNodeDevice *virNodeDevicePtr;


int                     virNodeNumOfDevices     (virConnectPtr conn,
                                                 const char *cap,
                                                 unsigned int flags);

int                     virNodeListDevices      (virConnectPtr conn,
                                                 const char *cap,
                                                 char **const names,
                                                 int maxnames,
                                                 unsigned int flags);
typedef enum {
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_SYSTEM        = 1 << 0,  /* System capability */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_PCI_DEV       = 1 << 1,  /* PCI device */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_USB_DEV       = 1 << 2,  /* USB device */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_USB_INTERFACE = 1 << 3,  /* USB interface */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_NET           = 1 << 4,  /* Network device */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_SCSI_HOST     = 1 << 5,  /* SCSI Host Bus Adapter */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_SCSI_TARGET   = 1 << 6,  /* SCSI Target */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_SCSI          = 1 << 7,  /* SCSI device */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_STORAGE       = 1 << 8,  /* Storage device */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_FC_HOST       = 1 << 9,  /* FC Host Bus Adapter */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_VPORTS        = 1 << 10, /* Capable of vport */
    VIR_CONNECT_LIST_NODE_DEVICES_CAP_SCSI_GENERIC  = 1 << 11, /* Capable of scsi_generic */
} virConnectListAllNodeDeviceFlags;

int                     virConnectListAllNodeDevices (virConnectPtr conn,
                                                      virNodeDevicePtr **devices,
                                                      unsigned int flags);

virNodeDevicePtr        virNodeDeviceLookupByName (virConnectPtr conn,
                                                   const char *name);

virNodeDevicePtr        virNodeDeviceLookupSCSIHostByWWN (virConnectPtr conn,
                                                          const char *wwnn,
                                                          const char *wwpn,
                                                          unsigned int flags);

const char *            virNodeDeviceGetName     (virNodeDevicePtr dev);

const char *            virNodeDeviceGetParent   (virNodeDevicePtr dev);

int                     virNodeDeviceNumOfCaps   (virNodeDevicePtr dev);

int                     virNodeDeviceListCaps    (virNodeDevicePtr dev,
                                                  char **const names,
                                                  int maxnames);

char *                  virNodeDeviceGetXMLDesc (virNodeDevicePtr dev,
                                                 unsigned int flags);

int                     virNodeDeviceRef        (virNodeDevicePtr dev);
int                     virNodeDeviceFree       (virNodeDevicePtr dev);

int                     virNodeDeviceDettach    (virNodeDevicePtr dev);
int                     virNodeDeviceDetachFlags(virNodeDevicePtr dev,
                                                 const char *driverName,
                                                 unsigned int flags);
int                     virNodeDeviceReAttach   (virNodeDevicePtr dev);
int                     virNodeDeviceReset      (virNodeDevicePtr dev);

virNodeDevicePtr        virNodeDeviceCreateXML  (virConnectPtr conn,
                                                 const char *xmlDesc,
                                                 unsigned int flags);

int                     virNodeDeviceDestroy    (virNodeDevicePtr dev);


typedef enum {
    VIR_DOMAIN_EVENT_DEFINED = 0,
    VIR_DOMAIN_EVENT_UNDEFINED = 1,
    VIR_DOMAIN_EVENT_STARTED = 2,
    VIR_DOMAIN_EVENT_SUSPENDED = 3,
    VIR_DOMAIN_EVENT_RESUMED = 4,
    VIR_DOMAIN_EVENT_STOPPED = 5,
    VIR_DOMAIN_EVENT_SHUTDOWN = 6,
    VIR_DOMAIN_EVENT_PMSUSPENDED = 7,
    VIR_DOMAIN_EVENT_CRASHED = 8,

    VIR_DOMAIN_EVENT_LAST
} virDomainEventType;

typedef enum {
    VIR_DOMAIN_EVENT_DEFINED_ADDED = 0,     /* Newly created config file */
    VIR_DOMAIN_EVENT_DEFINED_UPDATED = 1,   /* Changed config file */

    VIR_DOMAIN_EVENT_DEFINED_LAST
} virDomainEventDefinedDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_UNDEFINED_REMOVED = 0, /* Deleted the config file */

    VIR_DOMAIN_EVENT_UNDEFINED_LAST
} virDomainEventUndefinedDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_STARTED_BOOTED = 0,   /* Normal startup from boot */
    VIR_DOMAIN_EVENT_STARTED_MIGRATED = 1, /* Incoming migration from another host */
    VIR_DOMAIN_EVENT_STARTED_RESTORED = 2, /* Restored from a state file */
    VIR_DOMAIN_EVENT_STARTED_FROM_SNAPSHOT = 3, /* Restored from snapshot */
    VIR_DOMAIN_EVENT_STARTED_WAKEUP = 4,   /* Started due to wakeup event */

    VIR_DOMAIN_EVENT_STARTED_LAST
} virDomainEventStartedDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_SUSPENDED_PAUSED = 0,   /* Normal suspend due to admin pause */
    VIR_DOMAIN_EVENT_SUSPENDED_MIGRATED = 1, /* Suspended for offline migration */
    VIR_DOMAIN_EVENT_SUSPENDED_IOERROR = 2,  /* Suspended due to a disk I/O error */
    VIR_DOMAIN_EVENT_SUSPENDED_WATCHDOG = 3,  /* Suspended due to a watchdog firing */
    VIR_DOMAIN_EVENT_SUSPENDED_RESTORED = 4,  /* Restored from paused state file */
    VIR_DOMAIN_EVENT_SUSPENDED_FROM_SNAPSHOT = 5, /* Restored from paused snapshot */
    VIR_DOMAIN_EVENT_SUSPENDED_API_ERROR = 6, /* suspended after failure during libvirt API call */

    VIR_DOMAIN_EVENT_SUSPENDED_LAST
} virDomainEventSuspendedDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_RESUMED_UNPAUSED = 0,   /* Normal resume due to admin unpause */
    VIR_DOMAIN_EVENT_RESUMED_MIGRATED = 1,   /* Resumed for completion of migration */
    VIR_DOMAIN_EVENT_RESUMED_FROM_SNAPSHOT = 2, /* Resumed from snapshot */

    VIR_DOMAIN_EVENT_RESUMED_LAST
} virDomainEventResumedDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_STOPPED_SHUTDOWN = 0,  /* Normal shutdown */
    VIR_DOMAIN_EVENT_STOPPED_DESTROYED = 1, /* Forced poweroff from host */
    VIR_DOMAIN_EVENT_STOPPED_CRASHED = 2,   /* Guest crashed */
    VIR_DOMAIN_EVENT_STOPPED_MIGRATED = 3,  /* Migrated off to another host */
    VIR_DOMAIN_EVENT_STOPPED_SAVED = 4,     /* Saved to a state file */
    VIR_DOMAIN_EVENT_STOPPED_FAILED = 5,    /* Host emulator/mgmt failed */
    VIR_DOMAIN_EVENT_STOPPED_FROM_SNAPSHOT = 6, /* offline snapshot loaded */

    VIR_DOMAIN_EVENT_STOPPED_LAST
} virDomainEventStoppedDetailType;


typedef enum {
    VIR_DOMAIN_EVENT_SHUTDOWN_FINISHED = 0, /* Guest finished shutdown sequence */

    VIR_DOMAIN_EVENT_SHUTDOWN_LAST
} virDomainEventShutdownDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_PMSUSPENDED_MEMORY = 0, /* Guest was PM suspended to memory */
    VIR_DOMAIN_EVENT_PMSUSPENDED_DISK = 1, /* Guest was PM suspended to disk */

    VIR_DOMAIN_EVENT_PMSUSPENDED_LAST
} virDomainEventPMSuspendedDetailType;

typedef enum {
    VIR_DOMAIN_EVENT_CRASHED_PANICKED = 0, /* Guest was panicked */

    VIR_DOMAIN_EVENT_CRASHED_LAST
} virDomainEventCrashedDetailType;

typedef int (*virConnectDomainEventCallback)(virConnectPtr conn,
                                             virDomainPtr dom,
                                             int event,
                                             int detail,
                                             void *opaque);

int virConnectDomainEventRegister(virConnectPtr conn,
                                  virConnectDomainEventCallback cb,
                                  void *opaque,
                                  virFreeCallback freecb);

int virConnectDomainEventDeregister(virConnectPtr conn,
                                    virConnectDomainEventCallback cb);


typedef enum {
    VIR_EVENT_HANDLE_READABLE  = (1 << 0),
    VIR_EVENT_HANDLE_WRITABLE  = (1 << 1),
    VIR_EVENT_HANDLE_ERROR     = (1 << 2),
    VIR_EVENT_HANDLE_HANGUP    = (1 << 3),
} virEventHandleType;

typedef void (*virEventHandleCallback)(int watch, int fd, int events, void *opaque);

typedef int (*virEventAddHandleFunc)(int fd, int event,
                                     virEventHandleCallback cb,
                                     void *opaque,
                                     virFreeCallback ff);

typedef void (*virEventUpdateHandleFunc)(int watch, int event);

typedef int (*virEventRemoveHandleFunc)(int watch);

typedef void (*virEventTimeoutCallback)(int timer, void *opaque);

typedef int (*virEventAddTimeoutFunc)(int timeout,
                                      virEventTimeoutCallback cb,
                                      void *opaque,
                                      virFreeCallback ff);

typedef void (*virEventUpdateTimeoutFunc)(int timer, int timeout);

typedef int (*virEventRemoveTimeoutFunc)(int timer);

void virEventRegisterImpl(virEventAddHandleFunc addHandle,
                          virEventUpdateHandleFunc updateHandle,
                          virEventRemoveHandleFunc removeHandle,
                          virEventAddTimeoutFunc addTimeout,
                          virEventUpdateTimeoutFunc updateTimeout,
                          virEventRemoveTimeoutFunc removeTimeout);

int virEventRegisterDefaultImpl(void);
int virEventRunDefaultImpl(void);

int virEventAddHandle(int fd, int events,
                      virEventHandleCallback cb,
                      void *opaque,
                      virFreeCallback ff);
void virEventUpdateHandle(int watch, int events);
int virEventRemoveHandle(int watch);

int virEventAddTimeout(int frequency,
                       virEventTimeoutCallback cb,
                       void *opaque,
                       virFreeCallback ff);
void virEventUpdateTimeout(int timer, int frequency);
int virEventRemoveTimeout(int timer);


typedef struct _virSecret virSecret;
typedef virSecret *virSecretPtr;

typedef enum {
    VIR_SECRET_USAGE_TYPE_NONE = 0,
    VIR_SECRET_USAGE_TYPE_VOLUME = 1,
    VIR_SECRET_USAGE_TYPE_CEPH = 2,
    VIR_SECRET_USAGE_TYPE_ISCSI = 3,

    VIR_SECRET_USAGE_TYPE_LAST
    /*
     * NB: this enum value will increase over time as new events are
     * added to the libvirt API. It reflects the last secret owner ID
     * supported by this version of the libvirt API.
     */
} virSecretUsageType;

virConnectPtr           virSecretGetConnect     (virSecretPtr secret);
int                     virConnectNumOfSecrets  (virConnectPtr conn);
int                     virConnectListSecrets   (virConnectPtr conn,
                                                 char **uuids,
                                                 int maxuuids);

typedef enum {
    VIR_CONNECT_LIST_SECRETS_EPHEMERAL    = 1 << 0, /* kept in memory, never
                                                       stored persistently */
    VIR_CONNECT_LIST_SECRETS_NO_EPHEMERAL = 1 << 1,

    VIR_CONNECT_LIST_SECRETS_PRIVATE      = 1 << 2, /* not revealed to any caller
                                                       of libvirt, nor to any other
                                                       node */
    VIR_CONNECT_LIST_SECRETS_NO_PRIVATE   = 1 << 3,
} virConnectListAllSecretsFlags;

int                     virConnectListAllSecrets(virConnectPtr conn,
                                                 virSecretPtr **secrets,
                                                 unsigned int flags);
virSecretPtr            virSecretLookupByUUID(virConnectPtr conn,
                                              const unsigned char *uuid);
virSecretPtr            virSecretLookupByUUIDString(virConnectPtr conn,
                                                    const char *uuid);
virSecretPtr            virSecretLookupByUsage(virConnectPtr conn,
                                               int usageType,
                                               const char *usageID);
virSecretPtr            virSecretDefineXML      (virConnectPtr conn,
                                                 const char *xml,
                                                 unsigned int flags);
int                     virSecretGetUUID        (virSecretPtr secret,
                                                 unsigned char *buf);
int                     virSecretGetUUIDString  (virSecretPtr secret,
                                                 char *buf);
int                     virSecretGetUsageType   (virSecretPtr secret);
const char *            virSecretGetUsageID     (virSecretPtr secret);
char *                  virSecretGetXMLDesc     (virSecretPtr secret,
                                                 unsigned int flags);
int                     virSecretSetValue       (virSecretPtr secret,
                                                 const unsigned char *value,
                                                 size_t value_size,
                                                 unsigned int flags);
unsigned char *         virSecretGetValue       (virSecretPtr secret,
                                                 size_t *value_size,
                                                 unsigned int flags);
int                     virSecretUndefine       (virSecretPtr secret);
int                     virSecretRef            (virSecretPtr secret);
int                     virSecretFree           (virSecretPtr secret);

typedef enum {
    VIR_STREAM_NONBLOCK = (1 << 0),
} virStreamFlags;

virStreamPtr virStreamNew(virConnectPtr conn,
                          unsigned int flags);
int virStreamRef(virStreamPtr st);

int virStreamSend(virStreamPtr st,
                  const char *data,
                  size_t nbytes);

int virStreamRecv(virStreamPtr st,
                  char *data,
                  size_t nbytes);


typedef int (*virStreamSourceFunc)(virStreamPtr st,
                                   char *data,
                                   size_t nbytes,
                                   void *opaque);

int virStreamSendAll(virStreamPtr st,
                     virStreamSourceFunc handler,
                     void *opaque);

typedef int (*virStreamSinkFunc)(virStreamPtr st,
                                 const char *data,
                                 size_t nbytes,
                                 void *opaque);

int virStreamRecvAll(virStreamPtr st,
                     virStreamSinkFunc handler,
                     void *opaque);

typedef enum {
    VIR_STREAM_EVENT_READABLE  = (1 << 0),
    VIR_STREAM_EVENT_WRITABLE  = (1 << 1),
    VIR_STREAM_EVENT_ERROR     = (1 << 2),
    VIR_STREAM_EVENT_HANGUP    = (1 << 3),
} virStreamEventType;


typedef void (*virStreamEventCallback)(virStreamPtr stream, int events, void *opaque);

int virStreamEventAddCallback(virStreamPtr stream,
                              int events,
                              virStreamEventCallback cb,
                              void *opaque,
                              virFreeCallback ff);

int virStreamEventUpdateCallback(virStreamPtr stream,
                                 int events);

int virStreamEventRemoveCallback(virStreamPtr stream);


int virStreamFinish(virStreamPtr st);
int virStreamAbort(virStreamPtr st);

int virStreamFree(virStreamPtr st);


int virDomainIsActive(virDomainPtr dom);
int virDomainIsPersistent(virDomainPtr dom);
int virDomainIsUpdated(virDomainPtr dom);

int virNetworkIsActive(virNetworkPtr net);
int virNetworkIsPersistent(virNetworkPtr net);

int virStoragePoolIsActive(virStoragePoolPtr pool);
int virStoragePoolIsPersistent(virStoragePoolPtr pool);

int virInterfaceIsActive(virInterfacePtr iface);

int virConnectIsEncrypted(virConnectPtr conn);
int virConnectIsSecure(virConnectPtr conn);
int virConnectIsAlive(virConnectPtr conn);


typedef enum {
    VIR_CPU_COMPARE_ERROR           = -1,
    VIR_CPU_COMPARE_INCOMPATIBLE    = 0,
    VIR_CPU_COMPARE_IDENTICAL       = 1,
    VIR_CPU_COMPARE_SUPERSET        = 2,

    VIR_CPU_COMPARE_LAST
} virCPUCompareResult;

int virConnectCompareCPU(virConnectPtr conn,
                         const char *xmlDesc,
                         unsigned int flags);

int virConnectGetCPUModelNames(virConnectPtr conn,
                               const char *arch,
                               char ***models,
                               unsigned int flags);

typedef enum {
    VIR_CONNECT_BASELINE_CPU_EXPAND_FEATURES  = (1 << 0),  /* show all features */
} virConnectBaselineCPUFlags;

char *virConnectBaselineCPU(virConnectPtr conn,
                            const char **xmlCPUs,
                            unsigned int ncpus,
                            unsigned int flags);

typedef enum {
    VIR_DOMAIN_JOB_NONE      = 0, /* No job is active */
    VIR_DOMAIN_JOB_BOUNDED   = 1, /* Job with a finite completion time */
    VIR_DOMAIN_JOB_UNBOUNDED = 2, /* Job without a finite completion time */
    VIR_DOMAIN_JOB_COMPLETED = 3, /* Job has finished, but isn't cleaned up */
    VIR_DOMAIN_JOB_FAILED    = 4, /* Job hit error, but isn't cleaned up */
    VIR_DOMAIN_JOB_CANCELLED = 5, /* Job was aborted, but isn't cleaned up */

    VIR_DOMAIN_JOB_LAST
} virDomainJobType;

typedef struct _virDomainJobInfo virDomainJobInfo;
typedef virDomainJobInfo *virDomainJobInfoPtr;
struct _virDomainJobInfo {
    /* One of virDomainJobType */
    int type;

    /* Time is measured in milliseconds */
    unsigned long long timeElapsed;    /* Always set */
    unsigned long long timeRemaining;  /* Only for VIR_DOMAIN_JOB_BOUNDED */

    /* Data is measured in bytes unless otherwise specified
     * and is measuring the job as a whole.
     *
     * For VIR_DOMAIN_JOB_UNBOUNDED, dataTotal may be less
     * than the final sum of dataProcessed + dataRemaining
     * in the event that the hypervisor has to repeat some
     * data, such as due to dirtied pages during migration.
     *
     * For VIR_DOMAIN_JOB_BOUNDED, dataTotal shall always
     * equal the sum of dataProcessed + dataRemaining.
     */
    unsigned long long dataTotal;
    unsigned long long dataProcessed;
    unsigned long long dataRemaining;

    /* As above, but only tracking guest memory progress */
    unsigned long long memTotal;
    unsigned long long memProcessed;
    unsigned long long memRemaining;

    /* As above, but only tracking guest disk file progress */
    unsigned long long fileTotal;
    unsigned long long fileProcessed;
    unsigned long long fileRemaining;
};

int virDomainGetJobInfo(virDomainPtr dom,
                        virDomainJobInfoPtr info);
int virDomainGetJobStats(virDomainPtr domain,
                         int *type,
                         virTypedParameterPtr *params,
                         int *nparams,
                         unsigned int flags);
int virDomainAbortJob(virDomainPtr dom);



typedef struct _virDomainSnapshot virDomainSnapshot;

typedef virDomainSnapshot *virDomainSnapshotPtr;

const char *virDomainSnapshotGetName(virDomainSnapshotPtr snapshot);
virDomainPtr virDomainSnapshotGetDomain(virDomainSnapshotPtr snapshot);
virConnectPtr virDomainSnapshotGetConnect(virDomainSnapshotPtr snapshot);

typedef enum {
    VIR_DOMAIN_SNAPSHOT_CREATE_REDEFINE    = (1 << 0), /* Restore or alter
                                                          metadata */
    VIR_DOMAIN_SNAPSHOT_CREATE_CURRENT     = (1 << 1), /* With redefine, make
                                                          snapshot current */
    VIR_DOMAIN_SNAPSHOT_CREATE_NO_METADATA = (1 << 2), /* Make snapshot without
                                                          remembering it */
    VIR_DOMAIN_SNAPSHOT_CREATE_HALT        = (1 << 3), /* Stop running guest
                                                          after snapshot */
    VIR_DOMAIN_SNAPSHOT_CREATE_DISK_ONLY   = (1 << 4), /* disk snapshot, not
                                                          system checkpoint */
    VIR_DOMAIN_SNAPSHOT_CREATE_REUSE_EXT   = (1 << 5), /* reuse any existing
                                                          external files */
    VIR_DOMAIN_SNAPSHOT_CREATE_QUIESCE     = (1 << 6), /* use guest agent to
                                                          quiesce all mounted
                                                          file systems within
                                                          the domain */
    VIR_DOMAIN_SNAPSHOT_CREATE_ATOMIC      = (1 << 7), /* atomically avoid
                                                          partial changes */
    VIR_DOMAIN_SNAPSHOT_CREATE_LIVE        = (1 << 8), /* create the snapshot
                                                          while the guest is
                                                          running */
} virDomainSnapshotCreateFlags;

virDomainSnapshotPtr virDomainSnapshotCreateXML(virDomainPtr domain,
                                                const char *xmlDesc,
                                                unsigned int flags);

char *virDomainSnapshotGetXMLDesc(virDomainSnapshotPtr snapshot,
                                  unsigned int flags);

typedef enum {
    VIR_DOMAIN_SNAPSHOT_LIST_ROOTS       = (1 << 0), /* Filter by snapshots
                                                        with no parents, when
                                                        listing a domain */
    VIR_DOMAIN_SNAPSHOT_LIST_DESCENDANTS = (1 << 0), /* List all descendants,
                                                        not just children, when
                                                        listing a snapshot */

    /* For historical reasons, groups do not use contiguous bits.  */

    VIR_DOMAIN_SNAPSHOT_LIST_LEAVES      = (1 << 2), /* Filter by snapshots
                                                        with no children */
    VIR_DOMAIN_SNAPSHOT_LIST_NO_LEAVES   = (1 << 3), /* Filter by snapshots
                                                        that have children */

    VIR_DOMAIN_SNAPSHOT_LIST_METADATA    = (1 << 1), /* Filter by snapshots
                                                        which have metadata */
    VIR_DOMAIN_SNAPSHOT_LIST_NO_METADATA = (1 << 4), /* Filter by snapshots
                                                        with no metadata */

    VIR_DOMAIN_SNAPSHOT_LIST_INACTIVE    = (1 << 5), /* Filter by snapshots
                                                        taken while guest was
                                                        shut off */
    VIR_DOMAIN_SNAPSHOT_LIST_ACTIVE      = (1 << 6), /* Filter by snapshots
                                                        taken while guest was
                                                        active, and with
                                                        memory state */
    VIR_DOMAIN_SNAPSHOT_LIST_DISK_ONLY   = (1 << 7), /* Filter by snapshots
                                                        taken while guest was
                                                        active, but without
                                                        memory state */

    VIR_DOMAIN_SNAPSHOT_LIST_INTERNAL    = (1 << 8), /* Filter by snapshots
                                                        stored internal to
                                                        disk images */
    VIR_DOMAIN_SNAPSHOT_LIST_EXTERNAL    = (1 << 9), /* Filter by snapshots
                                                        that use files external
                                                        to disk images */
} virDomainSnapshotListFlags;

int virDomainSnapshotNum(virDomainPtr domain, unsigned int flags);

int virDomainSnapshotListNames(virDomainPtr domain, char **names, int nameslen,
                               unsigned int flags);

int virDomainListAllSnapshots(virDomainPtr domain,
                              virDomainSnapshotPtr **snaps,
                              unsigned int flags);

int virDomainSnapshotNumChildren(virDomainSnapshotPtr snapshot,
                                 unsigned int flags);

int virDomainSnapshotListChildrenNames(virDomainSnapshotPtr snapshot,
                                       char **names, int nameslen,
                                       unsigned int flags);

int virDomainSnapshotListAllChildren(virDomainSnapshotPtr snapshot,
                                     virDomainSnapshotPtr **snaps,
                                     unsigned int flags);

virDomainSnapshotPtr virDomainSnapshotLookupByName(virDomainPtr domain,
                                                   const char *name,
                                                   unsigned int flags);

int virDomainHasCurrentSnapshot(virDomainPtr domain, unsigned int flags);

virDomainSnapshotPtr virDomainSnapshotCurrent(virDomainPtr domain,
                                              unsigned int flags);

virDomainSnapshotPtr virDomainSnapshotGetParent(virDomainSnapshotPtr snapshot,
                                                unsigned int flags);

int virDomainSnapshotIsCurrent(virDomainSnapshotPtr snapshot,
                               unsigned int flags);

int virDomainSnapshotHasMetadata(virDomainSnapshotPtr snapshot,
                                 unsigned int flags);

typedef enum {
    VIR_DOMAIN_SNAPSHOT_REVERT_RUNNING = 1 << 0, /* Run after revert */
    VIR_DOMAIN_SNAPSHOT_REVERT_PAUSED  = 1 << 1, /* Pause after revert */
    VIR_DOMAIN_SNAPSHOT_REVERT_FORCE   = 1 << 2, /* Allow risky reverts */
} virDomainSnapshotRevertFlags;

int virDomainRevertToSnapshot(virDomainSnapshotPtr snapshot,
                              unsigned int flags);

typedef enum {
    VIR_DOMAIN_SNAPSHOT_DELETE_CHILDREN      = (1 << 0), /* Also delete children */
    VIR_DOMAIN_SNAPSHOT_DELETE_METADATA_ONLY = (1 << 1), /* Delete just metadata */
    VIR_DOMAIN_SNAPSHOT_DELETE_CHILDREN_ONLY = (1 << 2), /* Delete just children */
} virDomainSnapshotDeleteFlags;

int virDomainSnapshotDelete(virDomainSnapshotPtr snapshot,
                            unsigned int flags);

int virDomainSnapshotRef(virDomainSnapshotPtr snapshot);
int virDomainSnapshotFree(virDomainSnapshotPtr snapshot);

typedef void (*virConnectDomainEventGenericCallback)(virConnectPtr conn,
                                                     virDomainPtr dom,
                                                     void *opaque);

typedef void (*virConnectDomainEventRTCChangeCallback)(virConnectPtr conn,
                                                       virDomainPtr dom,
                                                       long long utcoffset,
                                                       void *opaque);

typedef enum {
    VIR_DOMAIN_EVENT_WATCHDOG_NONE = 0, /* No action, watchdog ignored */
    VIR_DOMAIN_EVENT_WATCHDOG_PAUSE,    /* Guest CPUs are paused */
    VIR_DOMAIN_EVENT_WATCHDOG_RESET,    /* Guest CPUs are reset */
    VIR_DOMAIN_EVENT_WATCHDOG_POWEROFF, /* Guest is forcibly powered off */
    VIR_DOMAIN_EVENT_WATCHDOG_SHUTDOWN, /* Guest is requested to gracefully shutdown */
    VIR_DOMAIN_EVENT_WATCHDOG_DEBUG,    /* No action, a debug message logged */

    VIR_DOMAIN_EVENT_WATCHDOG_LAST
} virDomainEventWatchdogAction;

typedef void (*virConnectDomainEventWatchdogCallback)(virConnectPtr conn,
                                                      virDomainPtr dom,
                                                      int action,
                                                      void *opaque);

typedef enum {
    VIR_DOMAIN_EVENT_IO_ERROR_NONE = 0,  /* No action, IO error ignored */
    VIR_DOMAIN_EVENT_IO_ERROR_PAUSE,     /* Guest CPUs are paused */
    VIR_DOMAIN_EVENT_IO_ERROR_REPORT,    /* IO error reported to guest OS */

    VIR_DOMAIN_EVENT_IO_ERROR_LAST
} virDomainEventIOErrorAction;


typedef void (*virConnectDomainEventIOErrorCallback)(virConnectPtr conn,
                                                     virDomainPtr dom,
                                                     const char *srcPath,
                                                     const char *devAlias,
                                                     int action,
                                                     void *opaque);

typedef void (*virConnectDomainEventIOErrorReasonCallback)(virConnectPtr conn,
                                                           virDomainPtr dom,
                                                           const char *srcPath,
                                                           const char *devAlias,
                                                           int action,
                                                           const char *reason,
                                                           void *opaque);

typedef enum {
    VIR_DOMAIN_EVENT_GRAPHICS_CONNECT = 0,  /* Initial socket connection established */
    VIR_DOMAIN_EVENT_GRAPHICS_INITIALIZE,   /* Authentication & setup completed */
    VIR_DOMAIN_EVENT_GRAPHICS_DISCONNECT,   /* Final socket disconnection */

    VIR_DOMAIN_EVENT_GRAPHICS_LAST
} virDomainEventGraphicsPhase;

typedef enum {
    VIR_DOMAIN_EVENT_GRAPHICS_ADDRESS_IPV4,  /* IPv4 address */
    VIR_DOMAIN_EVENT_GRAPHICS_ADDRESS_IPV6,  /* IPv6 address */
    VIR_DOMAIN_EVENT_GRAPHICS_ADDRESS_UNIX,  /* UNIX socket path */

    VIR_DOMAIN_EVENT_GRAPHICS_ADDRESS_LAST
} virDomainEventGraphicsAddressType;


struct _virDomainEventGraphicsAddress {
    int family;               /* Address family, virDomainEventGraphicsAddressType */
    char *node;               /* Address of node (eg IP address, or UNIX path) */
    char *service;            /* Service name/number (eg TCP port, or NULL) */
};
typedef struct _virDomainEventGraphicsAddress virDomainEventGraphicsAddress;
typedef virDomainEventGraphicsAddress *virDomainEventGraphicsAddressPtr;


struct _virDomainEventGraphicsSubjectIdentity {
    char *type;     /* Type of identity */
    char *name;     /* Identity value */
};
typedef struct _virDomainEventGraphicsSubjectIdentity virDomainEventGraphicsSubjectIdentity;
typedef virDomainEventGraphicsSubjectIdentity *virDomainEventGraphicsSubjectIdentityPtr;


struct _virDomainEventGraphicsSubject {
    int nidentity;                                /* Number of identities in array*/
    virDomainEventGraphicsSubjectIdentityPtr identities; /* Array of identities for subject */
};
typedef struct _virDomainEventGraphicsSubject virDomainEventGraphicsSubject;
typedef virDomainEventGraphicsSubject *virDomainEventGraphicsSubjectPtr;


typedef void (*virConnectDomainEventGraphicsCallback)(virConnectPtr conn,
                                                      virDomainPtr dom,
                                                      int phase,
                                                      const virDomainEventGraphicsAddress *local,
                                                      const virDomainEventGraphicsAddress *remote,
                                                      const char *authScheme,
                                                      const virDomainEventGraphicsSubject *subject,
                                                      void *opaque);

typedef enum {
    VIR_DOMAIN_BLOCK_JOB_COMPLETED = 0,
    VIR_DOMAIN_BLOCK_JOB_FAILED = 1,
    VIR_DOMAIN_BLOCK_JOB_CANCELED = 2,
    VIR_DOMAIN_BLOCK_JOB_READY = 3,

    VIR_DOMAIN_BLOCK_JOB_LAST
} virConnectDomainEventBlockJobStatus;

typedef void (*virConnectDomainEventBlockJobCallback)(virConnectPtr conn,
                                                      virDomainPtr dom,
                                                      const char *disk,
                                                      int type,
                                                      int status,
                                                      void *opaque);

typedef enum {
    VIR_DOMAIN_EVENT_DISK_CHANGE_MISSING_ON_START = 0, /* oldSrcPath is set */
    VIR_DOMAIN_EVENT_DISK_DROP_MISSING_ON_START = 1,

    VIR_DOMAIN_EVENT_DISK_CHANGE_LAST
} virConnectDomainEventDiskChangeReason;

typedef void (*virConnectDomainEventDiskChangeCallback)(virConnectPtr conn,
                                                        virDomainPtr dom,
                                                        const char *oldSrcPath,
                                                        const char *newSrcPath,
                                                        const char *devAlias,
                                                        int reason,
                                                        void *opaque);

typedef enum {
    VIR_DOMAIN_EVENT_TRAY_CHANGE_OPEN = 0,
    VIR_DOMAIN_EVENT_TRAY_CHANGE_CLOSE,

    VIR_DOMAIN_EVENT_TRAY_CHANGE_LAST
} virDomainEventTrayChangeReason;

typedef void (*virConnectDomainEventTrayChangeCallback)(virConnectPtr conn,
                                                        virDomainPtr dom,
                                                        const char *devAlias,
                                                        int reason,
                                                        void *opaque);

typedef void (*virConnectDomainEventPMWakeupCallback)(virConnectPtr conn,
                                                      virDomainPtr dom,
                                                      int reason,
                                                      void *opaque);

typedef void (*virConnectDomainEventPMSuspendCallback)(virConnectPtr conn,
                                                       virDomainPtr dom,
                                                       int reason,
                                                       void *opaque);


typedef void (*virConnectDomainEventBalloonChangeCallback)(virConnectPtr conn,
                                                           virDomainPtr dom,
                                                           unsigned long long actual,
                                                           void *opaque);

typedef void (*virConnectDomainEventPMSuspendDiskCallback)(virConnectPtr conn,
                                                           virDomainPtr dom,
                                                           int reason,
                                                           void *opaque);

typedef void (*virConnectDomainEventDeviceRemovedCallback)(virConnectPtr conn,
                                                           virDomainPtr dom,
                                                           const char *devAlias,
                                                           void *opaque);




typedef enum {
    VIR_DOMAIN_EVENT_ID_LIFECYCLE = 0,       /* virConnectDomainEventCallback */
    VIR_DOMAIN_EVENT_ID_REBOOT = 1,          /* virConnectDomainEventGenericCallback */
    VIR_DOMAIN_EVENT_ID_RTC_CHANGE = 2,      /* virConnectDomainEventRTCChangeCallback */
    VIR_DOMAIN_EVENT_ID_WATCHDOG = 3,        /* virConnectDomainEventWatchdogCallback */
    VIR_DOMAIN_EVENT_ID_IO_ERROR = 4,        /* virConnectDomainEventIOErrorCallback */
    VIR_DOMAIN_EVENT_ID_GRAPHICS = 5,        /* virConnectDomainEventGraphicsCallback */
    VIR_DOMAIN_EVENT_ID_IO_ERROR_REASON = 6, /* virConnectDomainEventIOErrorReasonCallback */
    VIR_DOMAIN_EVENT_ID_CONTROL_ERROR = 7,   /* virConnectDomainEventGenericCallback */
    VIR_DOMAIN_EVENT_ID_BLOCK_JOB = 8,       /* virConnectDomainEventBlockJobCallback */
    VIR_DOMAIN_EVENT_ID_DISK_CHANGE = 9,     /* virConnectDomainEventDiskChangeCallback */
    VIR_DOMAIN_EVENT_ID_TRAY_CHANGE = 10,    /* virConnectDomainEventTrayChangeCallback */
    VIR_DOMAIN_EVENT_ID_PMWAKEUP = 11,       /* virConnectDomainEventPMWakeupCallback */
    VIR_DOMAIN_EVENT_ID_PMSUSPEND = 12,      /* virConnectDomainEventPMSuspendCallback */
    VIR_DOMAIN_EVENT_ID_BALLOON_CHANGE = 13, /* virConnectDomainEventBalloonChangeCallback */
    VIR_DOMAIN_EVENT_ID_PMSUSPEND_DISK = 14, /* virConnectDomainEventPMSuspendDiskCallback */
    VIR_DOMAIN_EVENT_ID_DEVICE_REMOVED = 15, /* virConnectDomainEventDeviceRemovedCallback */

    VIR_DOMAIN_EVENT_ID_LAST
    /*
     * NB: this enum value will increase over time as new events are
     * added to the libvirt API. It reflects the last event ID supported
     * by this version of the libvirt API.
     */
} virDomainEventID;


int virConnectDomainEventRegisterAny(virConnectPtr conn,
                                     virDomainPtr dom, /* Optional, to filter */
                                     int eventID,
                                     virConnectDomainEventGenericCallback cb,
                                     void *opaque,
                                     virFreeCallback freecb);

int virConnectDomainEventDeregisterAny(virConnectPtr conn,
                                       int callbackID);

typedef enum {
    VIR_NETWORK_EVENT_DEFINED = 0,
    VIR_NETWORK_EVENT_UNDEFINED = 1,
    VIR_NETWORK_EVENT_STARTED = 2,
    VIR_NETWORK_EVENT_STOPPED = 3,

    VIR_NETWORK_EVENT_LAST
} virNetworkEventLifecycleType;

typedef void (*virConnectNetworkEventLifecycleCallback)(virConnectPtr conn,
                                                        virNetworkPtr net,
                                                        int event,
                                                        int detail,
                                                        void *opaque);


typedef enum {
    VIR_NETWORK_EVENT_ID_LIFECYCLE = 0,       /* virConnectNetworkEventLifecycleCallback */

    VIR_NETWORK_EVENT_ID_LAST
    /*
     * NB: this enum value will increase over time as new events are
     * added to the libvirt API. It reflects the last event ID supported
     * by this version of the libvirt API.
     */
} virNetworkEventID;

typedef void (*virConnectNetworkEventGenericCallback)(virConnectPtr conn,
                                                      virNetworkPtr net,
                                                      void *opaque);

int virConnectNetworkEventRegisterAny(virConnectPtr conn,
                                      virNetworkPtr net, /* Optional, to filter */
                                      int eventID,
                                      virConnectNetworkEventGenericCallback cb,
                                      void *opaque,
                                      virFreeCallback freecb);

int virConnectNetworkEventDeregisterAny(virConnectPtr conn,
                                        int callbackID);

typedef struct _virNWFilter virNWFilter;

typedef virNWFilter *virNWFilterPtr;


int                     virConnectNumOfNWFilters (virConnectPtr conn);
int                     virConnectListNWFilters  (virConnectPtr conn,
                                                  char **const names,
                                                  int maxnames);
int                     virConnectListAllNWFilters(virConnectPtr conn,
                                                   virNWFilterPtr **filters,
                                                   unsigned int flags);
virNWFilterPtr          virNWFilterLookupByName       (virConnectPtr conn,
                                                       const char *name);
virNWFilterPtr          virNWFilterLookupByUUID       (virConnectPtr conn,
                                                       const unsigned char *uuid);
virNWFilterPtr          virNWFilterLookupByUUIDString (virConnectPtr conn,
                                                       const char *uuid);

virNWFilterPtr          virNWFilterDefineXML    (virConnectPtr conn,
                                                 const char *xmlDesc);

int                     virNWFilterUndefine     (virNWFilterPtr nwfilter);

int                     virNWFilterRef          (virNWFilterPtr nwfilter);
int                     virNWFilterFree         (virNWFilterPtr nwfilter);

const char*             virNWFilterGetName       (virNWFilterPtr nwfilter);
int                     virNWFilterGetUUID       (virNWFilterPtr nwfilter,
                                                  unsigned char *uuid);
int                     virNWFilterGetUUIDString (virNWFilterPtr nwfilter,
                                                  char *buf);
char *                  virNWFilterGetXMLDesc    (virNWFilterPtr nwfilter,
                                                  unsigned int flags);
typedef enum {

    VIR_DOMAIN_CONSOLE_FORCE = (1 << 0), /* abort a (possibly) active console
                                            connection to force a new
                                            connection */
    VIR_DOMAIN_CONSOLE_SAFE = (1 << 1), /* check if the console driver supports
                                           safe console operations */
} virDomainConsoleFlags;

int virDomainOpenConsole(virDomainPtr dom,
                         const char *devname,
                         virStreamPtr st,
                         unsigned int flags);

typedef enum {
    VIR_DOMAIN_CHANNEL_FORCE = (1 << 0), /* abort a (possibly) active channel
                                            connection to force a new
                                            connection */
} virDomainChannelFlags;

int virDomainOpenChannel(virDomainPtr dom,
                         const char *name,
                         virStreamPtr st,
                         unsigned int flags);

typedef enum {
    VIR_DOMAIN_OPEN_GRAPHICS_SKIPAUTH = (1 << 0),
} virDomainOpenGraphicsFlags;

int virDomainOpenGraphics(virDomainPtr dom,
                          unsigned int idx,
                          int fd,
                          unsigned int flags);

int virDomainInjectNMI(virDomainPtr domain, unsigned int flags);

int virDomainFSTrim(virDomainPtr dom,
                    const char *mountPoint,
                    unsigned long long minimum,
                    unsigned int flags);

int virDomainFSFreeze(virDomainPtr dom,
                      const char **mountpoints,
                      unsigned int nmountpoints,
                      unsigned int flags);

int virDomainFSThaw(virDomainPtr dom,
                    const char **mountpoints,
                    unsigned int nmountpoints,
                    unsigned int flags);

int virDomainGetTime(virDomainPtr dom,
                     long long *seconds,
                     unsigned int *nseconds,
                     unsigned int flags);

typedef enum {
    VIR_DOMAIN_TIME_SYNC = (1 << 0), /* Re-sync domain time from domain's RTC */
} virDomainSetTimeFlags;

int virDomainSetTime(virDomainPtr dom,
                     long long seconds,
                     unsigned int nseconds,
                     unsigned int flags);

typedef enum {
    VIR_DOMAIN_SCHED_FIELD_INT     = VIR_TYPED_PARAM_INT,
    VIR_DOMAIN_SCHED_FIELD_UINT    = VIR_TYPED_PARAM_UINT,
    VIR_DOMAIN_SCHED_FIELD_LLONG   = VIR_TYPED_PARAM_LLONG,
    VIR_DOMAIN_SCHED_FIELD_ULLONG  = VIR_TYPED_PARAM_ULLONG,
    VIR_DOMAIN_SCHED_FIELD_DOUBLE  = VIR_TYPED_PARAM_DOUBLE,
    VIR_DOMAIN_SCHED_FIELD_BOOLEAN = VIR_TYPED_PARAM_BOOLEAN,
} virSchedParameterType;


typedef struct _virTypedParameter virSchedParameter;

typedef virSchedParameter *virSchedParameterPtr;

typedef enum {
    VIR_DOMAIN_BLKIO_PARAM_INT     = VIR_TYPED_PARAM_INT,
    VIR_DOMAIN_BLKIO_PARAM_UINT    = VIR_TYPED_PARAM_UINT,
    VIR_DOMAIN_BLKIO_PARAM_LLONG   = VIR_TYPED_PARAM_LLONG,
    VIR_DOMAIN_BLKIO_PARAM_ULLONG  = VIR_TYPED_PARAM_ULLONG,
    VIR_DOMAIN_BLKIO_PARAM_DOUBLE  = VIR_TYPED_PARAM_DOUBLE,
    VIR_DOMAIN_BLKIO_PARAM_BOOLEAN = VIR_TYPED_PARAM_BOOLEAN,
} virBlkioParameterType;


typedef struct _virTypedParameter virBlkioParameter;

typedef virBlkioParameter *virBlkioParameterPtr;

typedef enum {
    VIR_DOMAIN_MEMORY_PARAM_INT     = VIR_TYPED_PARAM_INT,
    VIR_DOMAIN_MEMORY_PARAM_UINT    = VIR_TYPED_PARAM_UINT,
    VIR_DOMAIN_MEMORY_PARAM_LLONG   = VIR_TYPED_PARAM_LLONG,
    VIR_DOMAIN_MEMORY_PARAM_ULLONG  = VIR_TYPED_PARAM_ULLONG,
    VIR_DOMAIN_MEMORY_PARAM_DOUBLE  = VIR_TYPED_PARAM_DOUBLE,
    VIR_DOMAIN_MEMORY_PARAM_BOOLEAN = VIR_TYPED_PARAM_BOOLEAN,
} virMemoryParameterType;


typedef struct _virTypedParameter virMemoryParameter;

typedef virMemoryParameter *virMemoryParameterPtr;

]]

local states = {}

states.virDomainState = {
    VIR_DOMAIN_NOSTATE 		= 0,    
    VIR_DOMAIN_RUNNING 		= 1,    
    VIR_DOMAIN_BLOCKED 		= 2,    
    VIR_DOMAIN_PAUSED  		= 3,    
    VIR_DOMAIN_SHUTDOWN		= 4,    
    VIR_DOMAIN_SHUTOFF 		= 5,    
    VIR_DOMAIN_CRASHED 		= 6,    
    VIR_DOMAIN_PMSUSPENDED 	= 7,
} 

states.virDomainNostateReason = {
    VIR_DOMAIN_NOSTATE_UNKNOWN = 0,
} 

states.virDomainRunningReason = {
    VIR_DOMAIN_RUNNING_UNKNOWN = 0,
    VIR_DOMAIN_RUNNING_BOOTED = 1,          
    VIR_DOMAIN_RUNNING_MIGRATED = 2,        
    VIR_DOMAIN_RUNNING_RESTORED = 3,        
    VIR_DOMAIN_RUNNING_FROM_SNAPSHOT = 4,   
    VIR_DOMAIN_RUNNING_UNPAUSED = 5,        
    VIR_DOMAIN_RUNNING_MIGRATION_CANCELED = 6, 
    VIR_DOMAIN_RUNNING_SAVE_CANCELED = 7,   
    VIR_DOMAIN_RUNNING_WAKEUP = 8,          
    VIR_DOMAIN_RUNNING_CRASHED = 9,         
}

states.virDomainBlockedReason = {
    VIR_DOMAIN_BLOCKED_UNKNOWN = 0,
}

states.virDomainPausedReason = {
    VIR_DOMAIN_PAUSED_UNKNOWN = 0,      
    VIR_DOMAIN_PAUSED_USER = 1,         
    VIR_DOMAIN_PAUSED_MIGRATION = 2,    
    VIR_DOMAIN_PAUSED_SAVE = 3,         
    VIR_DOMAIN_PAUSED_DUMP = 4,         
    VIR_DOMAIN_PAUSED_IOERROR = 5,      
    VIR_DOMAIN_PAUSED_WATCHDOG = 6,     
    VIR_DOMAIN_PAUSED_FROM_SNAPSHOT = 7,
    VIR_DOMAIN_PAUSED_SHUTTING_DOWN = 8,
    VIR_DOMAIN_PAUSED_SNAPSHOT = 9,     
    VIR_DOMAIN_PAUSED_CRASHED = 10,     
} 

states.virDomainShutdownReason = {
    VIR_DOMAIN_SHUTDOWN_UNKNOWN = 0,
    VIR_DOMAIN_SHUTDOWN_USER = 1,   
}

states.virDomainShutoffReason = {
    VIR_DOMAIN_SHUTOFF_UNKNOWN = 0,      
    VIR_DOMAIN_SHUTOFF_SHUTDOWN = 1,     
    VIR_DOMAIN_SHUTOFF_DESTROYED = 2,    
    VIR_DOMAIN_SHUTOFF_CRASHED = 3,      
    VIR_DOMAIN_SHUTOFF_MIGRATED = 4,     
    VIR_DOMAIN_SHUTOFF_SAVED = 5,        
    VIR_DOMAIN_SHUTOFF_FAILED = 6,       
    VIR_DOMAIN_SHUTOFF_FROM_SNAPSHOT = 7,
} 

states.virDomainCrashedReason = {
    VIR_DOMAIN_CRASHED_UNKNOWN = 0, 
    VIR_DOMAIN_CRASHED_PANICKED = 1,
} 

states.virDomainPMSuspendedReason = {
    VIR_DOMAIN_PMSUSPENDED_UNKNOWN = 0,
} 

states.virDomainPMSuspendedDiskReason = {
    VIR_DOMAIN_PMSUSPENDED_DISK_UNKNOWN = 0,
} 

states.virDomainControlState = {
    VIR_DOMAIN_CONTROL_OK = 0,       
    VIR_DOMAIN_CONTROL_JOB = 1,      
    VIR_DOMAIN_CONTROL_OCCUPIED = 2, 
    VIR_DOMAIN_CONTROL_ERROR = 3,    
} 




local LuaVirt = {}

setmetatable(LuaVirt, {
__call = function (cls, ...)
        return cls.create(cls,...)
end,
})

function LuaVirt:create()
        local p = {}
	p.libvirt = ffi.load('libvirt')
        self.__index = self
        self.__call = function (cls, ...)
                return cls.new(cls,...)
        end
        return setmetatable(p, self)
end

LuaVirt.infoFields = {
    state = "number",
    maxMem = "number",
    memory = "number",
    nrVirtCpu = "number",
    cpuTime = "number",
}


function LuaVirt:connect(url)
local conn = self.libvirt.virConnectOpen(url);
if conn == nil then
	print "falha na conexao"
	return nil
end
self.conn = conn
end

function LuaVirt:getDomU(url)

local conn = self.libvirt.virConnectOpen(url);

print_r(conn)

local domains = self.libvirt.virConnectNumOfDomains(conn)
print(url,domains)
-- if domains == 0 then
-- 	print(url.." empty")
-- 	return {}
-- end
-- local idss =  ffi.new("int["..domains.."]", 1)
-- self.libvirt.virConnectListDomains(self.conn, idss, domains)
-- domainTable = {}
-- for i=0,domains-1 do
-- 	if idss[i] ~= 0 then
-- 		local infoU = ffi.new("virDomainInfo")
-- 		local domU  = self.libvirt.virDomainLookupByID(self.conn, idss[i])
-- 		local retU = self.libvirt.virDomainGetInfo(domU, infoU)
-- 		local nameU = ffi.string(self.libvirt.virDomainGetName(domU))
-- 		domainTable[nameU] = {}
-- 		domainTable[nameU].id = idss[i]
-- 		for field,dtype in pairs(LuaVirt.infoFields) do
-- 			if dtype == "number" then
-- 				domainTable[nameU][field] = tonumber(infoU[field])
-- 			elseif dtype == "string" then
-- 				domainTable[nameU][field] = ffi.string(infoU[field])
-- 			end
-- 		end
-- 	end
-- end
-- return domainTable
end

function LuaVirt:getCapabilities(domain,url)
if self.conn == nil then
	self:connect(url)
end
local xml = apr.xml()
local returntable = {}
local info = ffi.new("virDomainInfo")
local dom  = self.libvirt.virDomainLookupByID(self.conn, 0)
local ret = self.libvirt.virDomainGetInfo(dom, info)
local xmlcap = ffi.string(libvirt.virConnectGetCapabilities(self.conn))
-- feed the xml parser
local xmlstat = xml:feed(xmlcap)
if xmlstat == true then
	-- do the parsing
	returntable = xml:getinfo()
else
	xml:close()
	return nil, xml:geterror()
end
return returntable, xml:close()
end

function LuaVirt:getCapabilitiesAll(url)
if self.conn == nil then
	self:connect(url)
end
local idss =  ffi.new("int["..domains.."]", 1)
self.libvirt.virConnectListDomains(self.conn, idss, domains)
domainTable = {}
for i=0,domains-1 do
	if idss[i] ~= 0 then
		domainTable[idss[i]] = self:getCapabilities(domain)
	end
end
return domainTable
end

function LuaVirt:closeConn()
self.libvirt.virConnectClose(self.conn)
end

return LuaVirt
