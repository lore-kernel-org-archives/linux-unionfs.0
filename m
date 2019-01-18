Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190118134519.3411-1-amir73il@gmail.com> <20190118144323.GA6420@redhat.com>
 <CAOQ4uxihLM_ztQ487SMiWr6w6646J0VfBpbNHyeybxX77COKsQ@mail.gmail.com> <20190118195202.GB2832@redhat.com>
In-Reply-To: <20190118195202.GB2832@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 18 Jan 2019 22:12:42 +0200
Message-ID: <CAOQ4uxhQbBgxfZTON6=ZpSR6_J30y1X5XY7gBCjBGFZ8xYLxcg@mail.gmail.com>
Subject: Re: [RFC][PATCH] ovl: lazy copy up of data on first write
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

> > >
> > > Should this behavior be an opt in with another mount option (and not
> > > be enabled automatically with metacopy=on).
> > >
> >
> > I can't think of one good reason for user to opt-in for copy up data on open.
> > Or on a use case where latency on open is desired over latency on write.
> > Can you?
>
> IIUC, now if I open a file O_RDWR and only issue reads to file and never
> issue writes, then for every read, I will open a lower file, finish read
> and close fd. This is slower path. What's the performance penalty? If

That is correct, but as you rightfully noted, that is probably a corner case
and not the common behavior.
It is not something that we cannot fix if we find that it is important.
We can choose to cache the lower file and we can also choose to cache
both upper and lower real files.

> this is significant, then it might make sense to opt-in for lazy copy
> up behavior (instead of relying that application will open file O_RDONLY
> if they never issue writes to it).
>

Maybe. My instinct is that this case where complication the user with
more configurations is not worth it and we can find a good enough
solution for all cases.

Let's see what Miklos has to say.

Thanks,
Amir.
