From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/15] VFS: Fix up audit to use d_backing_inode()
Date: Wed, 25 Mar 2015 14:43:59 +0000
Message-ID: <20150325144359.17670.29700.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbbCYOoD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 25 Mar 2015 10:44:03 -0400
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu

Fix up audit to use d_backing_inode() where there's a bit that involves casting
and doesn't match the script RE to automatically change to d_backing_inode().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/audit_watch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index ad9c1682f616..89f28f5f7fda 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -482,7 +482,7 @@ static int audit_watch_handle_event(struct fsnotify_group *group,
 
 	switch (data_type) {
 	case (FSNOTIFY_EVENT_PATH):
-		inode = ((struct path *)data)->dentry->d_inode;
+		inode = d_backing_inode(((struct path *)data)->dentry);
 		break;
 	case (FSNOTIFY_EVENT_INODE):
 		inode = (struct inode *)data;

