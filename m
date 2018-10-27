Return-Path: <willy@infradead.org>
Date: Sat, 27 Oct 2018 06:26:24 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 11/11] NFS: replace cross device check in
 copy_file_range
Message-ID: <20181027132624.GA25444@bombadil.infradead.org>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-13-olga.kornievskaia@gmail.com>
 <7ef50e2c6b11ae80518db75efc35b2f96c9e4d32.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ef50e2c6b11ae80518db75efc35b2f96c9e4d32.camel@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Olga Kornievskaia <olga.kornievskaia@gmail.com>, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 07:08:11AM -0400, Jeff Layton wrote:
> >  
> > -	if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> > +	if (file_in->f_op != &nfs4_file_operations)
> >  		return -EXDEV;
> > +	else {
> 
> nit: you don't really need the "else" here since the previous block
> returns
> 
> > +		struct nfs_client *c_in =
> > +			(NFS_SERVER(file_inode(file_in)))->nfs_client;
> > +		if (c_in->cl_minorversion < 2)
> > +			return -EXDEV;
> > +	}

Yeah, but if you don't have the else, then you need to declare the c_in
at the beginning of the function instead of in the new block.  Mind you,
if you do that then:

	c_in = NFS_SERVER(file_inode(file_in))->nfs_client;

fits on one line, so it does look a bit neater.
