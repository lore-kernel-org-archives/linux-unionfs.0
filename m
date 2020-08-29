Return-Path: <SRS0=cJ4F=CH=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F219C433E7
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF5A2075B
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="f462YgeL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH2JwD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 05:52:03 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17175 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbgH2JwD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 29 Aug 2020 05:52:03 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1598694691; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=e6IcCG4tFosqzZgL/24g7rTR8CwHArbFn8gqoyeP0usMaoVI6u6AceplXcn6hbW69hHYTCP4L1IzblceuMvXyosITHt8bWStg5jdPiODCObfFX5vScf/wRUodv5P9LVXq2BQ+P5pdYhuWGFGRHyW0s3yKwa2jRkxnEFsqzxXqmo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1598694691; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ccEWT3RLuwiPMu/BBIgZh5/ZgyfZBB6tStaJtH+L+JY=; 
        b=LyzBXJnBuVVu6950HiaP7Fwrfz5g4BSeqm4kwWZGEa02R+JuXLeSpYdNh90xhJmcsLqMHNeK+VVG3mQtz9x8ZWlBbn++dEft84k6cUUWVmbddciR+BeIk2cVFAMm5Ca79aGeKIQGFhkjneKuNjIkA3AzbtpSVfXxhwmjnYWIZ+k=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1598694691;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=ccEWT3RLuwiPMu/BBIgZh5/ZgyfZBB6tStaJtH+L+JY=;
        b=f462YgeLswSRXtYIq+DvgwbLsEFk5nGTD1bHb+XueyiqlOt1/vAUH/qKwya3brpu
        0UF3EModFvQfCwiHAU1nO9n9rnEyxIYz9xWBoNhxRpnMCvdtd+djaZK6y+x2ve6i+SC
        Mdx1wvDvj8FNOF0UwZi0X/QNCrla4UaH9o2L23AA=
Received: from localhost.localdomain (116.30.194.36 [116.30.194.36]) by mx.zoho.com.cn
        with SMTPS id 1598694689422660.411788621191; Sat, 29 Aug 2020 17:51:29 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     linux-unionfs@vger.kernel.org, linux-mm@kvack.org
Cc:     miklos@szeredi.hu, akpm@linux-foundation.org, amir73il@gmail.com,
        riteshh@linux.ibm.com, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200829095101.25350-2-cgxu519@mykernel.net>
Subject: [RFC PATCH 1/3] mm: mmap: export necessary functions for overlayfs' mmap
Date:   Sat, 29 Aug 2020 17:50:59 +0800
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200829095101.25350-1-cgxu519@mykernel.net>
References: <20200829095101.25350-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In shared mode mmap, if overlayfs' inode does not have data
in upper layer, it should call maybe_unlock_mmap_for_io()
to release lock and waiting for IO in ->fault handler.
Meanwhile, in order to avoid endless retry we should also
check flag FAULT_FLAG_TRIED carefully in ->fault handler.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 include/linux/mm.h |  2 ++
 mm/filemap.c       | 28 ++++++++++++++++++++++++++++
 mm/internal.h      | 22 ----------------------
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dc7b87310c10..214b23734eed 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1656,6 +1656,8 @@ void unmap_mapping_pages(struct address_space *mappin=
g,
 =09=09pgoff_t start, pgoff_t nr, bool even_cows);
 void unmap_mapping_range(struct address_space *mapping,
 =09=09loff_t const holebegin, loff_t const holelen, int even_cows);
+struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf, struct file *f=
pin);
+bool fault_flag_check(struct vm_fault *vmf, unsigned int flag);
 #else
 static inline vm_fault_t handle_mm_fault(struct vm_area_struct *vma,
 =09=09unsigned long address, unsigned int flags)
diff --git a/mm/filemap.c b/mm/filemap.c
index f0ae9a6308cb..8a226f8ca262 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2704,6 +2704,34 @@ int generic_file_readonly_mmap(struct file *file, st=
ruct vm_area_struct *vma)
 =09=09return -EINVAL;
 =09return generic_file_mmap(file, vma);
 }
+
+struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
+=09=09=09=09      struct file *fpin)
+{
+=09int flags =3D vmf->flags;
+
+=09if (fpin)
+=09=09return fpin;
+
+=09/*
+=09 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
+=09 * anything, so we only pin the file and drop the mmap_lock if only
+=09 * FAULT_FLAG_ALLOW_RETRY is set, while this is the first attempt.
+=09 */
+=09if (fault_flag_allow_retry_first(flags) &&
+=09    !(flags & FAULT_FLAG_RETRY_NOWAIT)) {
+=09=09fpin =3D get_file(vmf->vma->vm_file);
+=09=09mmap_read_unlock(vmf->vma->vm_mm);
+=09}
+=09return fpin;
+}
+EXPORT_SYMBOL(maybe_unlock_mmap_for_io);
+
+bool fault_flag_check(struct vm_fault *vmf, unsigned int flag)
+{
+=09return vmf->flags & flag;
+}
+EXPORT_SYMBOL(fault_flag_check);
 #else
 vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
 {
diff --git a/mm/internal.h b/mm/internal.h
index 9886db20d94f..ef19235c6bf1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -402,28 +402,6 @@ vma_address(struct page *page, struct vm_area_struct *=
vma)
=20
 =09return max(start, vma->vm_start);
 }
-
-static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
-=09=09=09=09=09=09    struct file *fpin)
-{
-=09int flags =3D vmf->flags;
-
-=09if (fpin)
-=09=09return fpin;
-
-=09/*
-=09 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
-=09 * anything, so we only pin the file and drop the mmap_lock if only
-=09 * FAULT_FLAG_ALLOW_RETRY is set, while this is the first attempt.
-=09 */
-=09if (fault_flag_allow_retry_first(flags) &&
-=09    !(flags & FAULT_FLAG_RETRY_NOWAIT)) {
-=09=09fpin =3D get_file(vmf->vma->vm_file);
-=09=09mmap_read_unlock(vmf->vma->vm_mm);
-=09}
-=09return fpin;
-}
-
 #else /* !CONFIG_MMU */
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
--=20
2.20.1


