Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix timestamp limits
Date: Mon, 11 Nov 2019 09:30:00 +0200
Message-Id: <20191111073000.2957-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs timestamp overflow limits should be inherrited from upper
filesystem.

The current behavior, when overlayfs is over an underlying filesystem
that does not support post 2038 timestamps (e.g. xfs), is that overlayfs
overflows post 2038 timestamps instead of clamping them.

This change fixes xfstest generic/402 (verify filesystem timestamps for
supported ranges).

Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

(*) generic/402 currently does 'notrun' on overlayfs and need
    a small fix that I will post shortly

 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5d4faab57ba0..44915874fccb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1621,6 +1621,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		sb->s_stack_depth = ofs->upper_mnt->mnt_sb->s_stack_depth;
 		sb->s_time_gran = ofs->upper_mnt->mnt_sb->s_time_gran;
+		sb->s_time_min = ofs->upper_mnt->mnt_sb->s_time_min;
+		sb->s_time_max = ofs->upper_mnt->mnt_sb->s_time_max;
 
 	}
 	oe = ovl_get_lowerstack(sb, ofs);
-- 
2.17.1
