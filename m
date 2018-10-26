Return-Path: <olga.kornievskaia@gmail.com>
MIME-Version: 1.0
References: <20181025215147.36248-1-olga.kornievskaia@gmail.com>
 <20181025215147.36248-13-olga.kornievskaia@gmail.com> <20181025222754.GN25444@bombadil.infradead.org>
In-Reply-To: <20181025222754.GN25444@bombadil.infradead.org>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Fri, 26 Oct 2018 08:45:38 -0400
Message-ID: <CAN-5tyEtHdZZ6Rvs+DZWbU9O5MU3hVwvSCsUFx+fjrY7AZ1JMA@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] NFS replace cross device with cross filesystem
 check in copy_file_range
Content-Type: text/plain; charset="UTF-8"
To: willy@infradead.org
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, viro@zeniv.linux.org.uk, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-nfs <linux-nfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 6:27 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Oct 25, 2018 at 05:51:47PM -0400, Olga Kornievskaia wrote:
> > -     if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> > +     if (file_in->f_inode->i_sb->s_type != file_out->f_inode->i_sb->s_type)
>
> Isn't it simpler to do:
>
>         if (file_in->f_inode->i_sb->s_type != &nfs4_fs_type)

I don't believe that's sufficient. What if "in"  fs was NFS and "out"
fs was CIFS?

> But now I've done some grepping, and I wonder whether it's possible
> / desirable to also copy between inodes on a nfs4_remote_fs_type,
> nfs4_remote_referral_fs_type, nfs4_referral_fs_type or nfs4_xdev_fs_type.
> I haven't kept up with NFS development for a while, so maybe none of
> those are possible.

Thank you for pointing it out. Grepping thru the code, don't believe
the last one is used but for the migration and replication types, I
don't know if there are any caveats that would preclude support for
copy offload I'll check with Chuck Lever. Then the check should be
that "in" and "out" are any of the 4 NFS types.
