From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/7] SELinux: The copy-up operation must have read
 permission on the lower file
Date: Wed, 05 Nov 2014 15:43:19 +0000
Message-ID: <20141105154318.2555.7052.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

The copy-up operation must have read permission on the lower file for the task
that caused the copy-up.  This helps prevent overlayfs from being used to
access something it shouldn't.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f43f07fdc028..57f9c641779f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3144,7 +3144,8 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 
 static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
 {
-	return 0;
+	const struct cred *cred = current_cred();
+	return dentry_has_perm(cred, src, FILE__OPEN | FILE__READ);
 }
 
 static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
