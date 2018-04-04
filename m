Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180404134110.GB12921@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-16-vgoyal@redhat.com>
 <CAOQ4uxhey5gG+oB1BUM465-S29rBgU90T8iAwE3Nb5KxWoWepA@mail.gmail.com> <20180404134110.GB12921@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Apr 2018 19:04:33 +0300
Message-ID: <CAOQ4uxhunb1NTkZ7SUKTCkiRhgRKvYUw9eiPiEkGb9Bo7e=4wQ@mail.gmail.com>
Subject: Re: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy
 file is copied up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 4, 2018 at 4:41 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 07, 2018 at 10:21:30AM +0200, Amir Goldstein wrote:
>> On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > When a metacopy file is no longer a metacopy and data has been copied up,
>> > remove REDIRECT xattr. Its not needed anymore.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/copy_up.c | 9 +++++++++
>> >  1 file changed, 9 insertions(+)
>> >
>> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> > index 0c8d2755bd25..704febd2e2fa 100644
>> > --- a/fs/overlayfs/copy_up.c
>> > +++ b/fs/overlayfs/copy_up.c
>> > @@ -775,6 +775,15 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>> >         if (err)
>> >                 return err;
>> >
>> > +       /*
>> > +        * A metacopy files does not need redirect xattr once data has
>> > +        * been copied up.
>> > +        */
>> > +       err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
>> > +       if (err && err != -ENODATA && err != -EOPNOTSUPP)
>> > +               return err;
>> > +
>> > +       err = 0;
>> >         ovl_set_upperdata(d_inode(c->dentry));
>> >         return err;
>>
>> By intuition, I would say that removing redirect should be done after setting
>> upperdata flag. Not sure if it really matters in real life.
>> Maybe when racing a lookup of a metacopy hardlink and copy up data of
>> an upper alias?
>>
>> Also, it would make sense to also ovl_dentry_set_redirect(c->dentry, NULL)
>> probably use a helper ovl_clear_redirect() for the locking.
>>
>> But that highlights a serious problem with current patches -
>> Access to OVL_I(inode)->redirect is protected with parent mutex in ovl_lookup()
>
>> and additionally with dentry->d_lock in ovl_rename()
>> That is sufficient for directories which can only have a single dentry
>> alias to an
>> inode but not at all sufficient for non-directories.
>
> Quick question on this. For non-dir files, will ovl_inode->redirect be
> protected by VFS locking. Atleast for our use case. We seem to be touching
> ovl_inode->redirect in rename, link and lookup path.
>
> VFS rename locks both source and destination inodes and link path will
> lock source and destination as well. So I think a rename and link can
> not make progress in parallel if any or the source or target is files
> are common. If that's the case two redirect writers can't stomp over
> each other.
>
> Lookup path will only set ovl_inode->redirect only if inode state is
> I_NEW and that means other vfs operations on same inode could not be
> making any progress.
>
> Now comes question of copy up path when we remove redirect xattr and
> modify ovl_inode->redirect. I don't know if we can assume that
> VFS is holding inode lock when copy up happens. If this assumption is
> valid, then it means rename and link can't make progress and it is
> safe to modify ovl_inode->redirect.
>
> I guess this assumption might not be valid, and that's why we need
> ovl_inode->lock. Not sure though. Can you throw some light at it.
>

copy up from open() file for write doesn't hold any VFS lock.

I guess before your metacopy changes, it would have been safe
to set redirect without ovl_inode lock if we would only take the
patch to move setting redirect into I_NEW, but anyway, if for no
other reason, it is good practice to also protect multiple access in
overlayfs layer, unless there is a good reason to rely on VFS locks.

Thanks,
Amir.
