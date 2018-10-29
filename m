Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-13-olga.kornievskaia@gmail.com> <7ef50e2c6b11ae80518db75efc35b2f96c9e4d32.camel@kernel.org>
 <20181027132624.GA25444@bombadil.infradead.org>
In-Reply-To: <20181027132624.GA25444@bombadil.infradead.org>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 29 Oct 2018 10:28:25 -0400
Message-ID: <CAN-5tyGjwn_xsVQWNtfUi=ZNd5OWJGeXPt1MEurQ1aSVC=PWaw@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] NFS: replace cross device check in copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: willy@infradead.org
Cc: jlayton@kernel.org, trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Oct 27, 2018 at 9:26 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Oct 27, 2018 at 07:08:11AM -0400, Jeff Layton wrote:
> > >
> > > -   if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> > > +   if (file_in->f_op != &nfs4_file_operations)
> > >             return -EXDEV;
> > > +   else {
> >
> > nit: you don't really need the "else" here since the previous block
> > returns
> >
> > > +           struct nfs_client *c_in =
> > > +                   (NFS_SERVER(file_inode(file_in)))->nfs_client;
> > > +           if (c_in->cl_minorversion < 2)
> > > +                   return -EXDEV;
> > > +   }
>
> Yeah, but if you don't have the else, then you need to declare the c_in
> at the beginning of the function instead of in the new block.  Mind you,
> if you do that then:
>
>         c_in = NFS_SERVER(file_inode(file_in))->nfs_client;
>
> fits on one line, so it does look a bit neater.

My thoughts for the "else" was to be able to get the nfs_client but
yes I could declare for the whole function and assign after the first
"if". I'll change it.
