From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH] Add flags option to get xattr method paired to
 __vfs_getxattr
Date: Fri, 16 Aug 2019 05:20:36 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.1908160515130.12729@namei.org>
References: <20190812193320.200472-1-salyzyn@android.com>
 <20190813084801.GA972@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20190813084801.GA972@kroah.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, linux-integrity@vger.kernel.org, Martin Brandenburg <martin@omnibond.com>, samba-technical@lists.samba.org, Dominique Martinet <asmadeus@codewreck.org>, Chao Yu <yuchao0@huawei.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Chris Mason <clm@fb.com>, "David S. Miller" <davem@davemloft.net>, Andreas Dilger <adilger.kernel@dilger.ca>, Eric Paris <eparis@parisplace.org>, netdev@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, linux-afs@lists.infradead.org, Mike Marshall <hubcap@omnibond.com>, linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Mark Fasheh <mark@fasheh.com>, Hugh
List-Id: linux-unionfs@vger.kernel.org

On Tue, 13 Aug 2019, Greg Kroah-Hartman wrote:

> On Mon, Aug 12, 2019 at 12:32:49PM -0700, Mark Salyzyn wrote:
> > --- a/include/linux/xattr.h
> > +++ b/include/linux/xattr.h
> > @@ -30,10 +30,10 @@ struct xattr_handler {
> >  	const char *prefix;
> >  	int flags;      /* fs private flags */
> >  	bool (*list)(struct dentry *dentry);
> > -	int (*get)(const struct xattr_handler *, struct dentry *dentry,
> > +	int (*get)(const struct xattr_handler *handler, struct dentry *dentry,
> >  		   struct inode *inode, const char *name, void *buffer,
> > -		   size_t size);
> > -	int (*set)(const struct xattr_handler *, struct dentry *dentry,
> > +		   size_t size, int flags);
> > +	int (*set)(const struct xattr_handler *handler, struct dentry *dentry,
> >  		   struct inode *inode, const char *name, const void *buffer,
> >  		   size_t size, int flags);
> 
> Wow, 7 arguments.  Isn't there some nice rule of thumb that says once
> you get more then 5, a function becomes impossible to understand?
> 
> Surely this could be a structure passed in here somehow, that way when
> you add the 8th argument in the future, you don't have to change
> everything yet again?  :)
> 
> I don't have anything concrete to offer as a replacement fix for this,
> but to me this just feels really wrong...

How about something like:

struct xattr_gs_args {
	struct dentry *dentry;
	struct inode *inode;
	const char *name;
	const void *buffer;
	size_t size;
	int flags;
};

int (*get)(const struct xattr_handler *handler, struct xattr_gs_args *args);
int (*set)(const struct xattr_handler *handler, struct xattr_gs_args *args);


-- 
James Morris
<jmorris@namei.org>


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
