From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/7] security, overlayfs: provide copy up security hook
 for unioned files
Date: Mon, 11 Jul 2016 12:54:23 -0400
Message-ID: <20160711165423.GB7728@redhat.com>
References: <1467994782-26474-1-git-send-email-vgoyal@redhat.com>
 <1467994782-26474-2-git-send-email-vgoyal@redhat.com>
 <26a1232e-09b2-e89b-22c3-7414dd11e79c@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbcGKQyZ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 11 Jul 2016 12:54:25 -0400
Content-Disposition: inline
In-Reply-To: <26a1232e-09b2-e89b-22c3-7414dd11e79c@tycho.nsa.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On Mon, Jul 11, 2016 at 11:24:26AM -0400, Stephen Smalley wrote:
> On 07/08/2016 12:19 PM, Vivek Goyal wrote:
> > Provide a security hook to label new file correctly when a file is copied
> > up from lower layer to upper layer of a overlay/union mount.
> > 
> > This hook can prepare a new set of creds which are suitable for new file
> > creation during copy up. Caller will use new creds to create file and then
> > revert back to old creds and release new creds.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c    | 18 ++++++++++++++++++
> >  include/linux/lsm_hooks.h | 11 +++++++++++
> >  include/linux/security.h  |  6 ++++++
> >  security/security.c       |  8 ++++++++
> >  4 files changed, 43 insertions(+)
> > 
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 80aa6f1..8ebea18 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -246,6 +246,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >  	struct dentry *upper = NULL;
> >  	umode_t mode = stat->mode;
> >  	int err;
> > +	const struct cred *old_creds = NULL;
> > +	struct cred *new_creds = NULL;
> >  
> >  	newdentry = ovl_lookup_temp(workdir, dentry);
> >  	err = PTR_ERR(newdentry);
> > @@ -258,10 +260,26 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >  	if (IS_ERR(upper))
> >  		goto out1;
> >  
> > +	err = security_inode_copy_up(dentry, &new_creds);
> > +	if (err < 0) {
> > +		if (new_creds)
> > +			put_cred(new_creds);
> 
> Why do we need a put_cred() here?

Being paranoid for the case of stacked modules. Say first module allocated
creds but second module returned error, in that case creds will have to
be freed.

I can get rid of it for now and if in future two LSMs implement this hook,
one can change it, if need be.

Thanks
Vivek
