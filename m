From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 05/20] xattr: Remove unnecessary NULL attribute name check
Date: Mon, 22 Aug 2016 23:21:53 +0200
Message-ID: <1471900928-21588-6-git-send-email-agruenba@redhat.com>
References: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754998AbcHVVWm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2016 17:22:42 -0400
In-Reply-To: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

When NULL is passed to one of the xattr system calls as the attribute
name, copying that name from user space already fails with -EFAULT;
xattr_resolve_name is never called with a NULL attribute name.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xattr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index c243905..1f72c92 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -675,9 +675,6 @@ xattr_resolve_name(const struct xattr_handler **handlers, const char **name)
 {
 	const struct xattr_handler *handler;
 
-	if (!*name)
-		return ERR_PTR(-EINVAL);
-
 	for_each_xattr_handler(handlers, handler) {
 		const char *n;
 
-- 
2.7.4
