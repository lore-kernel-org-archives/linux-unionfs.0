Return-Path: <jlayton@kernel.org>
Message-ID: <e1d60ba87b311da9fbca9cfd291b48f4798f9462.camel@kernel.org>
Subject: Re: [PATCH v2] locks: eliminate false positive conflicts for write
 lease
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 13 Jun 2019 11:50:13 -0400
In-Reply-To: <CAOQ4uxhXjuqMDbUq_4=oL8QETuUF3bs0V5qE9bNDJDind6F2pQ@mail.gmail.com>
References: <20190612172408.22671-1-amir73il@gmail.com>
	 <20190612183156.GA27576@fieldses.org>
	 <CAJfpegvj0NHQrPcHFd=b47M-uz2CY6Hnamk_dJvcrUtwW65xBw@mail.gmail.com>
	 <20190613143151.GC2145@fieldses.org>
	 <CAOQ4uxhXjuqMDbUq_4=oL8QETuUF3bs0V5qE9bNDJDind6F2pQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS list <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, 2019-06-13 at 18:47 +0300, Amir Goldstein wrote:
> On Thu, Jun 13, 2019 at 5:32 PM J . Bruce Fields <bfields@fieldses.org> wrote:
> > On Thu, Jun 13, 2019 at 04:13:15PM +0200, Miklos Szeredi wrote:
> > > On Wed, Jun 12, 2019 at 8:31 PM J . Bruce Fields <bfields@fieldses.org> wrote:
> > > > How do opens for execute work?  I guess they create a struct file with
> > > > FMODE_EXEC and FMODE_RDONLY set and they decrement i_writecount.  Do
> > > > they also increment i_readcount?  Reading do_open_execat and alloc_file,
> > > > looks like it does, so, good, they should conflict with write leases,
> > > > which sounds right.
> > > 
> > > Right, but then why this:
> > > 
> > > > > +     /* Eliminate deny writes from actual writers count */
> > > > > +     if (wcount < 0)
> > > > > +             wcount = 0;
> > > 
> > > It's basically a no-op, as you say.  And it doesn't make any sense
> > > logically, since denying writes *should* deny write leases as well...
> > 
> > Yes.  I feel like the negative writecount case is a little nonobvious,
> > so maybe replace that by a comment, something like this?:
> > 
> > --b.
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 2056595751e8..379829b913c1 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -1772,11 +1772,12 @@ check_conflicting_open(struct file *filp, const long arg, int flags)
> >         if (arg == F_RDLCK && wcount > 0)
> >                 return -EAGAIN;
> > 
> > -       /* Eliminate deny writes from actual writers count */
> > -       if (wcount < 0)
> > -               wcount = 0;
> > -
> > -       /* Make sure that only read/write count is from lease requestor */
> > +       /*
> > +        * Make sure that only read/write count is from lease requestor.
> > +        * Note that this will result in denying write leases when wcount
> > +        * is negative, which is what we want.  (We shouldn't grant
> > +        * write leases on files open for execution.)
> > +        */
> >         if (filp->f_mode & FMODE_WRITE)
> >                 self_wcount = 1;
> >         else if (filp->f_mode & FMODE_READ)
> 
> I'm fine with targeting 5.3 and I'm fine with all suggested changes
> and adding some of my own. At this point we no longer need wcount
> variable and code becomes more readable without it.
> See attached patch (also tested).
> 
> Thanks,
> Amir.

Thanks Amir. In that case, I'll go ahead and pick this up for v5.3, and
will get it into linux-next soon.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
