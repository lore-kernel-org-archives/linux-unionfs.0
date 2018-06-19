Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
References: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
 <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Tue, 19 Jun 2018 22:22:08 +0800
Message-ID: <CALLuPvpEzczsFCD_u6+XOxUHY8EWaczYhH-sd=amJGgXsrnd4w@mail.gmail.com>
Subject: Re: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <linux-unionfs@vger.kernel.org>

> What is the underlying filesystem?
> Do you if your system also tries to set security.capability xattr
> or just tries to read them?

The underlying filesystem is ext4. I'll find out about security.capability xattr
is set or not (guess I have to add log in vfs).

>
> I would check the change (from v4.14):
> 8db6c34f1dbc Introduce v3 namespaced file capabilities
>
> I suggest that you continue down the rabbit hole to see
> which check returns -EINVAL, whether inside ovl_xattr_get()
> or deeper inside nested vfs_getxattr().
>
> Other than that, you can try this overlayfs backport branch:
> https://github.com/amir73il/linux/commits/overlayfs-4.9.y-17
> It contains backported overlayfs patches up to v4.17 based
> off of v4.9.102.
>
> If problem is not reproduced on the backported branch then
> chances are the problem has to do with interaction between
> overlayfs and a change to another subsystem (e.g. v3
> namespaced file capabilities).
>
> Thanks,
> Amir.

Thanks those suggestions, I'll test them and go back to you then.

Thanks,
Eddie
