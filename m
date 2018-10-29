Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
 <20181029174059.38326-14-olga.kornievskaia@gmail.com> <20181029175114.GJ28520@bombadil.infradead.org>
 <20181029175239.GK28520@bombadil.infradead.org>
In-Reply-To: <20181029175239.GK28520@bombadil.infradead.org>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 29 Oct 2018 13:56:46 -0400
Message-ID: <CAN-5tyF+TGjYw3S1VkBUfNFyJgQrdT8DCnE6T0Puh=LbqX5nhA@mail.gmail.com>
Subject: Re: [PATCH v5 12/12] NFS: replace cross device check in copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: willy@infradead.org
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 1:52 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Oct 29, 2018 at 10:51:14AM -0700, Matthew Wilcox wrote:
> > On Mon, Oct 29, 2018 at 01:40:59PM -0400, Olga Kornievskaia wrote:
> > > +   c_in = (NFS_SERVER(file_inode(file_in)))->nfs_client;
> >
> > Seems to be an unnecessary pair of brackets there, given existing code:
> >
> > fs/nfs/delegation.c:    struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
> > fs/nfs/dir.c:                                     NFS_SERVER(inode)->dtsize, desc->plus);
> > fs/nfs/file.c:  if (NFS_SERVER(inode)->flags & NFS_MOUNT_LOCAL_FCNTL)
> > (etc)
> >
> > > +   if (c_in->cl_minorversion < 2)
> >
> > in fact, can't you make this even simpler ...
> >
> >       if (NFS_SERVER(inode)->nfs_client->cl_minorversion < 2)
>
> Oops.  Typed too fast:
>
>         if (NFS_SERVER(file_inode(file_in)))->nfs_client->cl_minorversion < 2)
>
> > I thought you needed to cast it, but code like this:
> >
> > fs/nfs/nfs4proc.c: NFS_SERVER(dir)->nfs_client->cl_hostname);
> >
> > would indicate not.

You are right. Then no declaration is needed. I'll change it. Thank you.
