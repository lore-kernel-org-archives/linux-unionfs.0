From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 05/17] sockfs: getxattr: Fail with -EOPNOTSUPP for invalid attribute names
Date: Wed, 28 Sep 2016 16:57:51 +0200
Message-ID: <1475074683-26971-6-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

The standard return value for unsupported attribute names is
-EOPNOTSUPP, as opposed to undefined but supported attributes
(-ENODATA).

Also, fail for attribute names like "system.sockprotonameXXX" and
simplify the code a bit.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 net/socket.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index a1bd161..9b3dca6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -469,27 +469,15 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 static ssize_t sockfs_getxattr(struct dentry *dentry, struct inode *inode,
 			       const char *name, void *value, size_t size)
 {
-	const char *proto_name;
-	size_t proto_size;
-	int error;
-
-	error = -ENODATA;
-	if (!strncmp(name, XATTR_NAME_SOCKPROTONAME, XATTR_NAME_SOCKPROTONAME_LEN)) {
-		proto_name = dentry->d_name.name;
-		proto_size = strlen(proto_name);
-
+	if (!strcmp(name, XATTR_NAME_SOCKPROTONAME)) {
 		if (value) {
-			error = -ERANGE;
-			if (proto_size + 1 > size)
-				goto out;
-
-			strncpy(value, proto_name, proto_size + 1);
+			if (dentry->d_name.len + 1 > size)
+				return -ERANGE;
+			memcpy(value, dentry->d_name.name, dentry->d_name.len + 1);
 		}
-		error = proto_size + 1;
+		return dentry->d_name.len + 1;
 	}
-
-out:
-	return error;
+	return -EOPNOTSUPP;
 }
 
 static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
-- 
2.7.4

