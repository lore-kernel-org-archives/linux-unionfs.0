Return-Path: <willy@infradead.org>
Date: Sun, 1 Dec 2019 03:47:06 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/1] fs: rethread notify_change to take a path instead of
 a dentry
Message-ID: <20191201114706.GL20752@bombadil.infradead.org>
References: <1575148763.5563.28.camel@HansenPartnership.com>
 <1575148868.5563.30.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575148868.5563.30.camel@HansenPartnership.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-fsdevel@vger.kernel.org, dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Nov 30, 2019 at 01:21:08PM -0800, James Bottomley wrote:
> @@ -402,6 +403,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
>  
>  	dentry = fhp->fh_dentry;
>  	inode = d_inode(dentry);
> +	path = &(struct path){
> +		.mnt = fhp->fh_export->ex_path.mnt,
> +		.dentry = dentry,
> +	};

Is this really clearer than writing:

	path.mnt = fhp->fh_export->ex_path.mnt;
	path.dentry = dentry;

(there are a few other occurrences I'd change)
