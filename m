Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD1E188CAE;
	Wed,  6 Nov 2024 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730888593; cv=none; b=oPTPi4/HUdQrBcaG4SuWdD2l1JNsV5CQZwYpr/UEzut1HeeaCoMQWMwnABDjXUAh40f7BLC/iW87yFBltwxD+RxSMaan9Jxa5+T8gfx+3uRpnD/9SHRly/IeeJ1l7i4wo74OPowkO/uSHQst3okU5Z8Isf2EO8dIrfwjb1D3mAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730888593; c=relaxed/simple;
	bh=vS6thUiKnD0qrwRzuDEwt3q8R1qnsb7st7wsHtYAb88=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lq8CAMzhxe+d0Gu1VSSjHeS9UeVUITecMKrV2pZ2PQJLTDFoYBFlMm79gsJt+J8PEWwcq2RIVkC42fut0VqYu4lgKFKRXLpdfiyTFCeKENGmpRNlUX2YJCKbwIBPAiw5dAnAvuJS2mXwxm58DcBSjh3zGAEFy+SlivilrC1RWrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=rh4lgkTg; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="rh4lgkTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1730888286; bh=4Lx5y0EO4dLl48a47GshMo6lPRppJheVV/vxyRZJTDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rh4lgkTgmG5fMnmtwh0zXgF6Jom+N9Ou59GHYcrUkZ0fd4ntzmDrqxe+yWkic/5RZ
	 +V7DbfV5IUSGdHDSi5rUP8XYawAQaDkxfaCF3j3LwdEBEPTuVmyn0KQrGLbrcibIcY
	 pbI/IlwI+NS70FY3Jb/OP2u0cMoNAm3qemj7HUAQ=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id 4813A62D; Wed, 06 Nov 2024 18:18:01 +0800
X-QQ-mid: xmsmtpt1730888281tzl1npzvf
Message-ID: <tencent_73EE0DCC923DDDAB5DD8995C4F958DE92507@qq.com>
X-QQ-XMAILINFO: NonMLXQbqcUbrXOQUSReKlthw9RH0PKv+KqCloHMX6Ratk7+8DJgN5SAqHaKWe
	 qZxj+h+DMAxoQiZH6+xpe/F/xiGejmAn8s8aOaGWiFXLYci5yEFVTsa5byR5Ybxrhwih6scauG7b
	 lQvRTOjc1XCHdRmh523w4sNP6LDXrQA5OT9Xb8svcXgFxTTmE1J37mx3mRtJdTLAPyosUKNHwSaz
	 /JwIh8mtSVlt2/1FIZbgoho2UL+piDuOMAlWHbERA2jjVt0VufK3b/05a5lIT1bAM7JFSBFF2R0O
	 duk2tA7hGWFzf887mNI/OATUHd001WO+69T8nd4x8FccPJhqe1DRTZLC0ZJWYYoNtxUnhFIOGgvZ
	 QZHKJixWAwVzGLuIwxT+oJd3UHj0XI/D8aa7hvmU4gH8Mf5q1yaAkJwx6nIgw8FEz5PNm9yxuCoF
	 M6Tk85z+91hdhlniAVCiE6JsJSIk9X4tBzrHmciVBUZeqQ7dHfMQcGOs+WNkSzWnwkG/DXgWHAvn
	 /oZYGQuQusBgkqRpw6BUAddf2dvmN8mBIGq7kmqF+DTziYzgLGTriNAMuOj9BfaSEDbXM3V4auVh
	 QC3+wboiwZlUCQdHkDoUGaLkjNUVIH+SjpnptipragyM/2h8laT9rBTJc3KbtVkU7fKvWzsDZLxl
	 Y6lHvOMxozcQkaGM6vlZHOa0Osk6dnMOfrcPwzG32mL/oxxfOS4cofBzR9/AfmVV/zzzA+Ov9exH
	 DlONspdDLdvpwb/q5GUh/zJIKeQf2w22m24ZGeac3uayfuFb1lItIgK/KnQGo0+7Zu1nZ3PtW69e
	 fpO/UdxwWx8s2MfFmkWhMFtodz+8eHBFCrkjhvbjf2fQTzQ3fAk5wM5L7dbHN1JyVS6GbnkkoFhX
	 o97hJR9Ew9lQckH9vaI6ds23uTB7QtOzCLIF5/ZPsLTfA92VT9Pnmfh2joKSoIUv8Nz700WMEJ1F
	 UA0dykvTAlPZuZSprn1VQ4wXHe2wpMNF/61cjdOg8=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
From: Edward Adam Davis <eadavis@qq.com>
To: amir73il@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
Date: Wed,  6 Nov 2024 18:18:00 +0800
X-OQ-MSGID: <20241106101800.2714578-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAOQ4uxi-G3u0fXDdD4a_5p_HAFSh7oJ5C0w5RZeDh=jM353qvg@mail.gmail.com>
References: <CAOQ4uxi-G3u0fXDdD4a_5p_HAFSh7oJ5C0w5RZeDh=jM353qvg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 6 Nov 2024 09:20:24 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 6, 2024 at 3:43 AM Edward Adam Davis <eadavis@qq.com> wrote:
> >
> > On Mon, 4 Nov 2024 20:30:41 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > When the memory is insufficient, the allocation of fh fails, which causes
> > > > the failure to obtain the dentry fid, and finally causes the dentry encoding
> > > > to fail.
> > > > Retry is used to avoid the failure of fh allocation caused by temporary
> > > > insufficient memory.
> > > >
> > > > #syz test
> > > >
> > > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > > index 2ed6ad641a20..1e027a3cf084 100644
> > > > --- a/fs/overlayfs/copy_up.c
> > > > +++ b/fs/overlayfs/copy_up.c
> > > > @@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
> > > >         int fh_type, dwords;
> > > >         int buflen = MAX_HANDLE_SZ;
> > > >         uuid_t *uuid = &real->d_sb->s_uuid;
> > > > -       int err;
> > > > +       int err, rtt = 0;
> > > >
> > > >         /* Make sure the real fid stays 32bit aligned */
> > > >         BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
> > > >         BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
> > > >
> > > > +retry:
> > > >         fh = kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
> > > > -       if (!fh)
> > > > +       if (!fh) {
> > > > +               if (!rtt) {
> > > > +                       cond_resched();
> > > > +                       rtt++;
> > > > +                       goto retry;
> > > > +               }
> > > >                 return ERR_PTR(-ENOMEM);
> > > > +       }
> > > >
> > > >         /*
> > > >          * We encode a non-connectable file handle for non-dir, because we
> > > >
> > >
> > > This endless loop is out of the question and anyway, syzbot reported
> > > a WARN_ON in line 448:
> > >             WARN_ON(fh_type == FILEID_INVALID))
> > >
> > > How does that have to do with memory allocation failure?
> > > What am I missing?
> > Look following log, it in https://syzkaller.appspot.com/text?tag=CrashLog&x=178bf640580000:
> > [   64.050342][ T5103] FAULT_INJECTION: forcing a failure.
> > [   64.050342][ T5103] name failslab, interval 1, probability 0, space 0, times 0
> > [   64.055933][ T5103] CPU: 0 UID: 0 PID: 5103 Comm: syz-executor195 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
> > [   64.060023][ T5103] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > [   64.063941][ T5103] Call Trace:
> > [   64.065199][ T5103]  <TASK>
> > [   64.066296][ T5103]  dump_stack_lvl+0x241/0x360
> > [   64.068028][ T5103]  ? __pfx_dump_stack_lvl+0x10/0x10
> > [   64.069939][ T5103]  ? __pfx__printk+0x10/0x10
> > [   64.071667][ T5103]  ? __kmalloc_cache_noprof+0x44/0x2c0
> > [   64.073756][ T5103]  ? __pfx___might_resched+0x10/0x10
> > [   64.075720][ T5103]  should_fail_ex+0x3b0/0x4e0
> > [   64.077525][ T5103]  should_failslab+0xac/0x100
> > [   64.079341][ T5103]  ? ovl_encode_real_fh+0xdf/0x410
> > [   64.081295][ T5103]  __kmalloc_cache_noprof+0x6c/0x2c0
> > [   64.083282][ T5103]  ? dput+0x37/0x2b0
> > [   64.084758][ T5103]  ovl_encode_real_fh+0xdf/0x410
> > [   64.086578][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> > [   64.088687][ T5103]  ? _raw_spin_unlock+0x28/0x50
> > [   64.090550][ T5103]  ovl_encode_fh+0x388/0xc20
> > [   64.092281][ T5103]  exportfs_encode_fh+0x1bd/0x3e0
> > [   64.094122][ T5103]  ovl_encode_real_fh+0x129/0x410
> > [   64.095883][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> > [   64.097852][ T5103]  ? bpf_lsm_capable+0x9/0x10
> > [   64.099620][ T5103]  ? capable+0x89/0xe0
> > [   64.101064][ T5103]  ovl_copy_up_flags+0x1068/0x46f0
> 
> I see. it is nested overlayfs, so a memory allocation failure in the lower
> overlayfs, causes ovl_encode_fh() to return FILEID_INVALID.
> 
> > >
> > > Probably this WARN_ON as well as the one in line 446 should be
> > > relaxed because it is perfectly possible for fs to return negative or
> > > FILEID_INVALID for encoding a file handle even if fs supports encoding
> > > file handles.
> > >
> 
> As I wrote, the correct fix is to relax the WARN_ON from
> fh_type == FILEID_INVALID and fh_type < 0 conditions because
> those are valid return values from filesystems.
Oh, You mean is following diff?
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2ed6ad641a20..32890cc0dd4a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -443,9 +443,7 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	buflen = (dwords << 2);
 
 	err = -EIO;
-	if (WARN_ON(fh_type < 0) ||
-	    WARN_ON(buflen > MAX_HANDLE_SZ) ||
-	    WARN_ON(fh_type == FILEID_INVALID))
+	if (WARN_ON(buflen > MAX_HANDLE_SZ))
 		goto out_err;
 
 	fh->fb.version = OVL_FH_VERSION;

BR,
Edward

