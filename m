Return-Path: <mcoffin13@gmail.com>
Return-Path: <mcoffin13@gmail.com>
From: Matt Coffin <mcoffin13@gmail.com>
Subject: [PATCH] overlay: Display redirect_dir mount option when it is set automatically
Date: Sat,  8 Jun 2019 12:35:34 -0600
Message-Id: <20190608183534.2963-1-mcoffin13@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-unionfs@vger.kernel.org
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Matt Coffin <mcoffin13@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

[Why]
Currently, if metacopy is enabled via a module param/kernel config, then
the setting for redirect_dir is overriden, unless passed as a mount
option specifically. Despite this overriding, the redirect_dir option is
not printed when displaying the mount options (see /proc/mounts), so it
is hard for a user to know that it has happened.

[How]
A bit of code that does the overriding based on the mount options was
setting redirect_dir, but not updating the redirect_mode string. By
adding that update, the information is now printed (and the config
struct has the correct information in all places).
---
 fs/overlayfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5ec4fc2f5d7e..46fab4660bfe 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -598,6 +598,9 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
+			pr_info("overlayfs: enabling redirect_dir due to implicit metacopy=%d\n",
+				config->metacopy);
+			config->redirect_mode = "on";
 			config->redirect_follow = config->redirect_dir = true;
 		}
 	}
-- 
2.21.0
