Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD721C6FD1E
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Mar 2023 14:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjCHOjh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 09:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbjCHOjM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Mar 2023 09:39:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0435259803
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Mar 2023 06:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678286297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2VxSf4XlD6Tq7Rp6h04Xh27xM5QEWu2hXwF5fPrnqQ0=;
        b=WjyDOuG0xpiY8xMoUiWvd6hPsisPrLOdky1UTl0Y0QBmZz45VK3KNolFnYy10kR150ofio
        kE3gUfn7D+ViH/HQ6Lsd55vB25TDm3083Yi7Pz6ICeDybApV2acclnCDcaxnC3boaPctQm
        1rdshTo+sJHhHE83dIQfgZHV/1aT1J4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-K6sCAm2YNpimy6kvSNJiow-1; Wed, 08 Mar 2023 09:38:12 -0500
X-MC-Unique: K6sCAm2YNpimy6kvSNJiow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AB61101A55E;
        Wed,  8 Mar 2023 14:38:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F6222166B26;
        Wed,  8 Mar 2023 14:38:08 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, linux-unionfs@vger.kernel.org
Subject: [PATCH v16 04/13] coda: Implement splice-read
Date:   Wed,  8 Mar 2023 14:37:45 +0000
Message-Id: <20230308143754.1976726-5-dhowells@redhat.com>
In-Reply-To: <20230308143754.1976726-1-dhowells@redhat.com>
References: <20230308143754.1976726-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Implement splice-read for coda by passing the request down a layer rather
than going through generic_file_splice_read() which is going to be changed
to assume that ->read_folio() is present on buffered files.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>
cc: Christoph Hellwig <hch@lst.de>
cc: Jens Axboe <axboe@kernel.dk>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: John Hubbard <jhubbard@nvidia.com>
cc: David Hildenbrand <david@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: coda@cs.cmu.edu
cc: codalist@coda.cs.cmu.edu
cc: linux-unionfs@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/coda/file.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/coda/file.c b/fs/coda/file.c
index 3f3c81e6b1ab..33cd7880d30e 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/uio.h>
+#include <linux/splice.h>
 
 #include <linux/coda.h>
 #include "coda_psdev.h"
@@ -94,6 +95,39 @@ coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+static ssize_t
+coda_file_splice_read(struct file *coda_file, loff_t *ppos,
+		      struct pipe_inode_info *pipe,
+		      size_t len, unsigned int flags)
+{
+	struct inode *coda_inode = file_inode(coda_file);
+	struct coda_file_info *cfi = coda_ftoc(coda_file);
+	struct file *in = cfi->cfi_container;
+	loff_t ki_pos = *ppos;
+	ssize_t ret;
+
+	if (!in->f_op->splice_read)
+		return -EINVAL;
+
+	ret = rw_verify_area(READ, in, ppos, len);
+	if (unlikely(ret < 0))
+		return ret;
+
+	ret = venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
+				  &cfi->cfi_access_intent,
+				  len, ki_pos, CODA_ACCESS_TYPE_READ);
+	if (ret)
+		goto finish_read;
+
+	ret = in->f_op->splice_read(in, ppos, pipe, len, flags);
+
+finish_read:
+	venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
+			    &cfi->cfi_access_intent,
+			    len, ki_pos, CODA_ACCESS_TYPE_READ_FINISH);
+	return ret;
+}
+
 static void
 coda_vm_open(struct vm_area_struct *vma)
 {
@@ -302,5 +336,5 @@ const struct file_operations coda_file_operations = {
 	.open		= coda_open,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
-	.splice_read	= generic_file_splice_read,
+	.splice_read	= coda_file_splice_read,
 };

