Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20180929055133.28955-1-amir73il@gmail.com> <CAOQ4uxiNNRBT+EfRu05n2egFt4v_MpnfEkKo1LSHWnxs4BxpaA@mail.gmail.com>
In-Reply-To: <CAOQ4uxiNNRBT+EfRu05n2egFt4v_MpnfEkKo1LSHWnxs4BxpaA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Feb 2019 16:22:34 +0200
Message-ID: <CAOQ4uxiZJfdRfyKwD1q8RbrT1KTRdLoErpWg0tFnD1fsxg9+Wg@mail.gmail.com>
Subject: Re: [PATCH][RESEND] kernel/acct.c: fix locking order when switching
 acct files
Content-Type: text/plain; charset="UTF-8"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 17, 2018 at 10:39 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Sep 29, 2018 at 8:51 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > This looks like an old bug, pre-dating the "Fixes" commit, but the
> > "Fixes" commit did not handle it properly.
> >
> > The bug recently surfaced as a lockdep possible deadlock warning
> > with commit d1d04ef8572b ("ovl: stack file ops").
> >
> > When acct_on() replaces one acct file with another, it takes sb_writers
> > lock on new file sb and calls acct_pin_kill(old) before releasing the
> > sb_writers lock.
> >
> > If new file is on the same fs as old file, acct_pin_kill(old) fail to
> > file_start_write_trylock() and skip writing the old file, because
> > sb_writers (of new) is already taken by acct_on().
> >
> > If new file is not on same fs as old file, this ordering violation
> > creates an unneeded dependency between new sb_writers and old sb_writers,
> > which may later be reported as possible deadlock.
> >
> > This could result in an actual deadlock if acct file is replaced from
> > an old file in overlayfs over "real fs" to a new file in "real fs".
> > acct_on() takes freeze protection on "real fs" and tries to write to
> > overlayfs file. overlayfs is not freeze protected so do_acct_process()
> > can carry on with __kernel_write() to overlayfs file, which would
> > try to take freeze protection on "real fs" and deadlock.
> >
> > Reproducer of lockdep possible deadlock warning:
> >
> >   ./run --ov -s # unionmount-testsuite
> >   touch /mnt/x /upper/y
> >   accton /mnt/x
> >   accton /upper/y
> >
> >  ======================================================
> >  WARNING: possible circular locking dependency detected
> >  4.19.0-rc1-xfstests #3424 Not tainted
> >  ------------------------------------------------------
> >  accton/1390 is trying to acquire lock:
> >  00000000e0585aa5 (&acct->lock#2){+.+.}, at: acct_pin_kill+0x1b/0x76
> >
> >  but task is already holding lock:
> >  000000003692505a (sb_writers#6){.+.+}, at: mnt_want_write+0x1d/0x42
> >
> > Reported-by: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com
> > Fixes: 59eda0e07f43 ("new fs_pin killing logics")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Al,
> >
> > Welcome back. It would be nice to get an ACK (or an Applied) on this
> > patch. Fixes label claims to fix your commit, but I believe the bug was
> > already there before your commit.
> >
> > As you can see, I have a reproducer to demonstrate the manifestation of
> > the bug in the case of switching acct file from overlayfs to real fs.
> > This started to manifest with overlayfs stacked f_op.
> > I have made another claim which seems obvious from the code about
> > changing acct file on same fs, but did not bother to write a reproducer
> > for that case.
> >
> > Thanks,
> > Amir.
>
> PING

PING^2

>
> >
> >  kernel/acct.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/acct.c b/kernel/acct.c
> > index addf7732fb56..c09355a7ae46 100644
> > --- a/kernel/acct.c
> > +++ b/kernel/acct.c
> > @@ -251,8 +251,8 @@ static int acct_on(struct filename *pathname)
> >         rcu_read_lock();
> >         old = xchg(&ns->bacct, &acct->pin);
> >         mutex_unlock(&acct->lock);
> > -       pin_kill(old);
> >         mnt_drop_write(mnt);
> > +       pin_kill(old);
> >         mntput(mnt);
> >         return 0;
> >  }
> > --
> > 2.17.1
> >
