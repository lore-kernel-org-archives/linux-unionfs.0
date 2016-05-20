From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 01/18] xattr: Remove unnecessary NULL attribute name check
Date: Fri, 20 May 2016 13:14:18 +0200
Message-ID: <1463742875-9836-2-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

When NULL is passed to one of the xattr system calls as the attribute
name, copying that name from user space already fails with -EFAULT;
xattr_resolve_name is never called with a NULL attribute name.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xattr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index b11945e..2476acc 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -667,9 +667,6 @@ xattr_resolve_name(const struct xattr_handler **handlers, const char **name)
 {
 	const struct xattr_handler *handler;
 
-	if (!*name)
-		return NULL;
-
 	for_each_xattr_handler(handlers, handler) {
 		const char *n;
 
-- 
2.5.5

