Return-Path: <SRS0=PFgV=7F=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB023C433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 07:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DB22073B
	for <linux-unionfs@archiver.kernel.org>; Sat, 23 May 2020 07:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rPh1G7bR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387712AbgEWHa2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 23 May 2020 03:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387627AbgEWHaZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 23 May 2020 03:30:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E057C061A0E;
        Sat, 23 May 2020 00:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=uDLYJciikstYItbPiEvKAnBUlbqRbX8jnEC4HHtwZLk=; b=rPh1G7bRS0E2znrBfI6xY/Am7L
        L84ntwYR8DgJeWLiVKr/NiZCdkT7pD5fVvSuo6ftEHrImmsVjkU55ns4lTxfcFvl5OKQUBvOvtnrG
        trlj8CVdT7E74+IktPVLtMsmKkdUOGABRZtDfXY/0rcGJSWqAB0LJI2LTL3EeIUsJYP9dAOm4CyGS
        0D3xs+aoKWdaRHwvPu5kw8RaupKaX+zCj1E+IKJHUzb5TMzOL70bE8WSYlitX9DLV7H9pWQqchoTr
        PZkjtf33A1WTXyzYLjsFXz015kwnqdUDRoCLZ35tpJkZJVzSqGCvK+6jy/gYstti0hTvJq/+q47HF
        7c8YxLdg==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcObx-0007qK-2V; Sat, 23 May 2020 07:30:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk
Cc:     jack@suse.cz, tytso@mit.edu, adilger@dilger.ca,
        riteshh@linux.ibm.com, amir73il@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [PATCH 2/9] ext4: remove the call to fiemap_check_flags in ext4_fiemap
Date:   Sat, 23 May 2020 09:30:09 +0200
Message-Id: <20200523073016.2944131-3-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523073016.2944131-1-hch@lst.de>
References: <20200523073016.2944131-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

iomap_fiemap already calls fiemap_check_flags first thing, so this
additional check is redundant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d2a2a3ba5c44a..a41ae7c510170 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4866,9 +4866,6 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		fieinfo->fi_flags &= ~FIEMAP_FLAG_CACHE;
 	}
 
-	if (fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR))
-		return -EBADR;
-
 	/*
 	 * For bitmap files the maximum size limit could be smaller than
 	 * s_maxbytes, so check len here manually instead of just relying on the
-- 
2.26.2

