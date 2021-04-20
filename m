Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58540C433B4
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Apr 2021 11:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14CE060FE9
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Apr 2021 11:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhDTLPe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 07:15:34 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25394 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231650AbhDTLPd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Apr 2021 07:15:33 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618917290; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=rBLVlJylfLxIocghkPeQrTdBLQbQRbHttz8plik8jMrs+NJZ0fFs4V0FSaY7/rfCGTm2QNTpvaEGyqg10Ruh8UybY88bN8kk20a+TGuYlwNFTtaQBXIn9ON+57QQeAZhdSB3cmXqQYtAFJpWL4QEjvpgE9LNp0VSiA2CMiiYt2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1618917290; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=tUM6oZojtCKaJO3h6aRbEKAZpYu7vYcNeabgnhNuj7o=; 
        b=QNOHZH/uzpQm5NekBXBXzMycIt+Wcv6xMLUWAeTZhsGltQOxtyXAGpfMWjlxtnbhfSDEQV40ODxM+zQUEBsdqGUFDogBjFwRwP9qxSMQVZuSk1yWsUlDbYmjSUXSNsT8d+QghLRVANRhPP3yfMuFXoBXEnsPV9E+9lwpfWSuvZ8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1618917290;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-Id:In-Reply-To:References:Subject:MIME-Version:Content-Type;
        bh=tUM6oZojtCKaJO3h6aRbEKAZpYu7vYcNeabgnhNuj7o=;
        b=SQj2u0mKDP12GuZxdpD/0EetoIW4wKUUylJl/nqasamG5icvDjrz+ICVR7AVVBcU
        XM4yajvE8fCfdCOvD26O80WGyehV822pmwQqy+kvgaG8+tpDbeoAMQctlDd+5ydpSPD
        beQsDftBDfMN+uyM3lJkaKXTOSbm6XfuWxzNrhG0=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1618917286657930.0099987814517; Tue, 20 Apr 2021 19:14:46 +0800 (CST)
Date:   Tue, 20 Apr 2021 19:14:46 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-Id: <178eefd62dc.d8b55fc99351.1797693213121507171@mykernel.net>
In-Reply-To: <CAJfpegsKHRY=AxQMECwXNh2Rni_Ah0uo939aEfhRcQB3Rz-AGQ@mail.gmail.com>
References: <20210408112042.2586996-1-cgxu519@mykernel.net>
 <178b13dbf0a.c5d5924718458.7870418673694557579@mykernel.net>
 <CAJfpegt5vVAtik=SXL26G0Tjh8yzZ6DvD6wLtfbXTinqpkxVeg@mail.gmail.com>
 <178b1482b24.108404c2418483.4334767487912126386@mykernel.net>
 <CAJfpegvbrz3=nL2ETb+nY9G2cBTu4sC_sAhdxnVdHCN7Y1JFfg@mail.gmail.com> <178c943b8b6.cd81e26521858.1415503984601701317@mykernel.net> <CAJfpegsKHRY=AxQMECwXNh2Rni_Ah0uo939aEfhRcQB3Rz-AGQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
MIME-Version: 1.0
Content-Type: multipart/mixed; 
        boundary="----=_Part_24943_1614672553.1618917286621"
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
X-ZohoCN-Virus-Status: 1
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

------=_Part_24943_1614672553.1618917286621
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2021-04-13 16:47:53 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Tue, Apr 13, 2021 at 5:26 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 23:03:39 Miklo=
s Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > On Thu, Apr 8, 2021 at 1:40 PM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:29:55 =
Miklos Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Thu, Apr 8, 2021 at 1:28 PM Chengguang Xu <cgxu519@mykernel=
.net> wrote:
 > >  > >  > >
 > >  > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2021-04-08 19:2=
0:42 Chengguang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > >  > >  > >  > In overlayfs copy-up, if open flag has O_TRUNC then upper
 > >  > >  > >  > file will truncate to zero size, in this case we should c=
heck
 > >  > >  > >  > VM_DENYWRITE mappings to keep compatibility with other fi=
lesystems.
 > >  > >  >
 > >  > >  > Can you provide a test case for the bug that this is fixing?
 > >  > >  >
 > >  > >
 > >  > > Execute binary file(keep running until open) in overlayfs which o=
nly has lower && open the binary file with flag O_RDWR|O_TRUNC
 > >  > >
 > >  > > Expected result: open fail with -ETXTBSY
 > >  > >
 > >  > > Actual result: open success
 > >  >
 > >  > Worse,  it's possible to get a "Bus error" with just execute and wr=
ite
 > >  > on an overlayfs file, which i_writecount is supposed to protect.
 > >  >
 > >  > The reason is that the put_write_access() call in __vma_link_file()
 > >  > assumes an already negative writecount, but because of the vm_file
 > >  > shuffle in ovl_mmap() that's not guaranteed.   There's even a comme=
nt
 > >  > about exactly this situation in mmap():
 > >  >
 > >  > /* ->mmap() can change vma->vm_file, but must guarantee that
 > >  > * vma_link() below can deny write-access if VM_DENYWRITE is set
 > >  > * and map writably if VM_SHARED is set. This usually means the
 > >  > * new file must not have been exposed to user-space, yet.
 > >  > */
 > >  >
 > >  > The attached patch fixes this, but not your original bug.
 > >  >
 > >  > That could be addressed by checking the writecount on *both* lower =
and
 > >  > upper for open for write/truncate.  Note: this could be checked bef=
ore
 > >  > copy-up, but that's not reliable alone, because the copy up could
 > >  > happen due to meta-data update, for example, and then the
 > >  > open/truncate wouldn't trigger the writecount check.
 > >  >
 > >  > Something like the second attached patch?
 > >  >
 > >
 > > Yeah, I noticed that too just after posted my previous patch.
 > > However, rethink these two cases, in practice we share lower layers
 > > in most use cases especially in container use case. So if we check
 > > VM_DENYWRITE of lower file strictly, it may cause interferes between
 > > container instances. Maybe only checking upper file will be better
 > > option?
 >=20
 > Yes.
 >=20
 > My patch to fix the SIGBUS is also incomplete as there's still a race
 > window between releasing the temporary writecount and the __vma_link()
 > that acquires the final count.    This requires major surgery to fix
 > properly :(
 >=20

Hi Miklos,

How about to fix something like attached patch?

Thanks,
Chengguang

------=_Part_24943_1614672553.1618917286621
Content-Type: application/octet-stream; name=0001-ovl-test.patch
Content-Transfer-Encoding: 7bit
X-ZM_AttachId: 138382100866230000
Content-Disposition: attachment; filename=0001-ovl-test.patch

From 2bf3c60d86dc1b86f5ae22cd4e1f5d39603143c6 Mon Sep 17 00:00:00 2001
From: Chengguang Xu <cgxu519@mykernel.net>
Date: Tue, 20 Apr 2021 09:51:36 +0800
Subject: [PATCH] ovl: test

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 29 +++++++++++++++++++++++++++--
 mm/mmap.c           |  3 ++-
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 6e454a294046..70d9167a47ee 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -422,6 +422,7 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct file *realfile = file->private_data;
 	const struct cred *old_cred;
+	vm_flags_t vm_flags = vma->vm_flags;
 	int ret;
 
 	if (!realfile->f_op->mmap)
@@ -430,22 +431,46 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	if (WARN_ON(file != vma->vm_file))
 		return -EIO;
 
+	/* Get temporary denial counts on realfile */
+	if (vm_flags & VM_DENYWRITE &&
+	    (ret = deny_write_access(realfile)))
+		goto out;
+
+	if (vm_flags & VM_SHARED &&
+	    (ret = mapping_map_writable(realfile->f_mapping)))
+		goto allow_write;
+
 	vma->vm_file = get_file(realfile);
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = call_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
 
+	ovl_file_accessed(file);
+
 	if (ret) {
 		/* Drop reference count from new vm_file value */
 		fput(realfile);
+		vma->vm_file = file;
+
+		/* Undo temporary denial counts */
+		if (vm_flags & VM_SHARED)
+			mapping_unmap_writable(realfile->f_mapping);
+allow_write:
+		if (vm_flags & VM_DENYWRITE)
+			allow_write_access(realfile);
+
 	} else {
+		if (vm_flags & VM_DENYWRITE)
+			allow_write_access(file);
+		if (vm_flags & VM_SHARED)
+			mapping_unmap_writable(file->f_mapping);
+
 		/* Drop reference count from previous vm_file value */
 		fput(file);
 	}
 
-	ovl_file_accessed(file);
-
+out:
 	return ret;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 3f287599a7a3..257ca0807be5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1806,6 +1806,8 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		if (error)
 			goto unmap_and_free_vma;
 
+		file = vma->vm_file;
+
 		/* Can addr have changed??
 		 *
 		 * Answer: Yes, several device drivers can do it in their
@@ -1864,7 +1866,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
 	}
-	file = vma->vm_file;
 out:
 	perf_event_mmap(vma);
 
-- 
2.27.0


------=_Part_24943_1614672553.1618917286621--

