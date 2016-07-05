From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] security, overlayfs: provide copy up security hook
 for unioned files
Date: Tue, 5 Jul 2016 16:42:35 -0400
Message-ID: <20160705204235.GE17987@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
 <63906f0e-25cf-266b-6df9-18317f1e7c59@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <63906f0e-25cf-266b-6df9-18317f1e7c59@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jul 05, 2016 at 12:36:17PM -0700, Casey Schaufler wrote:
> 
> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> > Provide a security hook to label new file correctly when a file is copied
> > up from lower layer to upper layer of a overlay/union mount.
> >
> > This hook can prepare and switch to a new set of creds which are suitable
> > for new file creation during copy up. Caller should revert to old creds
> > after file creation.
> >
> > In SELinux, newly copied up file gets same label as lower file for
> > non-context mounts. But it gets label specified in mount option context=
> > for context mounts.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/copy_up.c    |  8 ++++++++
> >  include/linux/lsm_hooks.h | 13 +++++++++++++
> >  include/linux/security.h  |  6 ++++++
> >  security/security.c       |  8 ++++++++
> >  security/selinux/hooks.c  | 27 +++++++++++++++++++++++++++
> >  5 files changed, 62 insertions(+)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index 80aa6f1..90dc362 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -246,6 +246,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >  	struct dentry *upper = NULL;
> >  	umode_t mode = stat->mode;
> >  	int err;
> > +	const struct cred *old_creds = NULL;
> >  
> >  	newdentry = ovl_lookup_temp(workdir, dentry);
> >  	err = PTR_ERR(newdentry);
> > @@ -258,10 +259,17 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
> >  	if (IS_ERR(upper))
> >  		goto out1;
> >  
> > +	err = security_inode_copy_up(dentry, &old_creds);
> > +	if (err < 0)
> > +		goto out2;
> > +
> >  	/* Can't properly set mode on creation because of the umask */
> >  	stat->mode &= S_IFMT;
> >  	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
> >  	stat->mode = mode;
> > +	if (old_creds)
> > +		revert_creds(old_creds);
> > +
> >  	if (err)
> >  		goto out2;
> 
> I don't much care for the way part of the credential manipulation
> is done in the caller and part is done the the security module.
> If the caller is going to restore the old state, the caller should
> save the old state. 

Ok, I am fine either way. Smalley had preferred switching creds in 
security module, that's why I did it this way. I will change back
to allocating and overriding creds in caller.

> 
> >  
> > diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> > index 7ae3976..fcde9b9 100644
> > --- a/include/linux/lsm_hooks.h
> > +++ b/include/linux/lsm_hooks.h
> > @@ -401,6 +401,17 @@
> >   *	@inode contains a pointer to the inode.
> >   *	@secid contains a pointer to the location where result will be saved.
> >   *	In case of failure, @secid will be set to zero.
> > + * @inode_copy_up:
> > + *	A file is about to be copied up from lower layer to upper layer of
> > + *	overlay filesystem. Prepare a new set of creds and set file creation
> > + *	secid in such a way so that copied up file gets the appropriate
> 
> The details of what goes on the the SELinux case don't belong here.

Ok, will remove selinux specific details from here.

Thanks
Vivek
