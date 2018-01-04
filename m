From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v2 2/2] nfsd: store stat times in fill_pre_wcc() instead
 of inode times
Date: Thu, 4 Jan 2018 18:05:13 -0500
Message-ID: <20180104230513.GA19858@fieldses.org>
References: <1514992475-8142-1-git-send-email-amir73il@gmail.com>
 <1514992475-8142-3-git-send-email-amir73il@gmail.com>
 <1514994062.3458.14.camel@kernel.org>
 <CAOQ4uxgHwkT=2SGz=XQqP626rfpWCAXtmvBwZuU1N8s1Bh6a4A@mail.gmail.com>
 <1515005144.3458.42.camel@kernel.org>
 <CAOQ4uxg86oNAYXLN8iCFJTVOV7nxp9a8AwrQPhvr1M-dWqWErA@mail.gmail.com>
 <1515072403.20282.16.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:48258 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbeADXFN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 18:05:13 -0500
Content-Disposition: inline
In-Reply-To: <1515072403.20282.16.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 04, 2018 at 08:26:43AM -0500, Jeff Layton wrote:
> On Wed, 2018-01-03 at 23:03 +0200, Amir Goldstein wrote:
> > On Wed, Jan 3, 2018 at 8:45 PM, Jeff Layton <jlayton@kernel.org> wrote:
> > > On Wed, 2018-01-03 at 17:48 +0200, Amir Goldstein wrote:
> > > > On Wed, Jan 3, 2018 at 5:41 PM, Jeff Layton <jlayton@kernel.org> wrote:
> > > > > On Wed, 2018-01-03 at 17:14 +0200, Amir Goldstein wrote:
> > > > > > The time values in stat and inode may differ for overlayfs and stat time
> > > > > > values are the correct ones to use. This is also consistent with the fact
> > > > > > that fill_post_wcc() also stores stat time values.
> > > > > > 
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >  fs/nfsd/nfs3xdr.c | 31 ++++++++++++++++++++++++++++++-
> > > > > >  fs/nfsd/nfs4xdr.c |  2 +-
> > > > > >  fs/nfsd/nfsfh.h   | 28 ++++++----------------------
> > > > > >  3 files changed, 37 insertions(+), 24 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> > > > > > index 2758480555fa..1a70581e1cb2 100644
> > > > > > --- a/fs/nfsd/nfs3xdr.c
> > > > > > +++ b/fs/nfsd/nfs3xdr.c
> > > > > > @@ -251,6 +251,34 @@ encode_wcc_data(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
> > > > > >  }
> > > > > > 
> > > > > >  /*
> > > > > > + * Fill in the pre_op attr for the wcc data
> > > > > > + */
> > > > > > +void fill_pre_wcc(struct svc_fh *fhp)
> > > > > > +{
> > > > > > +     struct inode    *inode;
> > > > > > +     struct kstat    stat;
> > > > > > +     __be32 err;
> > > > > > +
> > > > > > +     if (fhp->fh_pre_saved)
> > > > > > +             return;
> > > > > > +
> > > > > > +     inode = d_inode(fhp->fh_dentry);
> > > > > > +     err = fh_getattr(fhp, &stat);
> > > > > > +     if (err) {
> > > > > > +             /* Grab the times from inode anyway */
> > > > > > +             stat.mtime = inode->i_mtime;
> > > > > > +             stat.ctime = inode->i_ctime;
> > > > > > +             stat.size  = inode->i_size;
> > > > > > +     }
> > > > > > +
> > > > > 
> > > > > Might be best to instead just not supply pre/post op attrs if the
> > > > > getattr fails? They are technically optional with v3 -- we can just set
> > > > > the attributes_follow bit to false there.
> > > > 
> > > > I considered to set fh_pre_saved = false on error just like
> > > > fill_post_wcc() does, but wasn't sure of the consequences or how to test
> > > > for that matter, so I chose a more delicate fallback instead.
> > > > 
> > > 
> > > Take care with the BUG_ON in set_change_info if you do that.
> > > 
> > > Note that all of this is really just to handle weak cache consistency in
> > > v3, and the change_info4 value in v4. When the info is not reliable, the
> > > client doesn't trust its cache, for the most part. Getting it wrong
> > > shouldn't be fatal in most cases.
> > > 
> > > For v3 you can just clear the attributes_follow bit when you fill out
> > > the info, and leave it zeroed out. I had a patch a few years ago that
> > > did this on a per-export basis that you're welcome to take an run with:
> > > 
> > >     https://patchwork.kernel.org/patch/7159311/
> > > 
> > > Obviously, the conditions for doing this here are different.
> > > 
> > > For v4, I think we can just try to scrape what we have like you're doing
> > > here, and simply ensure that the "atomic" field being encoded in
> > > encode_cinfo is false when this occurs.
> > > 
> > 
> > Honestly, Jeff, at this point I am so far out into the woods with overlay NFS
> > export, that I would like to remain focused on correctness and leave
> > performance for later time.
> > 
> 
> :)
> 
> > So if I understand you correctly, patch 2/2 is not needed for correctness?
> > Meaning that if overlay inode times are not uptodate, nothing fatal will
> > happen? Or did you mean that I must take care of signalling the client
> > that time values are not reliable for overlayfs?
> > 
> > If patch 2/2 is indeed not a must, then I would like to ask you to ACK
> > patch 1/2. It seems quite simple, trivial and harmless to me even  without
> > diving deep into NFS protocols. I think patch 1/2 should be enough for
> > first implementation - it certainly is enough to fix the nfstest_posix failures.
> > 
> > Thanks!
> > Amir.
> 
> Patch #1 looks fine. I think we ought to wait on #2.
> 
> We really should be doing getattrs like this, but when that fails we
> should probably just zero out the wcc / change_info4 at the end rather
> than pretending that it's valid.

I can believe that, but that's what the current behavior is, so I don't
think this patch needs to (or should) make that change too.  I'd rather
fix the one overlayfs problem (as this patch does) and then handle the
change in behavior in the stat failure case separately.

(Though maybe a comment there to remind future selves of this dicussion
would be helpful.)

--b.
