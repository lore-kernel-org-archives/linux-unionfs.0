From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH] ovl: initialize ->is_cursor
Date: Fri, 31 Oct 2014 20:02:42 +0100
Message-ID: <20141031190242.GA19099@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37588 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaJaTCt (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 31 Oct 2014 15:02:49 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so2103355wiv.8
        for <linux-unionfs@vger.kernel.org>; Fri, 31 Oct 2014 12:02:48 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
This goes on top of "ovl: fix check for cursor".

 fs/overlayfs/readdir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -93,6 +93,7 @@ static struct ovl_cache_entry *ovl_cache
 		p->type = d_type;
 		p->ino = ino;
 		p->is_whiteout = false;
+		p->is_cursor = false;
 	}
 
 	return p;

