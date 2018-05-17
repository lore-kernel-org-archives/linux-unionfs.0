Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180517085305.GA23785@veci.piliscsaba.redhat.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-2-git-send-email-amir73il@gmail.com> <20180515132328.GA11678@redhat.com>
 <CAOQ4uxizDzcH7rDCTGHCpjD90RwKCqcjGCSyXx6GDU7Oj_nc6Q@mail.gmail.com>
 <CAOQ4uxj5vtH2MDkhP5UP4Mc3CMgMJoYjULZcyv1jZmSJgkDpnw@mail.gmail.com>
 <CAJfpegtC=FHdHAr5WKoMpX+aBTsMQB9Ffv0NfFouuSA3M08sqQ@mail.gmail.com> <20180517085305.GA23785@veci.piliscsaba.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 17 May 2018 11:58:49 +0300
Message-ID: <CAOQ4uxh-2Hitha8_01jNqO5qd=wuX8cmqsCcz5Fhr7mP8sk2NQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly
 created inode
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 17, 2018 at 11:53 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 17, 2018 at 10:10:58AM +0200, Miklos Szeredi wrote:
>>
>> Not the only reason: we don't want inode allocation to fail after
>> successful creation.  Solution: add a preallocated inode argument to
>> ovl_get_inode() and deal with allocation failure there.
>
> Here's a patch to split a helper out of iget5_locked() that takes a preallocated
> inode.  It makes the whole thing more readable, IMO, regardless of overlayfs's
> needs.
>

That looks good. I'll use that.
One suggestion below.

Thanks,
Amir.

>
> ---
> diff --git a/fs/inode.c b/fs/inode.c
> index 13ceb98c3bd3..bb79e3f96147 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1002,6 +1002,52 @@ void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>  }
>  EXPORT_SYMBOL(unlock_two_nondirectories);
>
> +struct inode *iget5_prealloc(struct inode *inode,
> +                            struct super_block *sb, unsigned long hashval,

Maybe no need to pass in @sb...

> +                            int (*test)(struct inode *, void *),
> +                            int (*set)(struct inode *, void *), void *data)
> +{
> +       struct hlist_head *head = inode_hashtable + hash(sb, hashval);
> +       struct inode *old;
> +
> +again:
> +       spin_lock(&inode_hash_lock);
> +       old = find_inode(sb, head, test, data);
> +       if (unlikely(old)) {
> +               /*
> +                * Uhhuh, somebody else created the same inode under us.
> +                * Use the old inode instead of the preallocated one.
> +                */
> +               spin_unlock(&inode_hash_lock);
> +               wait_on_inode(old);
> +               if (unlikely(inode_unhashed(old))) {
> +                       iput(old);
> +                       goto again;
> +               }
> +               return old;
> +       }
> +
> +       if (unlikely(set(inode, data))) {
> +               inode = NULL;
> +               goto unlock;
> +       }
> +
> +       /*
> +        * Return the locked inode with I_NEW set, the
> +        * caller is responsible for filling in the contents
> +        */
> +       spin_lock(&inode->i_lock);
> +       inode->i_state = I_NEW;
> +       hlist_add_head(&inode->i_hash, head);
> +       spin_unlock(&inode->i_lock);
> +       inode_sb_list_add(inode);
> +unlock:
> +       spin_unlock(&inode_hash_lock);
> +
> +       return inode;
> +}
> +EXPORT_SYMBOL(iget5_prealloc);
> +
>  /**
>   * iget5_locked - obtain an inode from a mounted file system
>   * @sb:                super block of file system
> @@ -1026,66 +1072,18 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
>                 int (*test)(struct inode *, void *),
>                 int (*set)(struct inode *, void *), void *data)
>  {
> -       struct hlist_head *head = inode_hashtable + hash(sb, hashval);
> -       struct inode *inode;
> -again:
> -       spin_lock(&inode_hash_lock);
> -       inode = find_inode(sb, head, test, data);
> -       spin_unlock(&inode_hash_lock);
> +       struct inode *inode = ilookup5(sb, hashval, test, data);
>
> -       if (inode) {
> -               wait_on_inode(inode);
> -               if (unlikely(inode_unhashed(inode))) {
> -                       iput(inode);
> -                       goto again;
> -               }
> -               return inode;
> -       }
> -
> -       inode = alloc_inode(sb);
> -       if (inode) {
> -               struct inode *old;
> -
> -               spin_lock(&inode_hash_lock);
> -               /* We released the lock, so.. */
> -               old = find_inode(sb, head, test, data);
> -               if (!old) {
> -                       if (set(inode, data))
> -                               goto set_failed;
> -
> -                       spin_lock(&inode->i_lock);
> -                       inode->i_state = I_NEW;
> -                       hlist_add_head(&inode->i_hash, head);
> -                       spin_unlock(&inode->i_lock);
> -                       inode_sb_list_add(inode);
> -                       spin_unlock(&inode_hash_lock);
> -
> -                       /* Return the locked inode with I_NEW set, the
> -                        * caller is responsible for filling in the contents
> -                        */
> -                       return inode;
> -               }
> +       if (!inode) {
> +               struct inode *new = alloc_inode(sb);
>
> -               /*
> -                * Uhhuh, somebody else created the same inode under
> -                * us. Use the old inode instead of the one we just
> -                * allocated.
> -                */
> -               spin_unlock(&inode_hash_lock);
> -               destroy_inode(inode);
> -               inode = old;
> -               wait_on_inode(inode);
> -               if (unlikely(inode_unhashed(inode))) {
> -                       iput(inode);
> -                       goto again;
> +               if (new) {
> +                       inode = iget5_prealloc(new, sb, hashval, test, set, data);
> +                       if (inode != new)
> +                               destroy_inode(new);
>                 }
>         }
>         return inode;
> -
> -set_failed:
> -       spin_unlock(&inode_hash_lock);
> -       destroy_inode(inode);
> -       return NULL;
>  }
>  EXPORT_SYMBOL(iget5_locked);
>
