Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3947FC2B9F4
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23EE06128E
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 12:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhFVMcd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 08:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhFVMcZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Jun 2021 08:32:25 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE44C0613A4
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Jun 2021 05:30:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a11so23440305wrt.13
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Jun 2021 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=0eja4Ft9+IhKqhZ+5g9OE9fSmKDzEpLJlLWbkDAUBg0=;
        b=IJEDprYdBC4k0O57DwT6ozE+TtnVYsKJ8/3y72d2VukcmoPJ7ZxMb4D4Up2QXpE3VL
         2zXEAGChuMmMVosYsubFpySIDJ9pAdEkd+ZJADLBhlc5P8ALKeCLmfT+hOx+I6OL5u/g
         0lnx/vBdRd1laZbnF0X4MtW7WU29B4O+0O1Ug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0eja4Ft9+IhKqhZ+5g9OE9fSmKDzEpLJlLWbkDAUBg0=;
        b=G6pxxF7AstTd9U7oES57y6YWHaBeH7Vpe9iYva09svfsggD02zh4w2hgpmo+AU3Bts
         GqN0pylM31bmBWaqazkJhjeR4OPDxc3q8N9Hxb7NGdGwgwuPovQM9vVO/iLH0Pw+FcV9
         GyiIB15xQn2MiNu4BvnuQW2jFrxSp921vDq8MPYRvcHFFCbJ5t93vqQ2XRjo0mXRVSDL
         u0AXtwSS/fRlfg+hYentp98D5qJTtzG63crcCo7GCTxLHOSesp3qDL5VvjI/IWfFRZVZ
         0L1g3Lol1gxka95Atq8AIBfmHwR3pz+mShhPRiJTrFTK4TRw8AaiSv3ddY0GuWG35lFd
         ZbuA==
X-Gm-Message-State: AOAM530IRHU84jxLEbI7p0RRFuWzWWnZa+Re8n4mMa22bWdjW+eLkWxX
        DG0gtINC62ofUAydzaRwtdeDhQ==
X-Google-Smtp-Source: ABdhPJwk+a4Um+CD2IMM4W8sfXkD+OlPlmUe6MhNapFLqM3YHogBRctyy6VBAsWvDWoXC/SzSSHN7w==
X-Received: by 2002:adf:f68a:: with SMTP id v10mr4483160wrp.366.1624365007418;
        Tue, 22 Jun 2021 05:30:07 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id t9sm2400812wmq.14.2021.06.22.05.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 05:30:07 -0700 (PDT)
Date:   Tue, 22 Jun 2021 14:30:04 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix mmap denywrite
Message-ID: <YNHXzBgzRrZu1MrD@miu.piliscsaba.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs did not honor positive i_writecount on realfile for VM_DENYWRITE
mappings.  Similarly negative i_mmap_writable counts were ignored for
VM_SHARED mappings.

Fix by making vma_set_file() switch the temporary counts obtained and
released by mmap_region().

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c |    4 +++-
 include/linux/mm.h  |    1 +
 mm/mmap.c           |    2 +-
 mm/util.c           |   38 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 42 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -430,7 +430,9 @@ static int ovl_mmap(struct file *file, s
 	if (WARN_ON(file != vma->vm_file))
 		return -EIO;
 
-	vma_set_file(vma, realfile);
+	ret = vma_set_file_checkwrite(vma, realfile);
+	if (ret)
+		return ret;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = call_mmap(vma->vm_file, vma);
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2751,6 +2751,7 @@ static inline void vma_set_page_prot(str
 #endif
 
 void vma_set_file(struct vm_area_struct *vma, struct file *file);
+int vma_set_file_checkwrite(struct vm_area_struct *vma, struct file *file);
 
 #ifdef CONFIG_NUMA_BALANCING
 unsigned long change_prot_numa(struct vm_area_struct *vma,
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1809,6 +1809,7 @@ unsigned long mmap_region(struct file *f
 		 */
 		vma->vm_file = get_file(file);
 		error = call_mmap(file, vma);
+		file = vma->vm_file;
 		if (error)
 			goto unmap_and_free_vma;
 
@@ -1870,7 +1871,6 @@ unsigned long mmap_region(struct file *f
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
 	}
-	file = vma->vm_file;
 out:
 	perf_event_mmap(vma);
 
--- a/mm/util.c
+++ b/mm/util.c
@@ -314,12 +314,48 @@ int vma_is_stack_for_current(struct vm_a
 /*
  * Change backing file, only valid to use during initial VMA setup.
  */
-void vma_set_file(struct vm_area_struct *vma, struct file *file)
+int vma_set_file_checkwrite(struct vm_area_struct *vma, struct file *file)
 {
+	vm_flags_t vm_flags = vma->vm_flags;
+	int err = 0;
+
 	/* Changing an anonymous vma with this is illegal */
 	get_file(file);
+
+	/* Get temporary denial counts on replacement */
+	if (vm_flags & VM_DENYWRITE) {
+		err = deny_write_access(file);
+		if (err)
+			goto out_put;
+	}
+	if (vm_flags & VM_SHARED) {
+		err = mapping_map_writable(file->f_mapping);
+		if (err)
+			goto out_allow;
+	}
+
 	swap(vma->vm_file, file);
+
+	/* Undo temporary denial counts on replaced */
+	if (vm_flags & VM_SHARED)
+		mapping_unmap_writable(file->f_mapping);
+out_allow:
+	if (vm_flags & VM_DENYWRITE)
+		allow_write_access(file);
+out_put:
 	fput(file);
+	return err;
+}
+EXPORT_SYMBOL(vma_set_file_checkwrite);
+
+/*
+ * Change backing file, only valid to use during initial VMA setup.
+ */
+void vma_set_file(struct vm_area_struct *vma, struct file *file)
+{
+	int err = vma_set_file_checkwrite(vma, file);
+
+	WARN_ON_ONCE(err);
 }
 EXPORT_SYMBOL(vma_set_file);
 


