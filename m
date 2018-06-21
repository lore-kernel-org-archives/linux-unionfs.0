Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgt41iTTfEgDtYSG=iGLSK9LPR1znBKg_LQYVDwzAG21g@mail.gmail.com>
References: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
 <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
 <CALLuPvpEzczsFCD_u6+XOxUHY8EWaczYhH-sd=amJGgXsrnd4w@mail.gmail.com>
 <CALLuPvqk3SDWA-GDTworPdgfV=jqeWMUviR5AhYxk+Tc-bUjnw@mail.gmail.com> <CAOQ4uxgt41iTTfEgDtYSG=iGLSK9LPR1znBKg_LQYVDwzAG21g@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Thu, 21 Jun 2018 10:34:23 +0800
Message-ID: <CALLuPvqGdzMWry8m1ewjtecV47uMSCNTPykn954zL42yFDcgRQ@mail.gmail.com>
Subject: Re: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <linux-unionfs@vger.kernel.org>

> Interesting... I don't fully understand how we get to a state where
> d_find_alias() fails to find a real hashed dentry, but here are a few
> observations:
>
> - I was right about the patch that introduced the regression
>   (v3 namespaced file capabilities)
> - I think code in cap_inode_getsecurity() should use d_find_any_alias()
>   instead of d_find_alias().  For example, if execveat() in called with an
>   open but unlinked file d_find_alias() won't find the dentry
> - execveat() of unlinked file is probably NOT the case here, because
>   d_find_alias() fails to find real dentry, but does find the overlay dentry
> - AFAICT, there is no requirement for dentry passed to vfs_getxattr_alloc()
>   to be hashed. Note that in your case the underlying real handler->get()
>   ext4_xattr_security_get() completely ignored the dentry argument
>
> Please try if to replace d_find_alias/d_find_any_alias and see if that
> fixes the problem.

You're correct! I tried d_find_any_alias after d_find_alias fails in
cap_inode_getsecurity(),
it does fix this problem.

>
> If you can, please create a small reproducer that opens an executable,
> unlink the executable and execute it with execveat().
> I estimate this should fail with file capabilities enabled over any file
> system, not just overlayfs.

Later, I will try if I can create the reproducer to reproduce the case,
and also try my original case with 4.17-ext4, supposed the error
should happen as well.

Thanks,
Eddie
