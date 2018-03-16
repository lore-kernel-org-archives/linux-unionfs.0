Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180316125209.GA4523@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-16-vgoyal@redhat.com>
 <CAOQ4uxhey5gG+oB1BUM465-S29rBgU90T8iAwE3Nb5KxWoWepA@mail.gmail.com>
 <20180314191533.GB1001@redhat.com> <20180315184726.GD13357@redhat.com>
 <CAOQ4uxhcmffRaJ3511aoLCPv_D3=QWFVfZ95gHMkbqyDVLksZQ@mail.gmail.com> <20180316125209.GA4523@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Mar 2018 15:17:47 +0200
Message-ID: <CAOQ4uxhrbMSLoX02t-JyRx7EySwECe9sPUVnKLUu-FwNm00Kxw@mail.gmail.com>
Subject: Re: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy
 file is copied up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 2:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 15, 2018 at 10:42:11PM +0200, Amir Goldstein wrote:
>> On Thu, Mar 15, 2018 at 8:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Wed, Mar 14, 2018 at 03:15:33PM -0400, Vivek Goyal wrote:
>> >> On Wed, Mar 07, 2018 at 10:21:30AM +0200, Amir Goldstein wrote:
>> >> > On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > > When a metacopy file is no longer a metacopy and data has been copied up,
>> >> > > remove REDIRECT xattr. Its not needed anymore.
>> >> > >
>> >> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> >> > > ---
>> >> > >  fs/overlayfs/copy_up.c | 9 +++++++++
>> >> > >  1 file changed, 9 insertions(+)
>> >> > >
>> >> > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> >> > > index 0c8d2755bd25..704febd2e2fa 100644
>> >> > > --- a/fs/overlayfs/copy_up.c
>> >> > > +++ b/fs/overlayfs/copy_up.c
>> >> > > @@ -775,6 +775,15 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>> >> > >         if (err)
>> >> > >                 return err;
>> >> > >
>> >> > > +       /*
>> >> > > +        * A metacopy files does not need redirect xattr once data has
>> >> > > +        * been copied up.
>> >> > > +        */
>> >> > > +       err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
>> >> > > +       if (err && err != -ENODATA && err != -EOPNOTSUPP)
>> >> > > +               return err;
>> >> > > +
>> >> > > +       err = 0;
>> >> > >         ovl_set_upperdata(d_inode(c->dentry));
>> >> > >         return err;
>> >> >
>> >> > By intuition, I would say that removing redirect should be done after setting
>> >> > upperdata flag. Not sure if it really matters in real life.
>> >> > Maybe when racing a lookup of a metacopy hardlink and copy up data of
>> >> > an upper alias?
>> >>
>> >> I think you found a good race situation.
>> >>
>> >> >
>> >> > Also, it would make sense to also ovl_dentry_set_redirect(c->dentry, NULL)
>> >> > probably use a helper ovl_clear_redirect() for the locking.
>> >> >
>> >> > But that highlights a serious problem with current patches -
>> >> > Access to OVL_I(inode)->redirect is protected with parent mutex in ovl_lookup()
>> >> > and additionally with dentry->d_lock in ovl_rename()
>> >> > That is sufficient for directories which can only have a single dentry
>> >> > alias to an
>> >> > inode but not at all sufficient for non-directories.
>> >>
>> >> This is a good point. So we need to protect OVL_I(inode)->redirect with
>> >> oi->lock mutex as well (atleast for non-dirs). So ovl_rename() will nest
>> >> 3 locks (which it already does for index case).
>> >>
>> >> parent dir i_mutex.
>> >>  oi->lock
>> >>    dentry->d_lock().
>> >>
>> >> I will try to write a patch for this and see what issues do I face
>> >
>> > Hi Amir,
>> >
>> > I am trying to understand better how you are taking oi->lock w.r.t
>> > nlink stuff and I am having a hard time.
>> >
>> > - Why do you keep oi->locked for the duration of operation (link, unlink
>> >   etc) using ovl_nlink_start() and ovl_nlink_end().
>>
>> As the comment above ovl_nlink_start() says, union nlink may be changed
>> by link(), unlink() and copyup. nlink is an overlay inode property, so we need
>> to protect its updates with a lock on the inode object, which in this level if
>> oi->lock. Also, in ovl_nlink_end() we cleanup the index on last union nlink drop
>> and we need to do that also under inode object lock.
>
> Sure. What I don't understand is that why do we have to continue to hold
> the lock for the whole duration. Can we drop the lock and re-acquire it
> before we cleanup index and change nlink value on ovelray inode?
>

No. When copyup calls ovl_set_nlink_upper() the value to write in NLINK
xattr is computed from ovl_inode->i_link and realinode->i_nlink.
If we drop the lock between ovl_nlink_start() and ovl_nlink_end(), realinode
nlink can change while copyup is in progress and then union nlink will be
messed up.

What is exactly the problem that you are trying to solve?
It seems that you need to protect oi->redirect in copyup/rename/link.
copyup/link already take the oi->lock and rename takes oi->lock
on new inode in case of "overwrite".
A simple solution would be to call ovl_nlink_start()/ovl_nlink_end()
in rename for both old and new inodes, regardless of "overwrite".
It may be unneeded, but in fact, ovl_nlink_start() doesn't do
anything wrong, it just recomputes NLINK xattr and most of those
recomputes will store the same value anyway, unless machine crashes
during copyup between ovl_set_nlink_lower() and
ovl_set_nlink_upper() and leaves the value of NLINK xattr relative to
lower nlink.

Amir.
