Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662918FDBD;
	Wed,  6 Nov 2024 02:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861328; cv=none; b=rcmO2Tz74tIkuHg8oGhhQAki4L2P3KXr1rwRuTd6bHX0DQxVVN9gFoV1Ej48Z8vDjPwuQd5z124wFylcgXoX/x36szyritaIdzAAi3RNTne/RW9DG8ZAh+YrD9EWhI+1vBBhKAHsHOKPfr1HxLATtdibvXW5l/JA2a4zWe3eS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861328; c=relaxed/simple;
	bh=QOrImSK0hg5ydT4HwsfZrscj/PlBvtMgGyH7EyIXKGk=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=qvpHz4P8hfSq0sObk6BoNoEJZvKOXFo8NGmfVHQf/x/tcTc82A59JE8p4HMl8c6pwfGiQDZ6s1zRsio2zEAoOua2nkRhbGJjFK5UZp1cJeLacv+gluekBF6+pDHymPVp2bBVphvtJn9GE4eP8E9Sy26XmAn6ynJz6VhC4tfZzPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=fXSJHclB; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="fXSJHclB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1730861009; bh=hlblUX/gTuLZm2ipCTlUMuheFF4/JFiZiaJdoDzf2VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXSJHclB71qGUbbN6uk323yoCXbuRkbCu8RF/UVRGapPug27jAUjeVHGCkYOl3j8u
	 rFixzNCVVqs3fWhTuAi0y2RQQUZU9uohnGk31A9XaJq73NLF/luOI9dABoWsd18NXo
	 x6LV1+xOBGvxHUJDjs3PRj8W6R8fey9v336VaDy4=
Received: from pek-lxu-l1.wrs.com ([111.198.227.254])
	by newxmesmtplogicsvrszc25-0.qq.com (NewEsmtp) with SMTP
	id ADB3723F; Wed, 06 Nov 2024 10:43:27 +0800
X-QQ-mid: xmsmtpt1730861007tl5dp6c37
Message-ID: <tencent_08A4E8A2ED86CE7C793E6CC02FBD6FF0960A@qq.com>
X-QQ-XMAILINFO: MFdGPHhuqhNoeFJ+CWM0ortNQvLCpRtOghaIjg5dFym8IAAj24zyXruGFU2Cx4
	 3vAqFUBnYd7FsBYk7v040oBllF86Xm0xK0stjo06OAa1hvbXaFHAnVTEt80bNpH3U4t5HkUvZBUH
	 +I1bkg/lUYi9DMwWWbNmgKIrbrT6wobHGINjQJl/xzartqdlbLW+j4HvzKwht5o+cHXZAZ5QI5lj
	 reShU9ohFRE4sNuDkIi8tSM28H8WOC3vZmkfoMU9ZWN+m/GztnShIGeeuoj0a7xrOnIz9stBBXQu
	 UBOFLmYQcEdnALGKK4qodZ0Db9FUL8loNR71A3iGkMZyE4oW5LjliP6K2xRaBmARhYH8tuLQIkRi
	 /uEZwjwkm/0mvdwF+yx5tn+U2jURDrDN4gTue4h2zTdeatyVZUQArao5L88ER7kmQsraO30wxKIc
	 nYpQVhKFpzehZUMeyu7608JLY1XNa0ZWexD4KPRO/5rDJNVxrWot1kHZ7E1/BUgBQD3+m9BTM2FF
	 vISeQi28HKpjyw5vd0EyZRVUVtynG06urOWLzLSgQd77rlWjT7qabvsl3WHvZbrutCsEaRcbwt0J
	 F4i+kxRCztPOw7m/Nrm6Vi4DZm0phPsdjF3Aj7rKe/AlMi2LrURPn/F31Hlk2U9cDkBMXWRUhRbm
	 2eh/DzVFqovvyYfcElcsYL4f43e7mLMdQaTtC8xJVkpsFmT0+/Tc8Y/Jg3KvIfKyqLc/sdzRGE1B
	 +rsCbTThbrm3sbSDbDgOc8P7YvacPkmcLGfsn+Eo7tU51liKsliNfnIXW8OUUm3K0pFMeIQoACVk
	 EC3HbTtfDKOehC//LyYyHbfOquwqti//PPpTFzeBdy00ixnnGw8b8HXmt+TlJ7pW9yI2rAttWyDM
	 GNkdh1YIPWr2Mz5YFajmOn3PuXXr2mJK3rclIT+BKNwMPelqFBQ0ejnu+hxvOvXUxzDZZ7JA2r
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: amir73il@gmail.com
Cc: eadavis@qq.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzbot+ec07f6f5ce62b858579f@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_encode_real_fh
Date: Wed,  6 Nov 2024 10:43:28 +0800
X-OQ-MSGID: <20241106024327.2279958-2-eadavis@qq.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <CAOQ4uxi36iUbYa27c81pNpO7T0vR=rY63b7KACJLP6b4HTJGXQ@mail.gmail.com>
References: <CAOQ4uxi36iUbYa27c81pNpO7T0vR=rY63b7KACJLP6b4HTJGXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 4 Nov 2024 20:30:41 +0100, Amir Goldstein <amir73il@gmail.com> wrote:
> > When the memory is insufficient, the allocation of fh fails, which causes
> > the failure to obtain the dentry fid, and finally causes the dentry encoding
> > to fail.
> > Retry is used to avoid the failure of fh allocation caused by temporary
> > insufficient memory.
> >
> > #syz test
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 2ed6ad641a20..1e027a3cf084 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -423,15 +423,22 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
> >         int fh_type, dwords;
> >         int buflen = MAX_HANDLE_SZ;
> >         uuid_t *uuid = &real->d_sb->s_uuid;
> > -       int err;
> > +       int err, rtt = 0;
> >
> >         /* Make sure the real fid stays 32bit aligned */
> >         BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
> >         BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
> >
> > +retry:
> >         fh = kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
> > -       if (!fh)
> > +       if (!fh) {
> > +               if (!rtt) {
> > +                       cond_resched();
> > +                       rtt++;
> > +                       goto retry;
> > +               }
> >                 return ERR_PTR(-ENOMEM);
> > +       }
> >
> >         /*
> >          * We encode a non-connectable file handle for non-dir, because we
> >
> 
> This endless loop is out of the question and anyway, syzbot reported
> a WARN_ON in line 448:
>             WARN_ON(fh_type == FILEID_INVALID))
> 
> How does that have to do with memory allocation failure?
> What am I missing?
Look following log, it in https://syzkaller.appspot.com/text?tag=CrashLog&x=178bf640580000:
[   64.050342][ T5103] FAULT_INJECTION: forcing a failure.
[   64.050342][ T5103] name failslab, interval 1, probability 0, space 0, times 0
[   64.055933][ T5103] CPU: 0 UID: 0 PID: 5103 Comm: syz-executor195 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
[   64.060023][ T5103] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
[   64.063941][ T5103] Call Trace:
[   64.065199][ T5103]  <TASK>
[   64.066296][ T5103]  dump_stack_lvl+0x241/0x360
[   64.068028][ T5103]  ? __pfx_dump_stack_lvl+0x10/0x10
[   64.069939][ T5103]  ? __pfx__printk+0x10/0x10
[   64.071667][ T5103]  ? __kmalloc_cache_noprof+0x44/0x2c0
[   64.073756][ T5103]  ? __pfx___might_resched+0x10/0x10
[   64.075720][ T5103]  should_fail_ex+0x3b0/0x4e0
[   64.077525][ T5103]  should_failslab+0xac/0x100
[   64.079341][ T5103]  ? ovl_encode_real_fh+0xdf/0x410
[   64.081295][ T5103]  __kmalloc_cache_noprof+0x6c/0x2c0
[   64.083282][ T5103]  ? dput+0x37/0x2b0
[   64.084758][ T5103]  ovl_encode_real_fh+0xdf/0x410
[   64.086578][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
[   64.088687][ T5103]  ? _raw_spin_unlock+0x28/0x50
[   64.090550][ T5103]  ovl_encode_fh+0x388/0xc20
[   64.092281][ T5103]  exportfs_encode_fh+0x1bd/0x3e0
[   64.094122][ T5103]  ovl_encode_real_fh+0x129/0x410
[   64.095883][ T5103]  ? __pfx_ovl_encode_real_fh+0x10/0x10
[   64.097852][ T5103]  ? bpf_lsm_capable+0x9/0x10
[   64.099620][ T5103]  ? capable+0x89/0xe0
[   64.101064][ T5103]  ovl_copy_up_flags+0x1068/0x46f0
> 
> Probably this WARN_ON as well as the one in line 446 should be
> relaxed because it is perfectly possible for fs to return negative or
> FILEID_INVALID for encoding a file handle even if fs supports encoding
> file handles.
> 

BR,
Edward

