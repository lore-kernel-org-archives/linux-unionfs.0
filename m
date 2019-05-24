Return-Path: <metan@suse.de>
Date: Fri, 24 May 2019 15:45:22 +0200
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH] [COMMITTED] syscalls/fcntl33: Fix typo overlapfs
 -> overlayfs
Message-ID: <20190524134521.GA2251@rei>
References: <20190523134549.23103-1-chrubis@suse.cz>
 <CAOQ4uxhHVG9f1njmPgei8-QO4UEivXbxoHkqKi4f50XN6Gup9A@mail.gmail.com>
 <20190524085947.GA11508@rei.lan>
 <CAOQ4uxj3X2Eh+RmzunW1Sb8PWrHWsS1_h-xEH2Bofcr+-S-tiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj3X2Eh+RmzunW1Sb8PWrHWsS1_h-xEH2Bofcr+-S-tiA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Petr Vorel <pvorel@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
> > Agreed, I'm always against working around kernel bugs/deficiencies in
> > tests, unfortunately that usually conflicts with QA deparenments that
> > wants to skip known problems and have everything green. So we usually
> > end up somewhere in a middle ground.
> 
> But is everything green though?
> Does QA department know that if you run samba inside a container
> whose storage driver is overlayfs, if samba is configured with
> "kernel oplock = yes"
> Samba clients would never be able to acquire an oplock and
> write performance would be horrible?
> 
> Sure, not everyone cares about this case, but seems to be that
> silencing the error should be in the hands of the user and that LTP
> project should just report the problems as they are.
> 
> Worse is the fact that this error will only trigger for people that
> configured LTP to test overlayfs specifically, not all LTP users.
> This group of users is even more likely to be interested in
> bugs/deficiencies of overlayfs.

I can see how this is wrong.

On the other hand it took us some time to explain our release managers
that kernel is OK when we say that it's OK and that the actuall test
results are not the end result. But even then we never attempted to
to put workarounds into the upstream tests. So I guess that we can
remove the workaround when there is a fix in upstream.

> > Also as usuall, do you care enough to send a patch? :-)
> 
> No, not yet.
> Give me a few days to cook.
> When I get to caring enough I will fix the kernel ;-)

Ok.

> > > Besides, this problem looks quite easy to fix.
> > > I think Bruce was already looking at changing the implementation of
> > > check_conflicting_open(), so if the test is not failing, nobody is going to
> > > nudge for a fix...
> >
> > Once it's fixed we can change that to a failure for new enough kernels,
> > old ones should probably stay with SKIPPED/TCONF.
> >
> 
> This too would be wrong practice IMO.
> If stable kernel users see that the test passes on mainline and fails
> on old kernel, somebody may get the idea to backport the fix to stable kernel
> and fix the bug.
> IOW, setting min_kver is a tool that should be reserved IMO to situations
> where:
> 1. The interface/functionality does not exist -OR-
> 2. The maintainers have made it clear that the fix will not be backported

It's even worse with the distribution kernels that have arbitrary
version numbers and thousands of patches on the top of it, so we use it
as a last option...

-- 
Cyril Hrubis
chrubis@suse.cz
