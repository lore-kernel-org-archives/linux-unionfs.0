Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EAE5C433EF
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Jul 2022 14:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiGAOLh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Jul 2022 10:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGAOLh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Jul 2022 10:11:37 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B6F3465B
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Jul 2022 07:11:36 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id i17so4105132qvo.13
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Jul 2022 07:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ilmh79zIynDVTXj7RRadh3um5CVQZgI6UWU3yOlRtBs=;
        b=2s7KurFa3EoToPxRfH6Az44HV+taqGgIxVDhnRqXjpE3t5zLzQ8a3VW7vV/WrokN/i
         XcaRelIJ1UlKaS4OK+mwFF00s9wXpqSx37a0590iWPa7gZ0CibCF9xthGbenjWK3mQIb
         shOOj8dveFbRUsBNqFUt+bRz488MdDYWACPLrG+j8aVkhi5oOq7H/plF2UJkTPhmIRsf
         xK0xI5RBVoCVB2QEEu+YUagaOot7gVrAJcnnBG/dv+G7XTDA5DlDbFN6V9iWP//eFv0E
         4uuc2t7shIAqOHC15JsAw2U1GOo02+M5WeqzVOAxDDcr7U6GuBkb7kTqWmFn1LC1uWSQ
         C6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ilmh79zIynDVTXj7RRadh3um5CVQZgI6UWU3yOlRtBs=;
        b=AXkKlaiWNEK9275ORUUdST0qkCYlSxtqH3Ma+YIuBr0gkIKOyRH3sdoL4D9WmVGjIR
         imGReyl3F6MkJbKH5Ivbktqjpa2i88CZq3n5vd7Mvr7uhNJXMzdGK/ewyI3pEodkmYR5
         ufTSKCQK5JXkIdld9SsjEJu4x6ndpYTx6CKXK25/E6c89irTdLfMGHt0PhOn0ls9poMy
         treLn/KoOej08TcXEXOf2bI8JuM1iR2FdnpAfW0l3ppnxplpzZBnU5lQKsgzNb1kBDd1
         gO9FUmXQkGMt4dXu2o+AQAAEAOSfFMTADnIALWClL0Xy2oVD6fqCknO1mPJYn9a7d5CH
         jcIg==
X-Gm-Message-State: AJIora/rOuqf2sP5M4zbsoNNEw8Hq7H0fs9RWqkvGM/zKuP0Ke/tLxak
        6IyJp7a2n7c1pFXEblfnkmDhcI3A5eql
X-Google-Smtp-Source: AGRyM1uhIv5tPdqm5uJqATDHpoHEylqCW5LZo6S0Hwhh7OhuQ4Q1mOSIgRTOm/Fp48icW2Tvz7Onsg==
X-Received: by 2002:a05:6214:501b:b0:470:51f4:d785 with SMTP id jo27-20020a056214501b00b0047051f4d785mr16471314qvb.102.1656684695053;
        Fri, 01 Jul 2022 07:11:35 -0700 (PDT)
Received: from localhost (pool-96-237-52-46.bstnma.fios.verizon.net. [96.237.52.46])
        by smtp.gmail.com with ESMTPSA id r13-20020a05620a298d00b006afc53e0be2sm7783665qkp.117.2022.07.01.07.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 07:11:34 -0700 (PDT)
Subject: [RFC PATCH] ovl: properly release old cache entries in
 ovl_cache_get()
From:   Paul Moore <paul@paul-moore.com>
To:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Date:   Fri, 01 Jul 2022 10:11:33 -0400
Message-ID: <165668469351.28601.2872895377697386439.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

If an old readdir cache entry is found during lookup we need to
ensure that we drop a reference to the old cache entry before
we remove it from the cache.

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 fs/overlayfs/readdir.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 78f62cc1797b..404e6849ff75 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -235,10 +235,8 @@ void ovl_dir_cache_free(struct inode *inode)
 	}
 }
 
-static void ovl_cache_put(struct ovl_dir_file *od, struct dentry *dentry)
+static void ovl_cache_put(struct ovl_dir_cache *cache, struct dentry *dentry)
 {
-	struct ovl_dir_cache *cache = od->cache;
-
 	WARN_ON(cache->refcount <= 0);
 	cache->refcount--;
 	if (!cache->refcount) {
@@ -327,7 +325,7 @@ static void ovl_dir_reset(struct file *file)
 	bool is_real;
 
 	if (cache && ovl_dentry_version_get(dentry) != cache->version) {
-		ovl_cache_put(od, dentry);
+		ovl_cache_put(cache, dentry);
 		od->cache = NULL;
 		od->cursor = NULL;
 	}
@@ -396,12 +394,15 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	struct ovl_dir_cache *cache;
 
 	cache = ovl_dir_cache(d_inode(dentry));
-	if (cache && ovl_dentry_version_get(dentry) == cache->version) {
-		WARN_ON(!cache->refcount);
-		cache->refcount++;
-		return cache;
+	if (cache) {
+		if (ovl_dentry_version_get(dentry) == cache->version) {
+			WARN_ON(!cache->refcount);
+			cache->refcount++;
+			return cache;
+		}
+		ovl_set_dir_cache(d_inode(dentry), NULL);
+		ovl_cache_put(cache, dentry);
 	}
-	ovl_set_dir_cache(d_inode(dentry), NULL);
 
 	cache = kzalloc(sizeof(struct ovl_dir_cache), GFP_KERNEL);
 	if (!cache)
@@ -913,7 +914,7 @@ static int ovl_dir_release(struct inode *inode, struct file *file)
 
 	if (od->cache) {
 		inode_lock(inode);
-		ovl_cache_put(od, file->f_path.dentry);
+		ovl_cache_put(od->cache, file->f_path.dentry);
 		inode_unlock(inode);
 	}
 	fput(od->realfile);

