MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgvNoJESGkDmRxGyjvRY7xZzHBwx0txvVOb1dd6Xyv3GA@mail.gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
	<1535300717-26686-4-git-send-email-amir73il@gmail.com>
	<20180827034309.GX31495@dastard>
	<CAOQ4uxgvNoJESGkDmRxGyjvRY7xZzHBwx0txvVOb1dd6Xyv3GA@mail.gmail.com>
Date: Mon, 27 Aug 2018 11:49:04 +0200
Message-ID: <CAJfpegsspjbt2+oHVGgLH401hmJiq=HOx=X++rnBurnU52849w@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ovl: fix GPF in swapfile_activate of file from
 overlayfs over xfs
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 8:34 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> So the trick of this patch is to change the game from whack-an-oops
> to whack-an-einval, which is better for everyone.

In other words: this overlayfs update might cause regressions in dark
and musty corners of overlayfs usage, but those will not be Oops
inducing regressions.  And whenever someone reports a regression, that
will be solved by making that corner of the kernel less musty and dark
(i.e. properly stackable), so in the end this is a win-win game.

There's one corner case remaining, which is shared mmap consistency
across copy-up.  I think the solution to this will be:

 - private mappings of lower files will directly go to the lower
file's mapping (just like now)
 - anything else (shared mmap of lower files and all mmap of upper
files) will go to the overlay mapping (just like a normal fs)

The flip side is cache duplication between shared mmap and private
mmap of the same lower file.  I hope this would be pretty rare.

I don't see big complexities with the above, it should be solvable
purely in overlayfs.

Then there's getting rid of d_real() for good, for which Al has some
ideas, and we are done.  So yes, I think the end of the tunnel is
pretty well in sight.

Thanks,
Miklos
