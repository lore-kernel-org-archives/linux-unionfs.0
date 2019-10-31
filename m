MIME-Version: 1.0
Date: Thu, 31 Oct 2019 14:44:44 +0100
References: <20191030124431.11242-1-cgxu519@mykernel.net>
	<CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
	<16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
	<CAOQ4uxhdSXAvFQfhzZpBC=Xmmo9y+3AOU1o-tOWsLtr2ntU6Ag@mail.gmail.com>
	<20191031132017.GA7308@redhat.com>
In-Reply-To: <20191031132017.GA7308@redhat.com>
Message-ID: <CAJfpegtsnmBjK5XVUNOU5CU8Ux71y8uN1d4hHYmjVMmYPLJD4g@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse file
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Chengguang Xu <cgxu519@mykernel.net>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 31, 2019 at 2:20 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Oct 31, 2019 at 08:53:15AM +0200, Amir Goldstein wrote:

> >
> > @@ -483,7 +483,7 @@ static int ovl_copy_up_inode(struct
> > ovl_copy_up_ctx *c, struct dentry *temp)
> >         }
> >
> >         inode_lock(temp->d_inode);
> > -       if (c->metacopy)
> > +       if (S_ISREG(c->stat.mode))
> >                 err = ovl_set_size(temp, &c->stat);
>
> Hi Amir,
>
> Why do we need this change. c->metacopy is set only for regular files.
>
> ovl_need_meta_copy_up() {
>         if (!S_ISREG(mode))
>                 return false;
> }
>
> Even if there is a reason, this change should be part of a separate patch.
> What connection does it have to skip holes while copying up.

That's a fix only if the copied-up file ends in a hole, which was not
the case before this patch.   But harmless, and makes sense generally
(i.e. file is truncated to final size *before* data is copied up).

Thanks,
Miklos
