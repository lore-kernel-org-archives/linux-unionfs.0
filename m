MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhcL=j2aOXKC3E3HPgF7=DViU-JgpzLh-Q7cQ8V+Jq+aQ@mail.gmail.com>
References: <20181011112401.5790-1-amir73il@gmail.com>
	<CAJfpegtaedajQg=A-sdthhu3yzfFHrj8dh8GHMw2mA+W9Cu9wQ@mail.gmail.com>
	<CAOQ4uxhcL=j2aOXKC3E3HPgF7=DViU-JgpzLh-Q7cQ8V+Jq+aQ@mail.gmail.com>
Date: Thu, 11 Oct 2018 15:16:53 +0200
Message-ID: <CAJfpegter3jRedVqnufvXvNAEQuT-iZFD_1N7KiKxbjx76mzwA@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix FIGETBSZ ioctl on an overlayfs file
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eryu Guan <guaneryu@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 2:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Oct 11, 2018 at 3:25 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> On Thu, Oct 11, 2018 at 1:24 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > Implement the FIGETBSZ query with the statfs(2) filesystem
>> > interface. Reading inode->i_sb->s_blocksize directly is incorrect
>> > on stacked filesystems (i.e. overlayfs).
>> >
>> > This fixes a Floating point exception in e2fsprogs utility filefrag,
>> > which divides the size of the file with the value returned by FIGETBSZ.
>> >
>> > Fixes: d1d04ef8572b ("ovl: stack file ops")
>> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> > ---
>> >
>> > Miklos,
>> >
>> > Consider this for-rc8?
>> > There is another trivial kfree(ERR_PTR()) fix I posted yesterday.
>> >
>> > xfstests actually has coverage for FIGETBSZ with fiemap-tester
>> > program. However, the tests that use fiemap-tester (generic/094
>> > generic/225) did not fail on v4.19-rc1, but rather thier runtime
>> > dropped from > 10s to 0s, so I'll need to go fix those tests.
>> >
>> > Thanks,
>> > Amir.
>> >
>> >  fs/ioctl.c | 15 ++++++++++++++-
>> >  1 file changed, 14 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/fs/ioctl.c b/fs/ioctl.c
>> > index 2005529af560..a0e55a8e94fd 100644
>> > --- a/fs/ioctl.c
>> > +++ b/fs/ioctl.c
>> > @@ -17,6 +17,7 @@
>> >  #include <linux/buffer_head.h>
>> >  #include <linux/falloc.h>
>> >  #include <linux/sched/signal.h>
>> > +#include <linux/statfs.h>
>> >
>> >  #include "internal.h"
>> >
>> > @@ -219,6 +220,18 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
>> >         return error;
>> >  }
>> >
>> > +static int ioctl_getbsize(struct file *file, int __user *argp)
>> > +{
>> > +       struct kstatfs buf;
>> > +       int err;
>> > +
>> > +       err = vfs_statfs(&file->f_path, &buf);
>> > +       if (err)
>> > +               return err;
>> > +
>> > +       return put_user(buf.f_bsize, argp);
>>
>> We must be careful not to change the interface for non-overlayfs while
>> trying to fix overlayfs, and I don't see any guarantees, that for
>> every other fs f_bsize would be the same as s_blocksize.   There are
>> other, minor side effects, like possibly blocking and/or generating
>> network traffic, unlike the previous version.
>>
>> But first let's understand what this interface is for.  Haven't found
>> any other documentation than this:
>>
>> #define FIGETBSZ   _IO(0x00,2)    /* get the block size used for bmap */
>>
>> So it's for the deprecated bmap interface, and we no longer support
>> that.  Hooray!  Then just let's just put some dummy value into
>> overlayfs's s_blocksize and s_blocksize_bits (e.g.
>> PAGE_SIZE/PAGE_SHIFT) and be done with that.
>>
>
> OK. That's fine by me, but notice that filefrag will use the value
> it gets from FIGETBSZ even in the FIEMAP implementation,
> which is the default implementation.
>
> I think we can set s_blocksize to upper s_blocksize and cover some
> common cases. If s_blocksize doesn't match lower s_blocksize we
> can warn and set s_blocksize back to 0.
>
> Then, we can return -EINVAL from FIGETBSZ in case s_blocksize
> is not set, which is the equivalent of what we do with FIBMAP.
>
> It that too much?

Does any other filesystem leave s_blocksize unset?   Apparently ceph
does, for example, so that's not without precedent.

Just returning -EINVAL from FIGETBSZ if s_blocksize is zero would fix
filefrag, since it would gracefully fall back to f_bsize.

Thanks,
Miklos
