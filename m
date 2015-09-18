From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] overlayfs: Fix dentry reference leak
Date: Fri, 18 Sep 2015 11:45:22 +0100
Message-ID: <20150918104522.7696.6538.stgit@warthog.procyon.org.uk>
References: <20150918104512.7696.55992.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150918104512.7696.55992.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@ZenIV.linux.org.uk
List-Id: linux-unionfs@vger.kernel.org

In ovl_copy_up_locked(), newdentry is leaked if the function exits through
out_cleanup as this just to out after calling ovl_cleanup() - which doesn't
actually release the ref on newdentry.

The out_cleanup segment should instead exit through out2 as certainly
newdentry leaks - and possibly upper does also, though this isn't caught
given the catch of newdentry.

Without this fix, something like the following is seen:

	BUG: Dentry ffff880023e9eb20{i=f861,n=#ffff880023e82d90} still in use (1) [unmount of tmpfs tmpfs]
	BUG: Dentry ffff880023ece640{i=0,n=bigfile}  still in use (1) [unmount of tmpfs tmpfs]

when unmounting the upper layer after an error occurred in copyup.

An error can be induced by creating a big file in a lower layer with
something like:

	dd if=/dev/zero of=/lower/a/bigfile bs=65536 count=1 seek=$((0xf000))

to create a large file (4.1G).  Overlay an upper layer that is too small
(on tmpfs might do) and then induce a copy up by opening it writably.

Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 89b4cb3773d7..d3a5990fd2b9 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -270,7 +270,7 @@ out:
 
 out_cleanup:
 	ovl_cleanup(wdir, newdentry);
-	goto out;
+	goto out2;
 }
 
 /*
