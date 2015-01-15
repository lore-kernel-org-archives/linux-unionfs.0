From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH 1/3] ovl: print error message for invalid mount options
Date: Thu, 15 Jan 2015 13:17:36 +0800
Message-ID: <54B74D70.3000205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Seunghun Lee <waydi1@gmail.com>, Fabian Sturm <fabian.sturm@aduu.de>
List-Id: linux-unionfs@vger.kernel.org

Overlayfs should print an error message if an incorrect mount option
is caught like other filesystems.

After this patch, improper option input could be clearly known.

Reported-by: Fabian Sturm <fabian.sturm@aduu.de>
Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b90952f..ab3c8cb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -615,6 +615,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			break;

 		default:
+			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
 		}
 	}
-- 
1.6.0.2

