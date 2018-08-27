MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjE-XtGC=D-C+329snTs7u7bGgcrns2N-rR34ZXAdm=0g@mail.gmail.com>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
	<1535374564-8257-7-git-send-email-amir73il@gmail.com>
	<20180827185250.GB29056@redhat.com>
	<CAOQ4uxjE-XtGC=D-C+329snTs7u7bGgcrns2N-rR34ZXAdm=0g@mail.gmail.com>
Date: Mon, 27 Aug 2018 21:29:19 +0200
Message-ID: <CAJfpegs8RLVLk-VMEAD3tVm5ezMdDZUMZAQP965EuQKnz7-fGg@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] ovl: add ovl_fadvise()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 9:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Aug 27, 2018 at 9:52 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> On Mon, Aug 27, 2018 at 03:56:04PM +0300, Amir Goldstein wrote:
>> > Implement stacked fadvise to fix syscalls readahead(2) and fadvise64(2)
>> > on an overlayfs file.
>> >
>> > Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
>> > Fixes: d1d04ef8572b ("ovl: stack file ops")
>> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> > ---
>> >  fs/overlayfs/file.c | 18 ++++++++++++++++++
>> >  1 file changed, 18 insertions(+)
>> >
>> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> > index a4acd84591d4..42d2d034d85c 100644
>> > --- a/fs/overlayfs/file.c
>> > +++ b/fs/overlayfs/file.c
>> > @@ -331,6 +331,23 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
>> >       return ret;
>> >  }
>> >
>> > +int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>> > +{
>> > +     struct fd real;
>> > +     int ret;
>> > +
>> > +     ret = ovl_real_fdget(file, &real);
>> > +     if (ret)
>> > +             return ret;
>> > +
>> > +     /* XXX: do we need mounter credentials? */
>>
>> Given we are switching creds to mounter for rest of the file operations,
>> so I would think we need to do it here as well to be consistent with
>> this security model.
>>
>
> Yeh, I guess so, although I did not see any security checks in
> fadvise64(2) syscall. readahead(2) at least checks for FMODE_READ
> on the open file fadvise doesn't even bother with that...
>
> Miklos, let me know if you want me to add override_creds or will
> you add it yourself.

I'll add it.

Thanks,
Miklos
