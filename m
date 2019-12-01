Return-Path: <James.Bottomley@hansenpartnership.com>
Message-ID: <1575215700.3374.4.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/1] fs: rethread notify_change to take a path instead
 of a dentry
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sun, 01 Dec 2019 07:55:00 -0800
In-Reply-To: <20191201114706.GL20752@bombadil.infradead.org>
References: <1575148763.5563.28.camel@HansenPartnership.com>
	 <1575148868.5563.30.camel@HansenPartnership.com>
	 <20191201114706.GL20752@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, 2019-12-01 at 03:47 -0800, Matthew Wilcox wrote:
> On Sat, Nov 30, 2019 at 01:21:08PM -0800, James Bottomley wrote:
> > @@ -402,6 +403,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct
> > svc_fh *fhp, struct iattr *iap,
> >  
> >  	dentry = fhp->fh_dentry;
> >  	inode = d_inode(dentry);
> > +	path = &(struct path){
> > +		.mnt = fhp->fh_export->ex_path.mnt,
> > +		.dentry = dentry,
> > +	};
> 
> Is this really clearer than writing:
> 
> 	path.mnt = fhp->fh_export->ex_path.mnt;
> 	path.dentry = dentry;

I'm not sure about clearer but certainly better: the general principle
is always do named structure initialization, so in my version any
unspecified fields are cleared.  In your version they're set to
whatever uninitialized data was on the stack.  For struct path, it
probably doesn't matter because it's only ever going to have two
elements for all time, but in general it does.

James
