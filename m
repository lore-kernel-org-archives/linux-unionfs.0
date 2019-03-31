Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190328153829.729-1-amir73il@gmail.com> <CAJfpegt08nTeDs4+3svOjGAF+mQEP+Dm-amLz9nDWOACqtAUMQ@mail.gmail.com>
In-Reply-To: <CAJfpegt08nTeDs4+3svOjGAF+mQEP+Dm-amLz9nDWOACqtAUMQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 31 Mar 2019 08:41:22 +0300
Message-ID: <CAOQ4uxhdFA1twP4AJ9yN_aD07AnOFYKwNqPSjiLHHMv9a==MWA@mail.gmail.com>
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

Sure, but that is independent of this patch, because renaming
between lower layers after mount can get you to the same
situation and that is harder to prevent.

> Does it make any sense to allow overlapping layers?
>
> If doing the check the dumb way, the number of d_ancestor() calls
> would increase quadratically with the number of layers, but I think
> it's possible to do it in linear time if necessary.

As I wrote to Vivek, we can do that, but it's only going to
benefit users that make an innocent mistake (what's the odds of that?).
An adversary could easily work around the mount check by moving
lower dirs after mount.

As I wrote in LSF proposal, it would be quite simple to mark
the dentry of layer's root with a flag (i.e. RENAME_FENCE) that would
prevent taking rename_lock when such dentry is in the ancestry of
either src or target.

The challenge is how to make that API generic enough and which
privileges are to be required for setting up such a fence, because
it could be easily used to create DoS in the wrong hands.
Also, if anyone has ever considered making overlayfs mountable
by usrens root, that is going to be another thing to worry about.

Thanks,
Amir.
