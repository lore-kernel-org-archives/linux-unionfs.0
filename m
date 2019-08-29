From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH v2 2/2] iomap: partially revert
 4721a601099 (simulated directio short read on EFAULT)
Date: Thu, 29 Aug 2019 13:49:29 +0200
Message-ID: <CAHpGcM+Aq+BxD0_TPx9sqTCt8N6X3Q+UO6CkyfV3NZMaN8AU8w@mail.gmail.com>
References: <20181202180832.GR8125@magnolia> <20181202181045.GS8125@magnolia>
	<CAHpGcM+WQYFHOOC8SzKq+=DuHVZ4fw4RHLTMUDN-o6GX3YtGvQ@mail.gmail.com>
	<20190828142332.GT1037422@magnolia>
	<CAHpGcMLGWVssWAC1PqBJevr1+1rE_hj4QN27D26j7-Fp_Kzpsg@mail.gmail.com>
	<20190829031216.GW1037422@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20190829031216.GW1037422@magnolia>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: jencce.kernel@gmail.com, Zorro Lang <zlang@redhat.com>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, cluster-devel <cluster-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

Hi Darrick,

Am Do., 29. Aug. 2019 um 05:12 Uhr schrieb Darrick J. Wong
<darrick.wong@oracle.com>:
> Hm, so I made an xfstest out of the program you sent me, and indeed
> reverting that chunk makes the failure go away, but that got me
> wondering -- that iomap kludge was a workaround for the splice code
> telling iomap to try to stuff XXXX bytes into a pipe that only has X
> bytes of free buffer space.  We fixed splice_direct_to_actor to clamp
> the length parameter to the available pipe space, but we never did the
> same to do_splice:
>
>         /* Don't try to read more the pipe has space for. */
>         read_len = min_t(size_t, len,
>                          (pipe->buffers - pipe->nrbufs) << PAGE_SHIFT);
>         ret = do_splice_to(in, &pos, pipe, read_len, flags);
>
> Applying similar logic to the two (opipe != NULL) cases of do_splice()
> seem to make the EAGAIN problem go away too.  So why don't we teach
> do_splice to only ask for as many bytes as the pipe has space here too?
>
> Does the following patch fix it for you?

Yes, that works, thank you.

> From: Darrick J. Wong <darrick.wong@oracle.com>
> Subject: [PATCH] splice: only read in as much information as there is pipe buffer space
>
> Andreas Gruenbacher reports that on the two filesystems that support
> iomap directio, it's possible for splice() to return -EAGAIN (instead of
> a short splice) if the pipe being written to has less space available in
> its pipe buffers than the length supplied by the calling process.
>
> Months ago we fixed splice_direct_to_actor to clamp the length of the
> read request to the size of the splice pipe.  Do the same to do_splice.

Can you add a reference to that commit here (17614445576b6)?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/splice.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 98412721f056..50335515d7c1 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1101,6 +1101,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>         struct pipe_inode_info *ipipe;
>         struct pipe_inode_info *opipe;
>         loff_t offset;
> +       unsigned int pipe_pages;
>         long ret;
>
>         ipipe = get_pipe_info(in);
> @@ -1123,6 +1124,10 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>                 if ((in->f_flags | out->f_flags) & O_NONBLOCK)
>                         flags |= SPLICE_F_NONBLOCK;
>
> +               /* Don't try to read more the pipe has space for. */
> +               pipe_pages = opipe->buffers - opipe->nrbufs;
> +               len = min_t(size_t, len, pipe_pages << PAGE_SHIFT);

This should probably be min(len, (size_t)pipe_pages << PAGE_SHIFT).
Same for the second min_t here and the one added by commit
17614445576b6.

> +
>                 return splice_pipe_to_pipe(ipipe, opipe, len, flags);
>         }
>
> @@ -1180,8 +1185,13 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>
>                 pipe_lock(opipe);
>                 ret = wait_for_space(opipe, flags);
> -               if (!ret)
> +               if (!ret) {
> +                       /* Don't try to read more the pipe has space for. */
> +                       pipe_pages = opipe->buffers - opipe->nrbufs;
> +                       len = min_t(size_t, len, pipe_pages << PAGE_SHIFT);
> +
>                         ret = do_splice_to(in, &offset, opipe, len, flags);
> +               }
>                 pipe_unlock(opipe);
>                 if (ret > 0)
>                         wakeup_pipe_readers(opipe);

Thanks,
Andreas
