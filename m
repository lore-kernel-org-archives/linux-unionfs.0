Return-Path: <metan@suse.de>
Date: Fri, 24 May 2019 10:59:47 +0200
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH] [COMMITTED] syscalls/fcntl33: Fix typo overlapfs
 -> overlayfs
Message-ID: <20190524085947.GA11508@rei.lan>
References: <20190523134549.23103-1-chrubis@suse.cz>
 <CAOQ4uxhHVG9f1njmPgei8-QO4UEivXbxoHkqKi4f50XN6Gup9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhHVG9f1njmPgei8-QO4UEivXbxoHkqKi4f50XN6Gup9A@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Petr Vorel <pvorel@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
> >  testcases/kernel/syscalls/fcntl/fcntl33.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/testcases/kernel/syscalls/fcntl/fcntl33.c b/testcases/kernel/syscalls/fcntl/fcntl33.c
> > index 43dc5a2af..627823c5c 100644
> > --- a/testcases/kernel/syscalls/fcntl/fcntl33.c
> > +++ b/testcases/kernel/syscalls/fcntl/fcntl33.c
> > @@ -117,7 +117,7 @@ static void do_test(unsigned int i)
> >         if (TST_RET == -1) {
> >                 if (type == TST_OVERLAYFS_MAGIC && TST_ERR == EAGAIN) {
> >                         tst_res(TINFO | TTERRNO,
> > -                               "fcntl(F_SETLEASE, F_WRLCK) failed on overlapfs as expected");
> > +                               "fcntl(F_SETLEASE, F_WRLCK) failed on overlayfs as expected");
> 
> You have 3 more of this typo in fcntl tests.

Ah, right, I should have done git grep before commiting this. I will fix
that right away.

> If you ask me, silencing this error seems wrong.
> While the error is *expected* it is still a broken interface.
> It may be just a matter of terminology, but I am reading this message as:
> 
> TEST PASSED: Overlayfs failed as expected
> 
> While it really should be more along the lines of:
> 
> TEST SKIPPED: Overlayfs doesn't support write leased

Agreed, I'm always against working around kernel bugs/deficiencies in
tests, unfortunately that usually conflicts with QA deparenments that
wants to skip known problems and have everything green. So we usually
end up somewhere in a middle ground.

Also as usuall, do you care enough to send a patch? :-)

> Besides, this problem looks quite easy to fix.
> I think Bruce was already looking at changing the implementation of
> check_conflicting_open(), so if the test is not failing, nobody is going to
> nudge for a fix...

Once it's fixed we can change that to a failure for new enough kernels,
old ones should probably stay with SKIPPED/TCONF.

-- 
Cyril Hrubis
chrubis@suse.cz
