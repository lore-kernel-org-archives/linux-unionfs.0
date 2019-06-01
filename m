From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 067/186] ovl: do not generate duplicate fsnotify events for "fake" path
Date: Sat,  1 Jun 2019 09:14:43 -0400
Message-ID: <20190601131653.24205-67-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, Murphy Zhou <jencce.kernel@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit d989903058a83e8536cc7aadf9256a47d5c173fe ]

Overlayfs "fake" path is used for stacked file operations on underlying
files.  Operations on files with "fake" path must not generate fsnotify
events with path data, because those events have already been generated at
overlayfs layer and because the reported event->fd for fanotify marks on
underlying inode/filesystem will have the wrong path (the overlayfs path).

Link: https://lore.kernel.org/linux-fsdevel/20190423065024.12695-1-jencce.kernel@gmail.com/
Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24a..6f6eb638a320f 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -29,10 +29,11 @@ static struct file *ovl_open_realfile(const struct file *file,
 	struct inode *inode = file_inode(file);
 	struct file *realfile;
 	const struct cred *old_cred;
+	int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
 
 	old_cred = ovl_override_creds(inode->i_sb);
-	realfile = open_with_fake_path(&file->f_path, file->f_flags | O_NOATIME,
-				       realinode, current_cred());
+	realfile = open_with_fake_path(&file->f_path, flags, realinode,
+				       current_cred());
 	revert_creds(old_cred);
 
 	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
@@ -50,7 +51,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 	int err;
 
 	/* No atime modificaton on underlying */
-	flags |= O_NOATIME;
+	flags |= O_NOATIME | FMODE_NONOTIFY;
 
 	/* If some flag changed that cannot be changed then something's amiss */
 	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
-- 
2.20.1
