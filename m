Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190523134549.23103-1-chrubis@suse.cz> <CAOQ4uxhHVG9f1njmPgei8-QO4UEivXbxoHkqKi4f50XN6Gup9A@mail.gmail.com>
 <20190524085947.GA11508@rei.lan>
In-Reply-To: <20190524085947.GA11508@rei.lan>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 24 May 2019 14:03:29 +0300
Message-ID: <CAOQ4uxj3X2Eh+RmzunW1Sb8PWrHWsS1_h-xEH2Bofcr+-S-tiA@mail.gmail.com>
Subject: Re: [LTP] [PATCH] [COMMITTED] syscalls/fcntl33: Fix typo overlapfs -> overlayfs
Content-Type: text/plain; charset="UTF-8"
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Petr Vorel <pvorel@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 24, 2019 at 11:59 AM Cyril Hrubis <chrubis@suse.cz> wrote:
>
> Hi!
> > >  testcases/kernel/syscalls/fcntl/fcntl33.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/testcases/kernel/syscalls/fcntl/fcntl33.c b/testcases/kernel/syscalls/fcntl/fcntl33.c
> > > index 43dc5a2af..627823c5c 100644
> > > --- a/testcases/kernel/syscalls/fcntl/fcntl33.c
> > > +++ b/testcases/kernel/syscalls/fcntl/fcntl33.c
> > > @@ -117,7 +117,7 @@ static void do_test(unsigned int i)
> > >         if (TST_RET == -1) {
> > >                 if (type == TST_OVERLAYFS_MAGIC && TST_ERR == EAGAIN) {
> > >                         tst_res(TINFO | TTERRNO,
> > > -                               "fcntl(F_SETLEASE, F_WRLCK) failed on overlapfs as expected");
> > > +                               "fcntl(F_SETLEASE, F_WRLCK) failed on overlayfs as expected");
> >
> > You have 3 more of this typo in fcntl tests.
>
> Ah, right, I should have done git grep before commiting this. I will fix
> that right away.
>
> > If you ask me, silencing this error seems wrong.
> > While the error is *expected* it is still a broken interface.
> > It may be just a matter of terminology, but I am reading this message as:
> >
> > TEST PASSED: Overlayfs failed as expected
> >
> > While it really should be more along the lines of:
> >
> > TEST SKIPPED: Overlayfs doesn't support write leased
>
> Agreed, I'm always against working around kernel bugs/deficiencies in
> tests, unfortunately that usually conflicts with QA deparenments that
> wants to skip known problems and have everything green. So we usually
> end up somewhere in a middle ground.

But is everything green though?
Does QA department know that if you run samba inside a container
whose storage driver is overlayfs, if samba is configured with
"kernel oplock = yes"
Samba clients would never be able to acquire an oplock and
write performance would be horrible?

Sure, not everyone cares about this case, but seems to be that
silencing the error should be in the hands of the user and that LTP
project should just report the problems as they are.

Worse is the fact that this error will only trigger for people that
configured LTP to test overlayfs specifically, not all LTP users.
This group of users is even more likely to be interested in
bugs/deficiencies of overlayfs.

>
> Also as usuall, do you care enough to send a patch? :-)

No, not yet.
Give me a few days to cook.
When I get to caring enough I will fix the kernel ;-)

>
> > Besides, this problem looks quite easy to fix.
> > I think Bruce was already looking at changing the implementation of
> > check_conflicting_open(), so if the test is not failing, nobody is going to
> > nudge for a fix...
>
> Once it's fixed we can change that to a failure for new enough kernels,
> old ones should probably stay with SKIPPED/TCONF.
>

This too would be wrong practice IMO.
If stable kernel users see that the test passes on mainline and fails
on old kernel, somebody may get the idea to backport the fix to stable kernel
and fix the bug.
IOW, setting min_kver is a tool that should be reserved IMO to situations
where:
1. The interface/functionality does not exist -OR-
2. The maintainers have made it clear that the fix will not be backported

Anyway, just my POV.
I full understand the reasons for the "all green" methodology.

Thanks,
Amir.
