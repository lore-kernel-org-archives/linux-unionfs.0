From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH 4/4] ovl: forbid overlayfs on top of overlayfs
Date: Mon, 29 Jun 2015 20:19:00 +0300
Message-ID: <20150629171900.15730.43569.stgit@buzz>
References: <20150629171856.15730.58271.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150629171856.15730.58271.stgit@buzz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Mounting overlayfs using other overlayfs instance as lower or upper
layer triggers false-positive lockdep warning about possible locking
recursion of ->i_mutex in iterate_dir().

Nesting already limited with FILESYSTEM_MAX_STACK_DEPTH = 2 to prevent
kernel stack overflow. Overlayfs supports multiple lower layers thus
the same configuration could be constructed without nesting.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/overlayfs/super.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e5db31f78c7d..381af9a5ece9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -700,10 +700,13 @@ static bool ovl_is_allowed_fs_type(struct dentry *root)
 
 	/*
 	 * We don't support:
+	 *  - overlayfs
 	 *  - automount filesystems
 	 *  - filesystems with revalidate (FIXME for lower layer)
 	 *  - filesystems with case insensitive names
 	 */
+	if (root->d_sb->s_op == &ovl_super_operations)
+		return false;
 	if (dop &&
 	    (dop->d_manage || dop->d_automount ||
 	     dop->d_revalidate || dop->d_weak_revalidate ||

