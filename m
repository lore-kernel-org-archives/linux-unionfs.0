Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v8 03/11] NFS NFSD: defining nl4_servers structure needed by both
Date: Thu,  1 Nov 2018 12:45:15 -0400
Message-Id: <20181101164523.41812-4-olga.kornievskaia@gmail.com>
In-Reply-To: <20181101164523.41812-1-olga.kornievskaia@gmail.com>
References: <20181101164523.41812-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

These structures are needed by COPY_NOTIFY on the client and needed
by the nfsd as well

Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 include/linux/nfs4.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 1b06f0b..4803507 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/uidgid.h>
 #include <uapi/linux/nfs4.h>
+#include <linux/sunrpc/msg_prot.h>
 
 enum nfs4_acl_whotype {
 	NFS4_ACL_WHO_NAMED = 0,
@@ -672,4 +673,27 @@ struct nfs4_op_map {
 	} u;
 };
 
+struct nfs42_netaddr {
+	char		netid[RPCBIND_MAXNETIDLEN];
+	char		addr[RPCBIND_MAXUADDRLEN + 1];
+	u32		netid_len;
+	u32		addr_len;
+};
+
+enum netloc_type4 {
+	NL4_NAME		= 1,
+	NL4_URL			= 2,
+	NL4_NETADDR		= 3,
+};
+
+struct nl4_server {
+	enum netloc_type4	nl4_type;
+	union {
+		struct { /* NL4_NAME, NL4_URL */
+			int	nl4_str_sz;
+			char	nl4_str[NFS4_OPAQUE_LIMIT + 1];
+		};
+		struct nfs42_netaddr	nl4_addr; /* NL4_NETADDR */
+	} u;
+};
 #endif
-- 
1.8.3.1
