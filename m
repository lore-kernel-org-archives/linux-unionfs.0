Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0256D261B9A;
	Mon, 18 Aug 2025 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755515777; cv=none; b=f7JKdwDkZadcpzad8t82lpAqkrWV8oxYcCjnzuzfBF3I7DrS0B7dhvWfosgXCYo0RVKKyS9JN9sECBPVfINiB7OIFbMgBSd6wTVSbFlMqYtPshmrE37zlEAL4sbP4X1LLHPuRj7HO0o3sB7KfVUeFZ4LGUntmgUBRDlIiTLT190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755515777; c=relaxed/simple;
	bh=UHl3YSxJthkwgkiqXlD2Ds3JkvMLkpeU3sRkVQlByDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qNLsYxSmqW81g0VklqctmXjwm/KE9226qeiiWUSmNsOKIw8tz1sYhEN3pHvgIeQNaIzGiUJ9KPm5Yj913RtLDS0PXkzO+RU2F8SHrbCbmwvF/pJId/FGeD3L1fjbkXX4hLadWiEO9LQi5pLdTfBER9Ck67Z1hYEpFq56uAWLk9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gcOJaqG6; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gcOJaqG6"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-618aea78f23so3543807a12.3;
        Mon, 18 Aug 2025 04:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755515774; x=1756120574; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MV0cIbZnj4xhKyQPoyhNPQGNNuLSSXTuac6vTpZ00k=;
        b=gcOJaqG6Z6Yud2c2hisHGX4qaf7g/sLssX8alArdffqUWcb7DG8cFYMU5S/qPALrRx
         PfxT30OC7YHdhWRa0wajvq40plFP35sk4WjqnJL2U7eAHghXPx+97NB4pfGmKBlgerYg
         4XdZUBO6wqD3NnNlLnBDhfafzj4ib6mid6MRWa/PUqVCcvKSkl/4HY/DY5F9GYKdBwT/
         VT9Berm+asZ/twM2x+lcDyKWYn36F3/iuX31k/XHK2XBtqgo0zdpOzAieE0HmW2coh9C
         Tj9ISs3JQk8asnSlKztb1iL16yIu6vpdu8TORkqNwPAAv55acia4I70v9WfEjPfnuqFq
         hRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755515774; x=1756120574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2MV0cIbZnj4xhKyQPoyhNPQGNNuLSSXTuac6vTpZ00k=;
        b=jjjpPnGjeA16s1+GahynCad1kMFUXUqPt2s0O2UFcA+cmVc/D0u84vKbfdWmYSIHhA
         DbcGM091Dis69zTYQwCoDap7LqUhbx+CBMt/XeWp8jNIwiRXrhA2LA3/h0tZ01hbJleo
         TTML2wrS2/NRh+UosvzLfyv0ZRsrkDPhq9Z42eB38ArNg9ohfUXKZSC7l4/apcyzMuSN
         tG2cS4BZmYaxJU/uwfZuUDncdH9oTPhpNk7feJnuhgk6hu60sf8dpmAmGq/l377EON5C
         RsWRR4/QWsHSfOPFBhYlYRNOZvKc2VxBVIJnTiabrDrV88jfsagrYURRHUwbGjyCJl0M
         HcXg==
X-Forwarded-Encrypted: i=1; AJvYcCV0ltdVz9Io25fqRiL/PuR+nBU3N01SS7O4rX8BH1HYLAVTbFM+m0Y262diKDXPYaDshc86yvsgQ1yf8Z321w==@vger.kernel.org, AJvYcCXgQUYYdwlvmq9079BmrGrlV+wTIbTpHyq43YXoJZgUxvTakhLNnySuExPFlqegW0FHi7pmMVdymnG6H20=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzt+S5knQ7odVH0MCiiFwoG8hLLF1b0JG04BiB+tP8zlMktOQh
	457glIj+HEYfYg9qDHAi1iYz0jbQ6Ea5P6l4D2npvIFcCd50vl3lLitCAgBwUj9sYe1ksteU/QX
	QBuRMWnl/ffScDw6XNHuLUgQT45vik00=
X-Gm-Gg: ASbGncsC/JO9tbITzrv6SRCfvGnpXZuCHKx5d9B3UMt6oFRsyLSEW2G48qtX1V17xPW
	2O5g31yJjCqykwonD0Ak2yFMQdl/VabxqOcFr65rYkoFInW+60NIddRT2CswC/4zMS5xjgeat0K
	Nn/6+E4yuN2R7fnNFtc+6eFjkLMjZsuyGZDPaa5uw5N2oWl+fW2F7jwGW+1qh29EyKINRU6Eg1f
	a1nNq8=
X-Google-Smtp-Source: AGHT+IFayKKz6BhBN8U24mL6NLXtdlzlqVhgCQvhy6H2IU9A+S5OQWOAXUAMtxWhVFkAtaWwAEy2hD9TXbVE7fAwyW4=
X-Received: by 2002:a05:6402:84d:b0:615:a847:c179 with SMTP id
 4fb4d7f45d1cf-618b054b8e0mr9835935a12.18.1755515773982; Mon, 18 Aug 2025
 04:16:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <689ff631.050a0220.e29e5.0033.GAE@google.com> <CAOQ4uxibh4-ZM+77i7pxe_LH-Rt-QG4d0QtDQ27PXV-8Jnj+Mw@mail.gmail.com>
 <175547723217.2234665.3959316236142184849@noble.neil.brown.name>
In-Reply-To: <175547723217.2234665.3959316236142184849@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 18 Aug 2025 13:16:02 +0200
X-Gm-Features: Ac12FXzPwuRcrJ--vTMcoQPncBLZIAZcYYb_22yGAoWNQUni51mIyyCXCmtmjzQ
Message-ID: <CAOQ4uxhEzxvgpJ=_a++xdGAptsywc4gLmnJXBA7ipFmM+qHR3g@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
To: NeilBrown <neil@brown.name>
Cc: syzbot <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 2:34=E2=80=AFAM NeilBrown <neil@brown.name> wrote:
>
> On Mon, 18 Aug 2025, Amir Goldstein wrote:
> > Neil,
> >
> > I will have a look tomorrow.
> > If you have ideas I am open to hear them.
> > The repro is mounting overlayfs all over each other in concurrent threa=
ds
> > and one of the rmdir of "work" dir triggers this assertion
>
> My guess is that by dropping and retaking the lock, we open the
> possibility of a race so that by the time vfs_unlink() is called the
> dentry has already been unlinked.  In that case it would be unhashed.
> So after retaking the lock we need to check d_unhashed() as well as
> ->d_parent.
>
> So something like
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -1552,7 +1552,8 @@ void ovl_copyattr(struct inode *inode)
>  int ovl_parent_lock(struct dentry *parent, struct dentry *child)
>  {
>         inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> -       if (!child || child->d_parent =3D=3D parent)
> +       if (!child ||
> +           (!d_unhashed(child) && child->d_parent =3D=3D parent))
>                 return 0;
>
>         inode_unlock(parent->d_inode);
>
>
> NeilBrown
>

Nice!
I pushed this commit to ovl-fixes:

commit c56976d86e11afcd6b23633395a7f2e6e920e42d (HEAD -> ovl-fixes)
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Mon Aug 18 11:23:55 2025 +0200

    ovl: fix possible double unlink

    commit 9d23967b18c6 ("ovl: simplify an error path in
    ovl_copy_up_workdir()") introduced the helper ovl_cleanup_unlocked(),
    which is later used in several following patches to re-acquire the pare=
nt
    inode lock and unlink a dentry that was earlier found using lookup.
    This helper was eventually renamed to ovl_cleanup().

    The helper ovl_parent_lock() is used to re-acquire the parent inode loc=
k.
    After acquiring the parent inode lock, the helper verifies that the
    dentry has not since been moved to another parent, but it failed to
    verify that the dentry wasn't unlinked from the parent.

    This means that now every call to ovl_cleanup() could potentially
    race with another thread, unlinking the dentry to be cleaned up
    underneath overlayfs and trigger a vfs assertion.

    Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
    Tested-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
    Fixes: 9d23967b18c6 ("ovl: simplify an error path in ovl_copy_up_workdi=
r()")
    Suggested-by: NeilBrown <neil@brown.name>
    Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Neil,

Please review my commit message.
If you want me to assign you ownership please sign off on this commit messa=
ge.

Thanks,
Amir.
