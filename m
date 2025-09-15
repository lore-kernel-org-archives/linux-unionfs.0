Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF96350D46
	for <linux-unionfs@vger.kernel.org>; Mon, 15 Sep 2025 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757950197; cv=none; b=csTbMLHOiUZXlr+9ZPXpcShutLzyudOOohd6Cb7AZsX4bj1bzTvQAhaVuRqe2NVQL2ZWJdfWoIfiNaGpRjDuNMwsyCZFYpsyd51vGUXPQ6GIEijHBPJ50OpFR8d3crWrXaemZypmDsd+MMxiwX6hX2p1n9aY7S+YmCZYSahNaTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757950197; c=relaxed/simple;
	bh=YuGKbbBQeAOFe11AzIFAEXN5dtq282XmgJD2V7U1TQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=My4wpuFQMEFEYA5+/ukUvM+Glsuq+MjLFnXaFFKj5wjcNAPVDohShwPTqJUUz7KSrw7LIu1+ST+KA+Iq46O80Jwz5s96APYdyKhtYvhhkd9qyaYz/O3N8itaCczLI8EifMFMdx/IHOLlzsWKS3iP7u3meEooovWTeYtN/0OyWNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LiiiSV9i; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LiiiSV9i"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62ef469bb2cso5240709a12.2
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Sep 2025 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757950194; x=1758554994; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsbTlX6nanbvH5f2tDWnICsM+5DdN8K//SzupK675NI=;
        b=LiiiSV9iNYOldSHCmj+ZdpbqL0pqxO0wJmt7qJK6DtNQP3ZOQNla5jKDRrHzSd3WQp
         /gFNLeErWnH0DqOnHQBPYB+nC6p5nLhtdnGcuESp119xkelii3at9EeUpXgcnon8TIOe
         xZShgxzHIq81cfjgjkXMXbskQ4Z/qtpDtAonPqu2Fwa7Ri1dVzW1PJi/t2cQ1CYG/G+P
         aiv1bKC+k4JvsV/igkVvZqzMsODg1dXhwVK4SxrTNVaqGjKxQa02fz55aKZazv4WecxQ
         cdOKK6O6SC2M9Q/87GrvrB0/exszf15tsukNwsoU/0a23+GRsdV7coMDi3IK8ET+eR/i
         SJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757950194; x=1758554994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsbTlX6nanbvH5f2tDWnICsM+5DdN8K//SzupK675NI=;
        b=YumZWgW0KPRN1jJbjtnkNyRcJ+FakPusVej8m+sG6lgyQuLBCQGQ32pcGzQeGGNJTq
         06P81+dmKKu+hxDh5Jdc1EXjcjxaJKzbe7UCVJRg//X6xAfllK4FXisp1bd2TYtmgtEa
         meYetuUsgfignTqMDe47TezlMM56T4iq4Vml40ilTUudWrSYjW+f5JYVNSY10Aj1HqXy
         x95D2b+ZpY/5XYVphWw6E/4F41QzacegDwCYbKk90HJvPz0a1sQXWNl/LJqbDvJXPvw/
         19M2+CZ/HnogThGeJqxpeRce662AU0tUioKVJzEL1jUSexTI0GcrvNa4SZjLkVBmX8/5
         0mEw==
X-Gm-Message-State: AOJu0Yzv1zrNocxYuGeMIyUfKFYhR+HdYDNZlF2NU/zv6/J9k0SIGhI6
	OM5+ZtH7HPd5MNE/CtA699JEP1UQ77zgVJs8Of7AH+/P6ZYHARlSAljKbwlqRFe7bxjtVvXGkjM
	ZUJB4cqb1xqcqrD7KL/ERqKPuyHic3zU=
X-Gm-Gg: ASbGncto1ZBeP38unXFGk4al7axH+OcoTzs+V54xWHyLtpORUw/LTrsM8QLgp2vy/Kh
	ZlhbUKruMWy8nKAGzNOyLmyynMIYSv/SUOGtF9NmHm5NlAFof/dnlyCSO6rUhVGad4I7MG7hNgJ
	zWaskIFVFfsMQPmgWk9mC1c7VQljiuR0W/238jndzEINSqfavdbTgxgLJnlR3Vfn38AXw+7KRT8
	CbCcY3SuqU/SD5CS27if+/fRQPiJlnchOJfftD3zA==
X-Google-Smtp-Source: AGHT+IHwo9Dbn1IBq1pRK2KYpbDo+aDAWPKHa2DN5fGM+stACl5ZbknSqG9QI2B/kqiprzOfMMxWr8rwlPxWBS5iOiY=
X-Received: by 2002:a05:6402:2744:b0:62f:41d3:ece7 with SMTP id
 4fb4d7f45d1cf-62f41d3eee5mr3475949a12.14.1757950193792; Mon, 15 Sep 2025
 08:29:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915101510.7994-1-acsjakub@amazon.de> <CAOQ4uxgXvwumYvJm3cLDFfx-TsU3g5-yVsTiG=6i8KS48dn0mQ@mail.gmail.com>
 <x4q65t5ar5bskvinirqjbrs4btoqvvvdsce2bdygoe33fnwdtm@eqxfv357dyke>
In-Reply-To: <x4q65t5ar5bskvinirqjbrs4btoqvvvdsce2bdygoe33fnwdtm@eqxfv357dyke>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 15 Sep 2025 17:29:40 +0200
X-Gm-Features: AS18NWDzs8ZYHHKEHo80wJYN_pBq_JfjRVuZAjz8emwmk1hcFxQPA6Q11EU_jCw
Message-ID: <CAOQ4uxhbDwhb+2Brs1UdkoF0a3NSdBAOQPNfEHjahrgoKJpLEw@mail.gmail.com>
Subject: Re: [PATCH] ovl: check before dereferencing s_root field
To: Jan Kara <jack@suse.cz>, Jakub Acs <acsjakub@amazon.de>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 4:07=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 15-09-25 15:01:13, Amir Goldstein wrote:
> > On Mon, Sep 15, 2025 at 12:15=E2=80=AFPM Jakub Acs <acsjakub@amazon.de>=
 wrote:
> > >
> > > Calling intotify_show_fdinfo() on fd watching an overlayfs inode, whi=
le
> > > the overlayfs is being unmounted, can lead to dereferencing NULL ptr.
> > >
> > > This issue was found by syzkaller.
> > >
> > > Race Condition Diagram:
> > >
> > > Thread 1                           Thread 2
> > > --------                           --------
> > >
> > > generic_shutdown_super()
> > >  shrink_dcache_for_umount
> > >   sb->s_root =3D NULL
> > >
> > >                     |
> > >                     |             vfs_read()
> > >                     |              inotify_fdinfo()
> > >                     |               * inode get from mark *
> > >                     |               show_mark_fhandle(m, inode)
> > >                     |                exportfs_encode_fid(inode, ..)
> > >                     |                 ovl_encode_fh(inode, ..)
> > >                     |                  ovl_check_encode_origin(inode)
> > >                     |                   * deref i_sb->s_root *
> > >                     |
> > >                     |
> > >                     v
> > >  fsnotify_sb_delete(sb)
> > >
> > > Which then leads to:
> > >
> > > [   32.133461] Oops: general protection fault, probably for non-canon=
ical address 0xdffffc0000000006: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
> > > [   32.134438] KASAN: null-ptr-deref in range [0x0000000000000030-0x0=
000000000000037]
> > > [   32.135032] CPU: 1 UID: 0 PID: 4468 Comm: systemd-coredum Not tain=
ted 6.17.0-rc6 #22 PREEMPT(none)
> > >
> > > <snip registers, unreliable trace>
> > >
> > > [   32.143353] Call Trace:
> > > [   32.143732]  ovl_encode_fh+0xd5/0x170
> > > [   32.144031]  exportfs_encode_inode_fh+0x12f/0x300
> > > [   32.144425]  show_mark_fhandle+0xbe/0x1f0
> > > [   32.145805]  inotify_fdinfo+0x226/0x2d0
> > > [   32.146442]  inotify_show_fdinfo+0x1c5/0x350
> > > [   32.147168]  seq_show+0x530/0x6f0
> > > [   32.147449]  seq_read_iter+0x503/0x12a0
> > > [   32.148419]  seq_read+0x31f/0x410
> > > [   32.150714]  vfs_read+0x1f0/0x9e0
> > > [   32.152297]  ksys_read+0x125/0x240
> > >
> > > IOW ovl_check_encode_origin derefs inode->i_sb->s_root, after it was =
set
> > > to NULL in the unmount path.
> > >
> > > Minimize the window of opportunity by adding explicit check.
> > >
> > > Fixes: c45beebfde34 ("ovl: support encoding fid from inode with no al=
ias")
> > > Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> > > Cc: Miklos Szeredi <miklos@szeredi.hu>
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > Cc: linux-unionfs@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: stable@vger.kernel.org
> > > ---
> > >
> > > I'm happy to take suggestions for a better fix - I looked at taking
> > > s_umount for reading, but it wasn't clear to me for how long would th=
e
> > > fdinfo path need to hold it. Hence the most primitive suggestion in t=
his
> > > v1.
> > >
> > > I'm also not sure if ENOENT or EBUSY is better?.. or even something e=
lse?
> > >
> > >  fs/overlayfs/export.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > > index 83f80fdb1567..424c73188e06 100644
> > > --- a/fs/overlayfs/export.c
> > > +++ b/fs/overlayfs/export.c
> > > @@ -195,6 +195,8 @@ static int ovl_check_encode_origin(struct inode *=
inode)
> > >         if (!ovl_inode_lower(inode))
> > >                 return 0;
> > >
> > > +       if (!inode->i_sb->s_root)
> > > +               return -ENOENT;
> >
> > For a filesystem method to have to check that its own root is still ali=
ve sounds
> > like the wrong way to me.
> > That's one of the things that should be taken for granted by fs code.
> >
> > I don't think this is an overlayfs specific issue, because other fs wou=
ld be
> > happy if encode_fh() would be called with NULL sb->s_root.
>
> Actually, I don't see where that would blow up? Generally references to
> sb->s_root in filesystems outside of mount / remount code are pretty rare=
.
> Also most of the code should be unreachable by the time we set sb->s_root
> to NULL because there are no open files at that moment, no exports etc. B=
ut
> as this report shows, there are occasional surprises (I remember similar
> issue with ext4 sysfs files handlers using s_root without checking couple
> years back).
>

I am not sure that I understand what you are arguing for.
I did a very naive grep s_root fs/*/export.c and quickly found:

static int gfs2_encode_fh(struct inode *inode, __u32 *p, int *len,
                          struct inode *parent)
{
...
        if (!parent || inode =3D=3D d_inode(sb->s_root))
                return *len;

So it's not an overlayfs specific issue, just so happens that zysbot
likes to test overlayfs.

Are you suggesting that we fix all of those one by one?

> > Jan,
> >
> > Can we change the order of generic_shutdown_super() so that
> > fsnotify_sb_delete(sb) is called before setting s_root to NULL?
> >
> > Or is there a better solution for this race?
>
> Regarding calling fsnotify_sb_delete() before setting s_root to NULL:
> In 2019 (commit 1edc8eb2e9313 ("fs: call fsnotify_sb_delete after
> evict_inodes")) we've moved the call after evict_inodes() because otherwi=
se
> we were just wasting cycles scanning many inodes without watches. So movi=
ng
> it earlier wouldn't be great...

Yes, I noticed that and I figured there were subtleties.

In any case, Jakub, your patch is insufficient because:
1. Checking sb->sb_root without a lock and without READ_ONCE()
    and a matching WRITE_ONCE() is not safe
2. sb_root can become NULL after the check since you are not holding
    the s_umount lock

Jakub,

Instead of an unsafe check inside ovl_encode_fh(), I think it is better to =
use
super_trylock_shared() inside show_mark_fhandle() before calling
exportfs_encode_fid()?

Feels like the corner case is show_mark_fhandle() and there is no strong
incentive to make this code very efficient.

Jan, WDYT?

Thanks,
Amir.
