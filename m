Return-Path: <SRS0=4tes=42=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72C9C10F25
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Mar 2020 21:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84AA82146E
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Mar 2020 21:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="l5B230xH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgCIVHv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Mar 2020 17:07:51 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.218]:33632 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgCIVHv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Mar 2020 17:07:51 -0400
X-Greylist: delayed 1501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2020 17:07:50 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 15E5D4570
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Mar 2020 15:19:23 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BOrzjO0WP8vkBBOrzjGr6m; Mon, 09 Mar 2020 15:19:23 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=m8oDU5ueC5bxEXfkGSmLSUMfp7+qqcDb0q84/pI1JLc=; b=l5B230xHG/u7HVjD2SufekiKFc
        u2GhyZ7dECYq4OgNB626qmzcBk+oHhW96tGFm4IV/dQDWsrkUTQqzMesVCNAV2rfcKwyhueRQsr9j
        UhyGkWl966uORuNfrqT6HhKVEUnmH0AGM8zsAuZirE5C7gOhAPNb8YIoHflPxnhDjM4nCnOrSbB7m
        YY7hEG+KbLuJh0bU1HdTEwk2cNcHw7XgBgGBj5UVWGyZtSF4upZEc/iDlJa5o+ZYjs/BC6DCx65yj
        VKxMZrbg6A6Oka/dTf0A3xK1aCIxyL6OOpqFC4/aahGjTfRBohWpSf/UednROC4Vvf9IQSQ1Gsz99
        XMY28R/A==;
Received: from [201.162.168.201] (port=22316 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jBOrx-000yAk-51; Mon, 09 Mar 2020 15:19:21 -0500
Date:   Mon, 9 Mar 2020 15:22:33 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] overlayfs: overlayfs.h: Replace zero-length array with
 flexible-array member
Message-ID: <20200309202233.GA8631@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.168.201
X-Source-L: No
X-Exim-ID: 1jBOrx-000yAk-51
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.168.201]:22316
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/overlayfs/overlayfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8db6cf3ffc46..37a04e742603 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -87,7 +87,7 @@ struct ovl_fb {
 	u8 flags;	/* OVL_FH_FLAG_* */
 	u8 type;	/* fid_type of fid */
 	uuid_t uuid;	/* uuid of filesystem */
-	u32 fid[0];	/* file identifier should be 32bit aligned in-memory */
+	u32 fid[];	/* file identifier should be 32bit aligned in-memory */
 } __packed;
 
 /* In-memory and on-wire format for overlay file handle */
-- 
2.25.0

