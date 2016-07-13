From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/9] security, overlayfs: provide copy up security hook
 for unioned files
Date: Wed, 13 Jul 2016 10:56:30 -0400
Message-ID: <20160713145630.GE16900@redhat.com>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <1468421095-22322-2-git-send-email-vgoyal@redhat.com>
 <eecf35d9-707b-5dab-e3e8-273cf221d135@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <eecf35d9-707b-5dab-e3e8-273cf221d135@tycho.nsa.gov>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 13, 2016 at 10:52:34AM -0400, Stephen Smalley wrote:
> On 07/13/2016 10:44 AM, Vivek Goyal wrote:
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
> I think this is a mistake, diverges from how other hooks handle error
> conditions (if the hook allocates, the hook or the security
> infrastructure is responsible for freeing on error return, not the
> caller), and will be prone to double free errors.

Ok, I will get rid of it and assume LSM infrastructure will be responsible
for freeing this in case of error.

Vivek
