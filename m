From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 2/2] nfsd: store stat times in fill_pre_wcc() instead
 of inode times
Date: Wed, 03 Jan 2018 13:45:44 -0500
Message-ID: <1515005144.3458.42.camel@kernel.org>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
         <1514992475-8142-3-git-send-email-amir73il@gmail.com>
         <1514994062.3458.14.camel@kernel.org>
         <CAOQ4uxgHwkT=2SGz=XQqP626rfpWCAXtmvBwZuU1N8s1Bh6a4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgHwkT=2SGz=XQqP626rfpWCAXtmvBwZuU1N8s1Bh6a4A@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, 2018-01-03 at 17:48 +0200, Amir Goldstein wrote:
> On Wed, Jan 3, 2018 at 5:41 PM, Jeff Layton <jlayton@kernel.org> wrote:
> > On Wed, 2018-01-03 at 17:14 +0200, Amir Goldstein wrote:
> > > The time values in stat and inode may differ for overlayfs and stat time
> > > values are the correct ones to use. This is also consistent with the fact
> > > that fill_post_wcc() also stores stat time values.
> > > 
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/nfsd/nfs3xdr.c | 31 ++++++++++++++++++++++++++++++-
> > >  fs/nfsd/nfs4xdr.c |  2 +-
> > >  fs/nfsd/nfsfh.h   | 28 ++++++----------------------
> > >  3 files changed, 37 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> > > index 2758480555fa..1a70581e1cb2 100644
> > > --- a/fs/nfsd/nfs3xdr.c
> > > +++ b/fs/nfsd/nfs3xdr.c
> > > @@ -251,6 +251,34 @@ encode_wcc_data(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
> > >  }
> > > 
> > >  /*
> > > + * Fill in the pre_op attr for the wcc data
> > > + */
> > > +void fill_pre_wcc(struct svc_fh *fhp)
> > > +{
> > > +     struct inode    *inode;
> > > +     struct kstat    stat;
> > > +     __be32 err;
> > > +
> > > +     if (fhp->fh_pre_saved)
> > > +             return;
> > > +
> > > +     inode = d_inode(fhp->fh_dentry);
> > > +     err = fh_getattr(fhp, &stat);
> > > +     if (err) {
> > > +             /* Grab the times from inode anyway */
> > > +             stat.mtime = inode->i_mtime;
> > > +             stat.ctime = inode->i_ctime;
> > > +             stat.size  = inode->i_size;
> > > +     }
> > > +
> > 
> > Might be best to instead just not supply pre/post op attrs if the
> > getattr fails? They are technically optional with v3 -- we can just set
> > the attributes_follow bit to false there.
> 
> I considered to set fh_pre_saved = false on error just like
> fill_post_wcc() does, but wasn't sure of the consequences or how to test
> for that matter, so I chose a more delicate fallback instead.
> 

Take care with the BUG_ON in set_change_info if you do that. 

Note that all of this is really just to handle weak cache consistency in
v3, and the change_info4 value in v4. When the info is not reliable, the
client doesn't trust its cache, for the most part. Getting it wrong
shouldn't be fatal in most cases.

For v3 you can just clear the attributes_follow bit when you fill out
the info, and leave it zeroed out. I had a patch a few years ago that
did this on a per-export basis that you're welcome to take an run with:

    https://patchwork.kernel.org/patch/7159311/

Obviously, the conditions for doing this here are different.

For v4, I think we can just try to scrape what we have like you're doing
here, and simply ensure that the "atomic" field being encoded in
encode_cinfo is false when this occurs.

> > 
> > For v4, it's a little more complicated. Scraping it out of the inode
> > might be necessary for the cases where we need a change_info4.
> > 
> > Either way, it'd be good to know that these getattrs are failing if this
> > occurs. Maybe a KERN_WARNING printk or something might be good there?
> > 
> 
> As you wish, but fill_post_wcc() does not emit a warning, so...
> 
> I'll wait for feedback from Bruce as well.
> Let me know the error handing of your choice.
> 

Yeah, it doesn't. I think that's good info to know though.

All of this is to support client-server cache coherency, and bugs in
those areas can be subtle and hard to detect. A stack trace is probably
not terribly helpful, but doing a one-time printk to show that you got
an error there may be.
-- 
Jeff Layton <jlayton@kernel.org>
