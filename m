Return-Path: <SRS0=3ykI=7V=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD45C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Jun 2020 23:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1297020C09
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Jun 2020 23:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591658038;
	bh=OSIyjFeWmXecL53OVI8UGmOLm+YGOusPJaisg9IFerw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xeAT4cMYtWnA7QocTURFlDyi+7psNOf8SHzNPTG9jrBfVGgbjBagbfE6pL6YqIT9m
	 xe4ROUepbXicE9rYLU1xYw7ybo5MNfkF1dQ5omlsofSy1ixD4/8hW5juQepU4hWXX4
	 ZfGgO+m9cernlnNlRgTjh+JMetxmwTtcZ1e8GKGg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgFHXN4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 19:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728799AbgFHXNz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EC9621508;
        Mon,  8 Jun 2020 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658034;
        bh=OSIyjFeWmXecL53OVI8UGmOLm+YGOusPJaisg9IFerw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0CyB6Wv9ntcJb8uRrEkdQr9q8g9TvE+LCOqaWDLE/Dz+vE6SphJ1Akncw7qM+Sbg
         ln2S7i/onmE9dx++yzsnrHi1P+w0daRC4jzmW/PgWRXpLXt33Ff/PvU64ZO5MhEd+z
         qdtiHkYBxJIxxktceAHg3TeTOzuOGRO69vlTvC2o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-unionfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 085/606] ovl: potential crash in ovl_fid_to_fh()
Date:   Mon,  8 Jun 2020 19:03:30 -0400
Message-Id: <20200608231211.3363633-85-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9aafc1b0187322fa4fd4eb905d0903172237206c ]

The "buflen" value comes from the user and there is a potential that it
could be zero.  In do_handle_to_path() we know that "handle->handle_bytes"
is non-zero and we do:

	handle_dwords = handle->handle_bytes >> 2;

So values 1-3 become zero.  Then in ovl_fh_to_dentry() we do:

	int len = fh_len << 2;

So now len is in the "0,4-128" range and a multiple of 4.  But if
"buflen" is zero it will try to copy negative bytes when we do the
memcpy in ovl_fid_to_fh().

	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);

And that will lead to a crash.  Thanks to Amir Goldstein for his help
with this patch.

Fixes: cbe7fba8edfc ("ovl: make sure that real fid is 32bit aligned in memory")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org> # v5.5
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/export.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 6f54d70cef27..e605017031ee 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -777,6 +777,9 @@ static struct ovl_fh *ovl_fid_to_fh(struct fid *fid, int buflen, int fh_type)
 	if (fh_type != OVL_FILEID_V0)
 		return ERR_PTR(-EINVAL);
 
+	if (buflen <= OVL_FH_WIRE_OFFSET)
+		return ERR_PTR(-EINVAL);
+
 	fh = kzalloc(buflen, GFP_KERNEL);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
-- 
2.25.1

