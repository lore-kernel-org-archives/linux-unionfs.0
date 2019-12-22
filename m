Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] locks: print unsigned ino in /proc/locks
Date: Sun, 22 Dec 2019 20:45:28 +0200
Message-Id: <20191222184528.32687-1-amir73il@gmail.com>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

An ino is unsigned so export it as such in /proc/locks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Hi Jeff,

Ran into this while writing tests to verify i_ino == d_ino == st_ino on
overlayfs. In some configurations (xino=on) overlayfs sets MSB on i_ino,
so /proc/locks reports negative ino values.

BTW, the requirement for (i_ino == d_ino) came from nfsd v3 readdirplus.

Thanks,
Amir.

 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 6970f55daf54..44b6da032842 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2853,7 +2853,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 	}
 	if (inode) {
 		/* userspace relies on this representation of dev_t */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
+		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
 				MAJOR(inode->i_sb->s_dev),
 				MINOR(inode->i_sb->s_dev), inode->i_ino);
 	} else {
-- 
2.17.1
