From: Nicolas Belouin <nicolas@belouin.fr>
Subject: [RFC PATCH 1/2] security, capabilities: create CAP_TRUSTED
Date: Sat, 21 Oct 2017 15:45:57 +0200
Message-ID: <20171021134558.21195-1-nicolas__44293.7001622797$1508594261$gmane$org@belouin.fr>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:46967 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbdJUN5e (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 21 Oct 2017 09:57:34 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-ext4@vger.kernel
Cc: Nicolas Belouin <nicolas@belouin.fr>

with CAP_SYS_ADMIN being bloated, the usefulness of using it to
flag a process to be entrusted for e.g reading and writing trusted
xattr is near zero.
CAP_TRUSTED aims to provide userland with a way to mark a process as
entrusted to do specific (not specially admin-centered) actions. It
would for example allow a process to red/write the trusted xattrs.

Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
---
 include/uapi/linux/capability.h     | 6 +++++-
 security/selinux/include/classmap.h | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index ce230aa6d928..27e457b93c84 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -369,7 +369,11 @@ struct vfs_ns_cap_data {
 
 #define CAP_SYS_MOUNT		38
 
-#define CAP_LAST_CAP         CAP_SYS_MOUNT
+/* Allow read/write trusted xattr */
+
+#define CAP_TRUSTED		39
+
+#define CAP_LAST_CAP         CAP_TRUSTED
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index a873dce97fd5..f5dc8e109f5a 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -24,9 +24,10 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-		"wake_alarm", "block_suspend", "audit_read", "sys_mount"
+		"wake_alarm", "block_suspend", "audit_read", "sys_mount", \
+		"trusted"
 
-#if CAP_LAST_CAP > CAP_SYS_MOUNT
+#if CAP_LAST_CAP > CAP_TRUSTED
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
-- 
2.14.2
