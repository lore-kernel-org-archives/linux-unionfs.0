Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181024195837.35532-1-olga.kornievskaia@gmail.com>
 <20181024195837.35532-5-olga.kornievskaia@gmail.com> <CAOQ4uxiB5PLd9QjAp7pQerXOJdtkLbGAENhsGsAQehYWdK91PQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiB5PLd9QjAp7pQerXOJdtkLbGAENhsGsAQehYWdK91PQ@mail.gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Fri, 26 Oct 2018 08:12:15 -0400
Message-ID: <CAN-5tyFHiYufamwJEPf9TFG6eQMVCoTkMz8ini9RyKuAW+RuTQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] OverlayFS: add cross-device check for copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 1:54 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Oct 24, 2018 at 10:59 PM Olga Kornievskaia
> <olga.kornievskaia@gmail.com> wrote:
> >
> > From: Olga Kornievskaia <kolga@netapp.com>
> >
> > VFS copy_file_range was relaxed to allow for cross-device copy.
> > Add a check for now, to disallow cross-device copy offload until
> > appropriate support is added.
> >
> > Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> > `
> > ---
> >  fs/overlayfs/file.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index aeaefd2..5282853 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -483,6 +483,9 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
> >                                    struct file *file_out, loff_t pos_out,
> >                                    size_t len, unsigned int flags)
> >  {
> > +       if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> > +               return -EXDEV;
> >
>
> Note that this could be relaxed later on to same fs type
> allowing for cross container copy_file_range() to be performced
> as clone_file_range() when upper is a shared fs with clone support.
>
> Don't worry about it though, I can make this change later after testing
> the use case.
>
> As long as this patch comes in the series *before* relaxing the VFS check,
> You may add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Given that this patch was merged I didn't add "reviewed-by" line.
Please let me know I need to add this line to the main VFS patch.

>
> Thanks,
> Amir.
