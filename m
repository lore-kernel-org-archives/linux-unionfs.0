Return-Path: <willy@infradead.org>
Date: Mon, 29 Oct 2018 10:52:39 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 12/12] NFS: replace cross device check in
 copy_file_range
Message-ID: <20181029175239.GK28520@bombadil.infradead.org>
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
 <20181029174059.38326-14-olga.kornievskaia@gmail.com>
 <20181029175114.GJ28520@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029175114.GJ28520@bombadil.infradead.org>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 10:51:14AM -0700, Matthew Wilcox wrote:
> On Mon, Oct 29, 2018 at 01:40:59PM -0400, Olga Kornievskaia wrote:
> > +	c_in = (NFS_SERVER(file_inode(file_in)))->nfs_client;
> 
> Seems to be an unnecessary pair of brackets there, given existing code:
> 
> fs/nfs/delegation.c:    struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
> fs/nfs/dir.c:                                     NFS_SERVER(inode)->dtsize, desc->plus);
> fs/nfs/file.c:  if (NFS_SERVER(inode)->flags & NFS_MOUNT_LOCAL_FCNTL)
> (etc)
> 
> > +	if (c_in->cl_minorversion < 2)
> 
> in fact, can't you make this even simpler ...
> 
> 	if (NFS_SERVER(inode)->nfs_client->cl_minorversion < 2)

Oops.  Typed too fast:

	if (NFS_SERVER(file_inode(file_in)))->nfs_client->cl_minorversion < 2)

> I thought you needed to cast it, but code like this:
> 
> fs/nfs/nfs4proc.c: NFS_SERVER(dir)->nfs_client->cl_hostname);
> 
> would indicate not.
