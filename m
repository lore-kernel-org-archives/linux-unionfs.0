Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190328153829.729-1-amir73il@gmail.com> <CAJfpegt08nTeDs4+3svOjGAF+mQEP+Dm-amLz9nDWOACqtAUMQ@mail.gmail.com>
In-Reply-To: <CAJfpegt08nTeDs4+3svOjGAF+mQEP+Dm-amLz9nDWOACqtAUMQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 May 2019 14:03:18 +0300
Message-ID: <CAOQ4uxgfuENW7gqsr_Q=Ne8u=PR-oyJ5N6Te9C+L2-14UDK4Cg@mail.gmail.com>
Subject: Re: [PATCH] ovl: relax WARN_ON() for overlapping layers use case
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Mar 30, 2019 at 10:45 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Mar 28, 2019 at 4:38 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > This nasty little syzbot repro:
> > https://syzkaller.appspot.com/x/repro.syz?x=12c7a94f400000
> >
> > Creates overlay mounts where the same directory is both in upper
> > and lower layers. Simplified example:
> >
> >   mkdir foo work
> >   mount -t overlay none foo -o"lowerdir=.,upperdir=foo,workdir=work"
>
> Shouldn't the mount fail in this case?
>
> Does it make any sense to allow overlapping layers?
>
> If doing the check the dumb way, the number of d_ancestor() calls
> would increase quadratically with the number of layers, but I think
> it's possible to do it in linear time if necessary.
>

Miklos,

I saw you did not pick this one for next.
IMO, regardless of preventing mount with overlapping layers,
the WARN_ON() is inappropriate and this patch that replaces it with
pr_warn_reatelimited() has merit on its own.

WARN_ON() should reflect a case that we don't think is possible
in current code and as API constrain assertion.
Neither is the case here.
We know that it *is* possible to hit this case, even with checking overlapping
layers on mount and user does get an error when we hit the case.

Thanks,
Amir.
