From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/5] security,overlayfs: Provide security hook for copy
 up of xattrs for overlay file
Date: Wed, 6 Jul 2016 13:50:16 -0400
Message-ID: <20160706175016.GC11176@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-3-git-send-email-vgoyal@redhat.com>
 <bc7c8147-465e-791d-ce5a-1a194eb67228@schaufler-ca.com>
 <20160705211502.GG17987@redhat.com>
 <93ab3b87-a9c7-b792-2253-07aa2d03681e@schaufler-ca.com>
 <20160706170900.GB11176@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706170900.GB11176@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 06, 2016 at 01:09:00PM -0400, Vivek Goyal wrote:
> On Tue, Jul 05, 2016 at 02:34:43PM -0700, Casey Schaufler wrote:
> > On 7/5/2016 2:15 PM, Vivek Goyal wrote:
> > > On Tue, Jul 05, 2016 at 01:22:22PM -0700, Casey Schaufler wrote:
> > >> On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> > >>> Provide a security hook which is called when xattrs of a file are being
> > >>> copied up. This hook is called once for each xattr and one can either
> > >>> accept or reject xattr. If 0 is returned, xattr will be copied up, if 1
> > >>> is returned, xattr will not be copied up and if negative error code
> > >>> is returned, copy up will be aborted.
> > >>>
> > >>> In SELinux, label of lower file is not copied up. File already has been
> > >>> set with right label at the time of creation and we don't want to overwrite
> > >>> that label.
> > >>>
> > >>> Signed-off-by: David Howells <dhowells@redhat.com>
> > >>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > >>> ---
> > >>>  fs/overlayfs/copy_up.c    |  8 ++++++++
> > >>>  include/linux/lsm_hooks.h | 13 +++++++++++++
> > >>>  include/linux/security.h  | 10 ++++++++++
> > >>>  security/security.c       |  9 +++++++++
> > >>>  security/selinux/hooks.c  | 14 ++++++++++++++
> > >>>  5 files changed, 54 insertions(+)
> > >>>
> > >>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > >>> index 90dc362..2c31938 100644
> > >>> --- a/fs/overlayfs/copy_up.c
> > >>> +++ b/fs/overlayfs/copy_up.c
> > >>> @@ -103,6 +103,14 @@ retry:
> > >>>  			goto retry;
> > >>>  		}
> > >>>  
> > >>> +		error = security_inode_copy_up_xattr(old, new,
> > >>> +						     name, value, size);
> > >>> +		if (error < 0)
> > >>> +			break;
> > >>> +		if (error == 1) {
> > >>> +			error = 0;
> > >>> +			continue; /* Discard */
> > >>> +		}
> > >>>  		error = vfs_setxattr(new, name, value, size, 0);
> > >>>  		if (error)
> > >>>  			break;
> > >>> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> > >>> index fcde9b9..2a8ee8c 100644
> > >>> --- a/include/linux/lsm_hooks.h
> > >>> +++ b/include/linux/lsm_hooks.h
> > >>> @@ -412,6 +412,16 @@
> > >>>   *	@src indicates the union dentry of file that is being copied up.
> > >>>   *	@old indicates the pointer to old_cred returned to caller.
> > >>>   *	Returns 0 on success or a negative error code on error.
> > >>> + * @inode_copy_up_xattr:
> > >>> + *	Filter the xattrs being copied up when a unioned file is copied
> > >>> + *	up from a lower layer to the union/overlay layer.
> > >>> + *	@src indicates the file that is being copied up.
> > >>> + *	@dst indicates the file that has being created by the copy up.
> > >>> + *	@name indicates the name of the xattr.
> > >>> + *	@value, @size indicate the payload of the xattr.
> > >>> + *	Returns 0 to accept the xattr, 1 to discard the xattr or a negative
> > >>> + *	error code to abort the copy up. Note that the caller is responsible
> > >>> + *	for reading and writing the xattrs as this hook is merely a filter.
> > >> The return should be -EOPNOTSUPP from security modules that don't
> > >> support the attribute "name". This will make it possible to support
> > >> multiple modules that provide attributes. (patches pending)
> > > Hmm.., Sorry I did not understand this one. 
> > >
> > > So all modules will not understand all xattrs. So if they start returning
> > > -EOPNOTSUPP, then as per current implementation, copy up operation will
> > > be aborted. 
> > 
> > Yes, the infrastructure code will have to change to deal with the
> > tri-state returns. That's also true of several other hooks.
> > 
> > > Current implementation relies on that a security module, returns 0 if
> > > every thing is "name" xattr should be copied up or lsm does not care.
> > > Negative error code is returned only if something is wrong. Given every
> > > lsm will not understand/care about all the xattrs, we can't return 
> > > error code if lsm does not own/understand the "name". In fact
> > > call_int_hook() will bail out the very first time negative error code
> > > is returned. 
> > >
> > > IOW, current implementation will work with multiple modules providing
> > > implementation for same hook as long as module returns 0 for the xattrs
> > > it does not understand. 
> > 
> > There have to be four states. I own this attribute, and want you
> > to use it. I own this attribute and I want you to ignore it. I don't
> > own this attribute. I own this attribute and something went terribly
> > wrong, such as running out of memory.
> 
> Ok, so we have 3 states currently and we should have four.
> 
> I own this attribute and want you to use it ---> Return 0
> I own this attribute and want you to ignore it --> Return 1
> I don't own this attribute --> -EOPNOTSUPP
> Something went terribly wrong --> Negative error code.
> 
> I can modify call_int_hook() to continue if -EOPNOTSUPP is returned. And
> if none of the LSMs claimed xattr, caller will get -EOPNOTSUPP.
> 
> But what is caller supposed to do with it. There might be xattrs which
> are just user data (user.foo) and aborting copying up will not make sense.
> That means caller will continue to copy up anyway and treat -EOPNOTSUPP
> as success.
> 
> IOW, What are we going to gain by introducing this extra state when none
> of the LSMs claims to know about the xattr name passed in.

Or you are looking for something where caller does not see -EOPNOTSUPP. It
is useful for call_int_hook_foo() where it will return after first LSM
has claimed the "name".

Vivek
