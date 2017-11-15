From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 12/15] ovl: Fix encryption status of a metacopy only
 file
Date: Wed, 15 Nov 2017 15:53:02 -0500
Message-ID: <20171115205302.GF13895@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
 <20171109205019.11409-13-vgoyal@redhat.com>
 <CAOQ4uxjrfhoCh1gnQM04xkgNNWzxUs2S20NXGFwhfAPg4=D4Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35466 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935013AbdKOUxE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 15 Nov 2017 15:53:04 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjrfhoCh1gnQM04xkgNNWzxUs2S20NXGFwhfAPg4=D4Xw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-ext4@vger.kernel.org

On Fri, Nov 10, 2017 at 11:09:26AM +0200, Amir Goldstein wrote:
> On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > If file is metacopy only, it is possible that lower is encrypted while
> > other is not. In that case, report file as encrypted (despite the fact
> > that only data is encrypted while metadata is not).
> 
> Better consult ext4 guys or find out which user tools care about this
> flag and what they could do in response to this flag.

[ CCing ext4 maling list ]

> 
> When I commented that we need to see what do to about all these
> flags I just gave encrypted flag as an example.
> 
> On a hunch I would say that we need a mask of statx flags that are
> readonly attributes of the data itself and that mask should probably
> contain encrypted and compressed to begin with.

I thought encrypted flag is representing metadata also (and not just 
data). Is that not the case.

> I don't see a reason for 2 separate patches and certainly not for
> 2 separate helpers.

I will merge the two patches. I am not sure about the mask thing though.
We can probably start with encryption and compression flags for now and
make it more generic down the line (using that mask).

> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/inode.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index 7ba19a97a8da..15713d4ac2dd 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -66,6 +66,16 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
> >         return err;
> >  }
> >
> > +static void ovl_stat_set_encryption(struct kstat *ustat, struct kstat *lstat) {
> > +       if (!((lstat->attributes_mask & STATX_ATTR_ENCRYPTED) &&
> > +           (lstat->attributes & STATX_ATTR_ENCRYPTED)))
> > +               return;
> > +
> > +       ustat->attributes |= STATX_ATTR_ENCRYPTED;
> > +       ustat->attributes_mask |= STATX_ATTR_ENCRYPTED;
> > +}
> > +
> 
> 
> This looks buggy. you set STATX_ATTR_ENCRYPTED even if lower
> doesn't have STATX_ATTR_ENCRYPTED in attributes nor in attributes_mask.

Hmm.., I am not able to see where is the bug. Did you notice the "!"
in if condition.

We will set STATX_ATTR_ENCRYPTED in attributes_mask and attributes 
only if lower has STATX_ATTR_ENCRYPTED set both in ->attributes_mask
and ->attributes.

Vivek
