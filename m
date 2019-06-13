MIME-Version: 1.0
Date: Thu, 13 Jun 2019 16:13:15 +0200
References: <20190612172408.22671-1-amir73il@gmail.com>
	<20190612183156.GA27576@fieldses.org>
In-Reply-To: <20190612183156.GA27576@fieldses.org>
Message-ID: <CAJfpegvj0NHQrPcHFd=b47M-uz2CY6Hnamk_dJvcrUtwW65xBw@mail.gmail.com>
Subject: Re: [PATCH v2] locks: eliminate false positive conflicts for write lease
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, Linux NFS list <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jun 12, 2019 at 8:31 PM J . Bruce Fields <bfields@fieldses.org> wrote:
>
> How do opens for execute work?  I guess they create a struct file with
> FMODE_EXEC and FMODE_RDONLY set and they decrement i_writecount.  Do
> they also increment i_readcount?  Reading do_open_execat and alloc_file,
> looks like it does, so, good, they should conflict with write leases,
> which sounds right.

Right, but then why this:

> > +     /* Eliminate deny writes from actual writers count */
> > +     if (wcount < 0)
> > +             wcount = 0;

It's basically a no-op, as you say.  And it doesn't make any sense
logically, since denying writes *should* deny write leases as well...

Thanks,
Miklos
