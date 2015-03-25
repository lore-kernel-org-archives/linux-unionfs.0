From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/15] VFS: Fix up missed bits of apparmor to use d_inode()
Date: Wed, 25 Mar 2015 14:43:50 +0000
Message-ID: <20150325144350.17670.56165.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
List-Id: linux-unionfs@vger.kernel.org

Fix up missed bits of apparmor to use d_inode() where the clause doesn't
match the autoconversion script RE because of brackets.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/apparmor/apparmorfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 7db9954f1af2..ad4fa49ad1db 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -365,7 +365,7 @@ void __aa_fs_profile_rmdir(struct aa_profile *profile)
 		if (!profile->dents[i])
 			continue;
 
-		r = profile->dents[i]->d_inode->i_private;
+		r = d_inode(profile->dents[i])->i_private;
 		securityfs_remove(profile->dents[i]);
 		aa_put_replacedby(r);
 		profile->dents[i] = NULL;
