Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-4-olga.kornievskaia@gmail.com> <20181026212631.GY25444@bombadil.infradead.org>
In-Reply-To: <20181026212631.GY25444@bombadil.infradead.org>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 29 Oct 2018 12:09:32 -0400
Message-ID: <CAN-5tyF=sSTx5JquKJRwNUP4r1+GBJuJUcW4xz4GrDXMjVk=Gw@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] VFS: copy_file_range check validity of input
 source offset
Content-Type: text/plain; charset="UTF-8"
To: willy@infradead.org
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 5:26 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Oct 26, 2018 at 04:10:48PM -0400, Olga Kornievskaia wrote:
> > +++ b/fs/read_write.c
> > @@ -1594,6 +1594,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
> >               }
> >       }
> >
> > +     if (pos_in >= i_size_read(inode_in))
> > +             return -EINVAL;
> > +
> >       if (file_out->f_op->copy_file_range) {
> >               ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
> >                                                     pos_out, len, flags);
>
> Is this the right place to check this?  Surely we should be checking for
> this before calling clone_file_range()?

Ops, indeed this is the wrong place. If I were to keep this check here
then I need to move it where it was originally located. However, right
now I'm included to not do the check in VFS at all and move it to NFS.
