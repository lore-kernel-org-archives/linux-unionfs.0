Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180315184726.GD13357@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-16-vgoyal@redhat.com>
 <CAOQ4uxhey5gG+oB1BUM465-S29rBgU90T8iAwE3Nb5KxWoWepA@mail.gmail.com>
 <20180314191533.GB1001@redhat.com> <20180315184726.GD13357@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Mar 2018 22:42:11 +0200
Message-ID: <CAOQ4uxhcmffRaJ3511aoLCPv_D3=QWFVfZ95gHMkbqyDVLksZQ@mail.gmail.com>
Subject: Re: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy
 file is copied up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 15, 2018 at 8:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 14, 2018 at 03:15:33PM -0400, Vivek Goyal wrote:
>> On Wed, Mar 07, 2018 at 10:21:30AM +0200, Amir Goldstein wrote:
>> > On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > > When a metacopy file is no longer a metacopy and data has been copied up,
>> > > remove REDIRECT xattr. Its not needed anymore.
>> > >
>> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > > ---
>> > >  fs/overlayfs/copy_up.c | 9 +++++++++
>> > >  1 file changed, 9 insertions(+)
>> > >
>> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> > > index 0c8d2755bd25..704febd2e2fa 100644
>> > > --- a/fs/overlayfs/copy_up.c
>> > > +++ b/fs/overlayfs/copy_up.c
>> > > @@ -775,6 +775,15 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>> > >         if (err)
>> > >                 return err;
>> > >
>> > > +       /*
>> > > +        * A metacopy files does not need redirect xattr once data has
>> > > +        * been copied up.
>> > > +        */
>> > > +       err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
>> > > +       if (err && err != -ENODATA && err != -EOPNOTSUPP)
>> > > +               return err;
>> > > +
>> > > +       err = 0;
>> > >         ovl_set_upperdata(d_inode(c->dentry));
>> > >         return err;
>> >
>> > By intuition, I would say that removing redirect should be done after setting
>> > upperdata flag. Not sure if it really matters in real life.
>> > Maybe when racing a lookup of a metacopy hardlink and copy up data of
>> > an upper alias?
>>
>> I think you found a good race situation.
>>
>> >
>> > Also, it would make sense to also ovl_dentry_set_redirect(c->dentry, NULL)
>> > probably use a helper ovl_clear_redirect() for the locking.
>> >
>> > But that highlights a serious problem with current patches -
>> > Access to OVL_I(inode)->redirect is protected with parent mutex in ovl_lookup()
>> > and additionally with dentry->d_lock in ovl_rename()
>> > That is sufficient for directories which can only have a single dentry
>> > alias to an
>> > inode but not at all sufficient for non-directories.
>>
>> This is a good point. So we need to protect OVL_I(inode)->redirect with
>> oi->lock mutex as well (atleast for non-dirs). So ovl_rename() will nest
>> 3 locks (which it already does for index case).
>>
>> parent dir i_mutex.
>>  oi->lock
>>    dentry->d_lock().
>>
>> I will try to write a patch for this and see what issues do I face
>
> Hi Amir,
>
> I am trying to understand better how you are taking oi->lock w.r.t
> nlink stuff and I am having a hard time.
>
> - Why do you keep oi->locked for the duration of operation (link, unlink
>   etc) using ovl_nlink_start() and ovl_nlink_end().

As the comment above ovl_nlink_start() says, union nlink may be changed
by link(), unlink() and copyup. nlink is an overlay inode property, so we need
to protect its updates with a lock on the inode object, which in this level if
oi->lock. Also, in ovl_nlink_end() we cleanup the index on last union nlink drop
and we need to do that also under inode object lock.

>
> - What exactly is oi->lock protecting. I understand its protecting
>   copy up. What else. Comment just says "synchronize copy up and more"
>   and its not clear what is that "more".

It is protecting operations that need to be serialized on the overlay inode
object, while inode->i_rwsem cannot be used for that purpose, because
it is used earlier in the locking order by VFS layer.
Those operations include copyup and union nlink update. I don't recall
there are other users for oi->lock at the moment, but did not check.

>
>   I need to understand that better to be able to use this lock for
>   protecting "oi->redirect" for the case of hard links.
>

If I am not mistaken, as long as you preserve locking order, you
should be able to use oi->lock to protect oi->redirect updates.
After all oi->redirect is really a property on the overlay inode.
It just happens to be protected a dentry level lock, from the time
that redirect was stored in the overlay dentry and that is only
still correct because of the one to one mapping between directory
inode and dentry.

Cheers,
Amir.
