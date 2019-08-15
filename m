From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] Add flags option to get xattr method paired to
 __vfs_getxattr
Date: Thu, 15 Aug 2019 17:30:24 +0200
Message-ID: <20190815153024.GP14313@quack2.suse.cz>
References: <20190813145527.26289-1-salyzyn@android.com>
 <20190814110022.GB26273@quack2.suse.cz>
 <71d66fd1-cc94-fd0c-dfa7-115ba8a6b95a@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <71d66fd1-cc94-fd0c-dfa7-115ba8a6b95a@android.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Phillip Lougher <phillip@squashfs.org.uk>, Jan Kara <jack@suse.cz>, linux-integrity@vger.kernel.org, Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org, Dominique Martinet <asmadeus@codewreck.org>, Chao Yu <yuchao0@huawei.com>, Mimi Zohar <zohar@linux.ibm.com>, Adrian Hunter <adrian.hunter@intel.com>, linux-mm@kvack.org, Chris Mason <clm@fb.com>, netdev@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-xfs@vger.kernel.org, Eric Paris <eparis@parisplace.org>, linux-f2fs-devel@lists.sourceforge.net, linux-afs@lists.infradead.org, Stephen Smalley <sds@tycho.nsa.gov>, Mike Marshall <hubcap@omnibond.com>, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, Paul Moore <paul@paul-moore.com>, Sage Weil <sage@redhat.com>, Darric
List-Id: linux-unionfs@vger.kernel.org

On Wed 14-08-19 07:54:16, Mark Salyzyn wrote:
> On 8/14/19 4:00 AM, Jan Kara wrote:
> > On Tue 13-08-19 07:55:06, Mark Salyzyn wrote:
> > ...
> > > diff --git a/fs/xattr.c b/fs/xattr.c
> > > index 90dd78f0eb27..71f887518d6f 100644
> > > --- a/fs/xattr.c
> > > +++ b/fs/xattr.c
> > ...
> > >   ssize_t
> > >   __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
> > > -	       void *value, size_t size)
> > > +	       void *value, size_t size, int flags)
> > >   {
> > >   	const struct xattr_handler *handler;
> > > -
> > > -	handler = xattr_resolve_name(inode, &name);
> > > -	if (IS_ERR(handler))
> > > -		return PTR_ERR(handler);
> > > -	if (!handler->get)
> > > -		return -EOPNOTSUPP;
> > > -	return handler->get(handler, dentry, inode, name, value, size);
> > > -}
> > > -EXPORT_SYMBOL(__vfs_getxattr);
> > > -
> > > -ssize_t
> > > -vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
> > > -{
> > > -	struct inode *inode = dentry->d_inode;
> > >   	int error;
> > > +	if (flags & XATTR_NOSECURITY)
> > > +		goto nolsm;
> > Hum, is it OK for XATTR_NOSECURITY to skip even the xattr_permission()
> > check? I understand that for reads of security xattrs it actually does not
> > matter in practice but conceptually that seems wrong to me as
> > XATTR_NOSECURITY is supposed to skip just security-module checks to avoid
> > recursion AFAIU.
> 
> Good catch I think.
> 
> I was attempting to make this change purely inert, no change in
> functionality, only a change in API. Adding a call to xattr_permission would
> incur a change in overall functionality, as it would introduce into the
> current and original __vfs_getxattr a call to xattr_permission that was not
> there before.
> 
> (I will have to defer the real answer and requirements to the security
> folks)
> 
> AFAIK you are correct, and to make the call would reduce the attack surface,
> trading a very small amount of CPU utilization, for a much larger amount of
> trust.
> 
> Given the long history of this patch set (for overlayfs) and the large
> amount of stakeholders, I would _prefer_ to submit a followup independent
> functionality/security change to _vfs_get_xattr _after_ this makes it in.

You're right. The problem was there before. So ack to changing this later.

> > > diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
> > > index c1395b5bd432..1216d777d210 100644
> > > --- a/include/uapi/linux/xattr.h
> > > +++ b/include/uapi/linux/xattr.h
> > > @@ -17,8 +17,9 @@
> > >   #if __UAPI_DEF_XATTR
> > >   #define __USE_KERNEL_XATTR_DEFS
> > > -#define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
> > > -#define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
> > > +#define XATTR_CREATE	 0x1	/* set value, fail if attr already exists */
> > > +#define XATTR_REPLACE	 0x2	/* set value, fail if attr does not exist */
> > > +#define XATTR_NOSECURITY 0x4	/* get value, do not involve security check */
> > >   #endif
> > It seems confusing to export XATTR_NOSECURITY definition to userspace when
> > that is kernel-internal flag. I'd just define it in include/linux/xattr.h
> > somewhere from the top of flags space (like 0x40000000).
> > 
> > Otherwise the patch looks OK to me (cannot really comment on the security
> > module aspect of this whole thing though).
> 
> Good point. However, we do need to keep these flags together to reduce
> maintenance risk, I personally abhor two locations for flags bits even if
> one comes from the opposite bit-side; collisions are undetectable at build
> time. Although I have not gone through the entire thought experiment, I am
> expecting that fuse could possibly benefit from this flag (if exposed) since
> it also has a security recursion. That said, fuse is probably the example of
> a gaping wide attack surface if user space had access to it ... your
> xattr_permissions call addition requested above would be realistically, not
> just pedantically, required!

Yeah, flags bits in two places are bad as well. So maybe at least
#ifdef __KERNEL__ bit around the definitiona and a comment that it is
kernel internal flag?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
