Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26413C07E99
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jul 2021 13:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F39686135B
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Jul 2021 13:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhGINvR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 09:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhGINvR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Jul 2021 09:51:17 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C9CC0613E5
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Jul 2021 06:48:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i94so12230460wri.4
        for <linux-unionfs@vger.kernel.org>; Fri, 09 Jul 2021 06:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cGO7q0CzBiMwAEMQOQcpzzsMxPBtts0cw9J7gCinjOc=;
        b=HA28AZwk1QxU15vNuMwGLjd7BQxghhrbMgcRPGR7LdmKl0brV6wpdSic4P6ZU82lwv
         68rjNJOqU2cDfpXnHZRB05MryL74ZEEJruttd8UvSfLErHq0GekH4DM1jxBeHIc8dA+4
         CUYmRtRkAVsr01ziI8nW06hbl1TqNoNzdqTYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cGO7q0CzBiMwAEMQOQcpzzsMxPBtts0cw9J7gCinjOc=;
        b=S93GbOLRse/+9q2WucJmhycyD0SIkTJIhql/hvtj+z5Rpu7RQlFZnuj/cqJ2wjz+t2
         2e6ejz5K2t9yJlDpeSVkV3aCfTz26mRYAd11H2mgCG3ZxYCgo84jKyCjyp2BvsMQQPJx
         Xsir1E6ZWAhF3LVHHVHiBMT7Sac6A+YuNFyvx+7YBbMfwLKfAxzMvtL0hlkOrSF6ZmUS
         wp3K54KsDdML3d+efjCc05yrDUrjufqGqBmT1ZMDuOEA4DftwJUIinPtHugDlRGHkJ8i
         eBTNU4YaWYaBerlzefS6+tCYei5jBomtLdOFmsHvVrxnlOmXE2YA8QDhFqlKtRn+VACS
         jZiw==
X-Gm-Message-State: AOAM5304m3GenzEyyrPZ6nnRlQMobrxRZCCzGdtHqohuIr+lK1NF792S
        ppuLNZq2d1LjNXnQ9rCgYbBRf/6kP5aN83i5
X-Google-Smtp-Source: ABdhPJxzkKe5sDw+XtCuQ8ZW+5ymZQba3kF6FPPYqBVxtmf7h56dlf5m5EqszW9INRO9qRAxjmofDw==
X-Received: by 2002:adf:e7c1:: with SMTP id e1mr43385144wrn.198.1625838512692;
        Fri, 09 Jul 2021 06:48:32 -0700 (PDT)
Received: from miu.piliscsaba.redhat.com (catv-86-101-169-67.catv.broadband.hu. [86.101.169.67])
        by smtp.gmail.com with ESMTPSA id n20sm4734437wmk.12.2021.07.09.06.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 06:48:32 -0700 (PDT)
Date:   Fri, 9 Jul 2021 15:48:29 +0200
From:   Miklos Szeredi <miklos@szeredi.hu>
To:     Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix mmap denywrite
Message-ID: <YOhTrVWYi1aFY3o0@miu.piliscsaba.redhat.com>
References: <YNHXzBgzRrZu1MrD@miu.piliscsaba.redhat.com>
 <d73a5789-d233-940a-dc19-558b890f9b21@amd.com>
 <CAJfpegvTa9wnvCBP-vHumnDQ6f3XWb5vD6Fnpjbrj1V5N8QRig@mail.gmail.com>
 <8d9ac67c-8e97-3f53-95b8-548a8bec6358@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d9ac67c-8e97-3f53-95b8-548a8bec6358@amd.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 23, 2021 at 01:41:02PM +0200, Christian König wrote:
> 
> 
> Am 22.06.21 um 17:10 schrieb Miklos Szeredi:
> > On Tue, 22 Jun 2021 at 14:43, Christian König <christian.koenig@amd.com> wrote:
> > > Am 22.06.21 um 14:30 schrieb Miklos Szeredi:
> > > > Overlayfs did not honor positive i_writecount on realfile for VM_DENYWRITE
> > > > mappings.  Similarly negative i_mmap_writable counts were ignored for
> > > > VM_SHARED mappings.
> > > > 
> > > > Fix by making vma_set_file() switch the temporary counts obtained and
> > > > released by mmap_region().
> > > Mhm, I don't fully understand the background but that looks like
> > > something specific to overlayfs to me.
> > > 
> > > So why are you changing the common helper?
> > Need to hold the temporary counts until the final ones are obtained in
> > vma_link(), which is out of overlayfs' scope.
> 
> Ah! So basically we need to move the denial counts which mmap_region() added
> to the original file to the new one as well. That's indeed a rather good
> point.
> 
> Can you rather change the vma_set_file() function to return the error and
> add a __must_check?
> 
> I can take care fixing the users in DMA-buf and DRM subsystem.

Okay, but changing to __must_check has to be the last step to avoid compile
errors.  This v2 is with __must_check commented out.

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2] ovl: fix mmap denywrite

Overlayfs did not honor positive i_writecount on realfile for VM_DENYWRITE
mappings.  Similarly negative i_mmap_writable counts were ignored for
VM_SHARED mappings.

Fix by making vma_set_file() switch the temporary counts obtained and
released by mmap_region().

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c |    4 +++-
 include/linux/mm.h  |    2 +-
 mm/mmap.c           |    2 +-
 mm/util.c           |   27 ++++++++++++++++++++++++++-
 4 files changed, 31 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -430,7 +430,9 @@ static int ovl_mmap(struct file *file, s
 	if (WARN_ON(file != vma->vm_file))
 		return -EIO;
 
-	vma_set_file(vma, realfile);
+	ret = vma_set_file(vma, realfile);
+	if (ret)
+		return ret;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = call_mmap(vma->vm_file, vma);
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2776,7 +2776,7 @@ static inline void vma_set_page_prot(str
 }
 #endif
 
-void vma_set_file(struct vm_area_struct *vma, struct file *file);
+int /* __must_check */ vma_set_file(struct vm_area_struct *vma, struct file *file);
 
 #ifdef CONFIG_NUMA_BALANCING
 unsigned long change_prot_numa(struct vm_area_struct *vma,
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1807,6 +1807,7 @@ unsigned long mmap_region(struct file *f
 		 */
 		vma->vm_file = get_file(file);
 		error = call_mmap(file, vma);
+		file = vma->vm_file;
 		if (error)
 			goto unmap_and_free_vma;
 
@@ -1868,7 +1869,6 @@ unsigned long mmap_region(struct file *f
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
 	}
-	file = vma->vm_file;
 out:
 	perf_event_mmap(vma);
 
--- a/mm/util.c
+++ b/mm/util.c
@@ -314,12 +314,37 @@ int vma_is_stack_for_current(struct vm_a
 /*
  * Change backing file, only valid to use during initial VMA setup.
  */
-void vma_set_file(struct vm_area_struct *vma, struct file *file)
+int vma_set_file(struct vm_area_struct *vma, struct file *file)
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
 }
 EXPORT_SYMBOL(vma_set_file);
 
