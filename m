Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH 1/1] NFSv4: cleanup remove unused nfs4_xdev_fs_type
Date: Mon, 29 Oct 2018 13:40:47 -0400
Message-Id: <20181029174059.38326-2-olga.kornievskaia@gmail.com>
In-Reply-To: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

commit e8f25e6d6d19 "NFS: Remove the NFS v4 xdev mount function"
removed the last use of this.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/nfs/internal.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 8357ff6..ecb6d43 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -395,7 +395,6 @@ int nfs_rename(struct inode *, struct dentry *,
 extern struct file_system_type nfs_fs_type;
 extern struct file_system_type nfs_xdev_fs_type;
 #if IS_ENABLED(CONFIG_NFS_V4)
-extern struct file_system_type nfs4_xdev_fs_type;
 extern struct file_system_type nfs4_referral_fs_type;
 #endif
 bool nfs_auth_info_match(const struct nfs_auth_info *, rpc_authflavor_t);
-- 
1.8.3.1
