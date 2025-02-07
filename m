Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204E4944E;
	Fri,  7 Feb 2025 12:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738932635; cv=none; b=UsfMaaBvglzjIsni5CNFq9JsoZBYqlQEhiQ+DLswbPVa5b/kidUIJkCNg3E8/Yhca4g2CHQZh/bZVkhVLHsAAoXYbUxkrj6HjTUNmcSEnj/6Y6LODvEYN4WdKlnH4p1IcOM3W6uUdhzEKqqkh3FB+wjOp/Vr5QEf4WeNhZghSOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738932635; c=relaxed/simple;
	bh=/V2vL4d3Yne5ORo7Xl3DE7dnwwt8ZSoieXk9fr9BPwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8KwGEujoDk/o2Q81CsdTyr+mT1xMYAK3srzpH61tUUptQdlzeSXSI7OnUbB2JGwjcKvoWcEvkRKDF8nDjvEsGzsAB5KL3vs4Q4FgKNqxKnz0fND9xPEmWbu2JHQG44TPyMTWHLkBch1VYxlrI+u7Ciol8k5TBHA7uq8zfYNM5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+Z62zta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+Z62zta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB39CC4CED1;
	Fri,  7 Feb 2025 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738932633;
	bh=/V2vL4d3Yne5ORo7Xl3DE7dnwwt8ZSoieXk9fr9BPwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I+Z62zta0Xk2To8OrdW5N/xjm09EFvWmqXS5gOBiK7Vof1yU0vKnlsvX8nTW8aUn5
	 Uiz8RdXc8hl4cO7XVxg2KLjDdD07aDY6c95EibB21T9KXU3Iv8krx2s1BtIQZmjs/V
	 bk8FeF6zI4KDBoVQvFcYa08qnw8MlGBP2qJvp4zBjXCUj0vF51QYSgP2qMY7sPJDmy
	 JyEHRf9AkNztZBYu7bUZT+4QiUwECJHfAzE9wuVoyOMraD/EwV5gc/Rp1MZucDGA2p
	 LllrwLrLSpPVjTnR3F9056sjqP8YgElJ6o7rgc71GJZXKlWLN0AboHwkPLSe3cQ7SH
	 OHSZD8GltobVw==
Date: Fri, 7 Feb 2025 13:50:28 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Lizhi Xu <lizhi.xu@windriver.com>, 
	syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] fs: prevent access to ns if it is not mounted
Message-ID: <20250207-radikal-radio-f968e6a4bab2@brauner>
References: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com>
 <20250207071331.550952-1-lizhi.xu@windriver.com>
 <CAOQ4uxhAB4=kp4NSw=hs0S1HyPFcL3FTGkMgoTuxRSa8eu1n+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhAB4=kp4NSw=hs0S1HyPFcL3FTGkMgoTuxRSa8eu1n+g@mail.gmail.com>

On Fri, Feb 07, 2025 at 01:42:50PM +0100, Amir Goldstein wrote:
> On Fri, Feb 7, 2025 at 8:13 AM Lizhi Xu <lizhi.xu@windriver.com> wrote:
> >
> > syzbot reported a null ptr deref in clone_private_mount. [1]
> >
> > The mnt_ns member should be accessed after confirming that it has been mounted.
> >
> > [1]
> > KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
> > CPU: 0 UID: 0 PID: 5834 Comm: syz-executor772 Not tainted 6.14.0-rc1-next-20250206-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
> > RIP: 0010:is_anon_ns fs/mount.h:159 [inline]
> > RIP: 0010:clone_private_mount+0x184/0x3e0 fs/namespace.c:2425
> 
> The splat beyond this point is mainly noise I think and referencing [1] is also
> a bit weird in the context of this short message
> 
> > Reported-by: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com
> 
> Missing:
> Fixes: ae63304102ecd ("fs: allow detached mounts in clone_private_mount()")
> 
> > Closes: https://syzkaller.appspot.com/bug?extid=62dfea789a2cedac1298
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >  fs/namespace.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index 1314f11ed961..8e2ff3dbab58 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -2421,6 +2421,9 @@ struct vfsmount *clone_private_mount(const struct path *path)
> >                 if (!check_mnt(old_mnt))
> >                         return ERR_PTR(-EINVAL);
> >         } else {
> > +               if (!is_mounted(&old_mnt->mnt))
> > +                       return ERR_PTR(-EINVAL);
> > +
> >                 /* Make sure this isn't something purely kernel internal. */
> >                 if (!is_anon_ns(old_mnt->mnt_ns))
> >                         return ERR_PTR(-EINVAL);
> 
> Do we still need the second check if we have the first one?

Yes, is_mounted() checks whether this is NULL or ERR_PTR(-EINVAL) and
is_anon_ns() checks for null mntns->seq.

I'll fold this fix referencing it in the commit message.
