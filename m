Received: from out162-62-57-64.mail.qq.com (out162-62-57-64.mail.qq.com [162.62.57.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B061DE3DE;
	Wed,  6 Nov 2024 10:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730889929; cv=none; b=s8JMJCwpUNNlmtQ0PBreKb3QfR3IMht/yDFigZBkJvtdXtD9nQLY87eg++vpC9EfJ1gvIQW4ZR7BB88BoVy5DUT8/VDlrPMWFpqywFfJHrI4xEtJzDwZzmpoBVUkYVVHAF6VShu2LQxfRQTBrNc2gWpJW85KdfxdgMwKpGwLVsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730889929; c=relaxed/simple;
	bh=SXocsmptmWOl58VtIWO4woZOJgSDAP5pUHSP9v3rubE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTBOKkzsKxON+Tz4O4KXxNHgUvApwNJ4k3UX7XCpwwbuqpjEOKSMkV1ZMaQptqDPz/+WYGrKtQV42gQHaF+wqQdwM88Y46c+zwYZp/bjWyTayu6nrCTFIpnGOvFGTk0Vss46upDNTttCLLKbvy7+7poIyAgJXqmtQpSFufkqKDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Eeutc520; arc=none smtp.client-ip=162.62.57.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Eeutc520"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1730889920; bh=2aNgzlTr8Esmv2UaldoJ+oGbR6tIhQvcSPm1ett8XBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eeutc520chS1ImZYKqoNt3eEAyhbfaNRmJRkn7XCOrwvuTNyo0/YrFMoHYZ7cuNa7
	 MwV3oadM/R35pNqL276CVUVCRw5zneyHgm0vYqQm7t00qR1WFQ04R2Yzxi+SZ7DHD1
	 nRbiACZX232Z3oQ82R0uRszX88Ynz+2eMUrUIOyM=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id B5229809; Wed, 06 Nov 2024 18:45:18 +0800
X-QQ-mid: xmsmtpt1730889918t3soze5wc
Message-ID: <tencent_26AD044DF763D77266CFF361A365496AE305@qq.com>
X-QQ-XMAILINFO: MB5+LsFw85NoVPA33W2QWSrkqEszUxnBHHgdSzWGqle/AO8MVOUhw4/UoQE3a6
	 4osdoCQOIv+3y9Vt+XmSnG+V0GD8437H0n4L1CP8+o95gNTKxXTAIjhw3W9IfMZtZU1TWKQaPaG3
	 AaqYcw7GjvH8CTTnjW1u+iauPYaOE6eCg3IOu+AMg5OcpthEDUyiOCnDeZ2k4gUJa0YrV6ev2hqt
	 FdXG4ZEWQaW38iuP1UzPz3PbqPZ0HI9wk7J6K0qDW3b4+FYqo5nqTg8o79pSTkjp4fhYVDFEKLXL
	 h1fwES9+f6VUhNZ3yEUxqcK7BoR77DHzIvAkj1u6RLV7Wmtp+dFrsgDeH9FLcGiUc94CyYdJvuoF
	 fRvzKBtPlYbGEgaahpHi3JnSMd0O6ndptZ3tJDrlo+KC1VIWv4rgDjMYIBSW9EzsVbjbbd5oIFNc
	 Hp7jLxMWTHeUk76PhYd2GHboe5SSgj/52DvtwWjuPGLCDb0GXJitvjaSaK7yo+Cn/gSS3X9Y+dBa
	 vLkV7NUwIF1ML4fGpcuxDQKZ1FlpaWZEwx7jU7N26OvvL34R9pH41rDzADP53NSuEM1aBrPe8hsO
	 p2QfLyJm34eZx0NGB6eliGNlXIqWoEul6YL+njS5VovQA3GgmiF7vXVh6Po2OgFRqWv8vW1r8Guw
	 knf5/SektuiEXyHCnEmuppk18sv3HKcatoPbw9nGLoa8MH2fJQpbH4b4edr4tT8iSg9XPXIRKTbV
	 XYX4Dp8vB9bhuBTocBiEfRGBryCNbvlpTsd6kOgnDd0B00by6ynupDx54S7jzMz9NnKmgRO31Z1V
	 Fxp1AbBKBy+9TJVHLy87Ennaxt/Q6zSDokOAvbJbemVyp3R2YaDWIUreantPQwfvuRlVkdy6//M1
	 SnDerbZ9WqOWsrwsgGcBm+EDFEn/qGI1tOu6fGvSaQmXDCvvKP2w/A1MSoppJSZ3lFn1SHtRgFRP
	 QK753jIVyN3bP5BqDu3w==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Edward Adam Davis <eadavis@qq.com>
To: amir73il@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
Date: Wed,  6 Nov 2024 18:45:16 +0800
X-OQ-MSGID: <20241106104517.2742837-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAOQ4uxgU0fdEtksACCmvrUEU+hhsBJqK+HSVEhW9vqcvAakCrA@mail.gmail.com>
References: <CAOQ4uxgU0fdEtksACCmvrUEU+hhsBJqK+HSVEhW9vqcvAakCrA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 6 Nov 2024 11:34:13 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 6, 2024 at 11:18 AM Edward Adam Davis <eadavis@qq.com> wrote:
> >
> > On Wed, 6 Nov 2024 09:20:24 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> > > On Wed, Nov 6, 2024 at 3:43 AM Edward Adam Davis <eadavis@qq.com> wrote:
> > > >
> > > > On Mon, 4 Nov 2024 20:30:41 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > > When the memory is insufficient, the allocation of fh fails, which causes
> > > > > > the failure to obtain the dentry fid, and finally causes the dentry encoding
> > > > > > to fail.
> > > > > > Retry is used to avoid the failure of fh allocation caused by temporary
> > > > > > insufficient memory.
> > > > > >
> > > > > > #syz test
> > > > > >
> > > > > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > > > > > index 2ed6ad641a20..1e027a3cf084 100644
> > > > > > --- a/fs/overlayfs/copy_up.c
> > > > > > +++ b/fs/overlayfs/copy_up.c
> > > > > > @@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
> > > > > >         int fh_type, dwords;
> > > > > >         int buflen = MAX_HANDLE_SZ;
> > > > > >         uuid_t *uuid = &real->d_sb->s_uuid;
> > > > > > -       int err;
> > > > > > +       int err, rtt = 0;
> > > > > >
> > > > > >         /* Make sure the real fid stays 32bit aligned */
> > > > > >         BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
> > > > > >         BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
> > > > > >
> > > > > > +retry:
> > > > > >         fh = kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
> > > > > > -       if (!fh)
> > > > > > +       if (!fh) {
> > > > > > +               if (!rtt) {
> > > > > > +                       cond_resched();
> > > > > > +                       rtt++;
> > > > > > +                       goto retry;
> > > > > > +               }
> > > > > >                 return ERR_PTR(-ENOMEM);
> > > > > > +       }
> > > > > >
> > > > > >         /*
> > > > > >          * We encode a non-connectable file handle for non-dir, because we
> > > > > >
> > > > >
> > > > > This endless loop is out of the question and anyway, syzbot reported
> > > > > a WARN_ON in line 448:
> > > > >             WARN_ON(fh_type == FILEID_INVALID))
> > > > >
> > > > > How does that have to do with memory allocation failure?
> > > > > What am I missing?
> > > > Look following log, it in https://syzkaller.appspot.com/text?tag=CrashLog&x=178bf640580000:
> > > > [   64.050342][ T5103] FAULT_INJECTION: forcing a failure.
> > > > [   64.050342][ T5103] name failslab, interval 1, probability 0, space 0, times 0
> > > > [   64.055933][ T5103] CPU: 0 UID: 0 PID: 5103 Comm: syz-executor195 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
> > > > [   64.060023][ T5103] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> > > > [   64.063941][ T5103] Call Trace:
> > > > [   64.065199][ T5103]  <TASK>
> > > > [   64.066296][ T5103]  dump_stack_lvl+0x241/0x360
> > > > [   64.068028][ T5103]  ? __pfx_dump_stack_lvl+0x10/0x10
> > > > [   64.069939][ T5103]  ? __pfx__printk+0x10/0x10
> > > > [   64.071667][ T5103]  ? __kmalloc_cache_noprof+0x44/0x2c0
> > > > [   64.073756][ T5103]  ? __pfx___might_resched+0x10/0x10
> > > > [   64.075720][ T5103]  should_fail_ex+0x3b0/0x4e0
> > > > [   64.077525][ T5103]  should_failslab+0xac/0x100
> > > > [   64.079341][ T5103]  ? ovl_encode_real_fh+0xdf/0x410
> > > > [   64.081295][ T5103]  __kmalloc_cache_noprof+0x6c/0x2c0
> > > > [   64.083282][ T5103]  ? dput+0x37/0x2b0
> > > > [   64.084758][ T5103]  ovl_encode_real_fh+0xdf/0x410
> > > > [   64.086578][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> > > > [   64.088687][ T5103]  ? _raw_spin_unlock+0x28/0x50
> > > > [   64.090550][ T5103]  ovl_encode_fh+0x388/0xc20
> > > > [   64.092281][ T5103]  exportfs_encode_fh+0x1bd/0x3e0
> > > > [   64.094122][ T5103]  ovl_encode_real_fh+0x129/0x410
> > > > [   64.095883][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
> > > > [   64.097852][ T5103]  ? bpf_lsm_capable+0x9/0x10
> > > > [   64.099620][ T5103]  ? capable+0x89/0xe0
> > > > [   64.101064][ T5103]  ovl_copy_up_flags+0x1068/0x46f0
> > >
> > > I see. it is nested overlayfs, so a memory allocation failure in the lower
> > > overlayfs, causes ovl_encode_fh() to return FILEID_INVALID.
> > >
> > > > >
> > > > > Probably this WARN_ON as well as the one in line 446 should be
> > > > > relaxed because it is perfectly possible for fs to return negative or
> > > > > FILEID_INVALID for encoding a file handle even if fs supports encoding
> > > > > file handles.
> > > > >
> > >
> > > As I wrote, the correct fix is to relax the WARN_ON from
> > > fh_type == FILEID_INVALID and fh_type < 0 conditions because
> > > those are valid return values from filesystems.
> > Oh, You mean is following diff?
> 
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 2ed6ad641a20..32890cc0dd4a 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -443,9 +443,7 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
> >         buflen = (dwords << 2);
> >
> >         err = -EIO;
> > -       if (WARN_ON(fh_type < 0) ||
> > -           WARN_ON(buflen > MAX_HANDLE_SZ) ||
> > -           WARN_ON(fh_type == FILEID_INVALID))
> > +       if (WARN_ON(buflen > MAX_HANDLE_SZ))
> >                 goto out_err;
> >
> 
> No. sorry, what I meant with "relax WARN_ON" was to remove the WARN_ON, so:
> 
>        err = -EIO;
>        if (fh_type < 0 || fh_type == FILEID_INVALID ||
>            WARN_ON(buflen > MAX_HANDLE_SZ))
>                  goto out_err;
> 
> Meaning that error should definitely be returned in those cases,
> but there is no reason for the assertion which is what syzbot
> was complaining about.
Haha, I was a little dizzy, I deleted too much. Yes, I meant it as your diff.

BR,
Edward

