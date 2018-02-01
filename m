From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v11 11/18] ovl: Allocate bigger stack for origin
Date: Wed, 31 Jan 2018 19:38:23 -0500
Message-ID: <20180201003823.GA5415@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
 <20180131211329.16328-12-vgoyal@redhat.com>
 <CAOQ4uxhT_pCOphCUgXjB45dgEu4p9=-ndGj+HaBECDyt8V4VWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754068AbeBAAiY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 19:38:24 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhT_pCOphCUgXjB45dgEu4p9=-ndGj+HaBECDyt8V4VWQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Feb 01, 2018 at 02:07:07AM +0200, Amir Goldstein wrote:
> On Wed, Jan 31, 2018 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Right now there is only one origin for upper dentry and we allocate space
> > to hold only one ovl_path. But with metacopy support, it is possible that
> > lower origin is a metacopy itself and we will continue the search for
> > lower most data entry and install that too in lower stack so that this
> > entry can be used for copy up later.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/namei.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 27a069cd2bf4..ddb73b5a06d4 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -361,7 +361,8 @@ static int ovl_check_origin(struct dentry *upperdentry,
> >
> >         BUG_ON(*ctrp);
> >         if (!*stackp)
> > -               *stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
> > +               *stackp = kmalloc(sizeof(struct ovl_path) * numlower,
> > +                                 GFP_KERNEL);
> 
> I guess you forgot to change that size to 2...

I intentionally kept it at numlower because that's what we are doing for
lower as well. And that keeps it common between two. Anyway, this
allocation is only temporary as we will allocate new memory and copy 
everything there. So I was not worried about temporary allocating numlower
elements instead of hardcoding it to 2.

Vivek

> 
> Amir.
