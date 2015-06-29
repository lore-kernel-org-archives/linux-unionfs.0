From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH 1/4] ovl: honor flag MS_SILENT at mount
Date: Mon, 29 Jun 2015 20:18:56 +0300
Message-ID: <20150629171856.15730.58271.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This patch hides error about missing lowerdir if MS_SILENT is set.

We use mount(NULL, "/", "overlay", MS_SILENT, NULL) for testing support of
overlayfs: syscall returns -ENODEV if it's not supported. Otherwise kernel
automatically loads module and returns -EINVAL because lowerdir is missing.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/overlayfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bf8537c7f455..00e1d0b3abdd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -840,7 +840,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	err = -EINVAL;
 	if (!ufs->config.lowerdir) {
-		pr_err("overlayfs: missing 'lowerdir'\n");
+		if (!silent)
+			pr_err("overlayfs: missing 'lowerdir'\n");
 		goto out_free_config;
 	}
 

