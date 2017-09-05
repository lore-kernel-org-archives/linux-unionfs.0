From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 1/3] vfs: add flags to d_real()
Date: Tue, 5 Sep 2017 11:02:34 +0200
Message-ID: <CAOssrKcsyqUNNwjZNM5eLUxR=Eo1MnKYWajGF4kxu+=SMhCu7g@mail.gmail.com>
References: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
 <1504597596-17994-2-git-send-email-mszeredi@redhat.com> <CAOQ4uxhv=GSxJjoJbM+qCazCC+VhmuHjDTYNfF0dmjG2tjSHTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhv=GSxJjoJbM+qCazCC+VhmuHjDTYNfF0dmjG2tjSHTQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Sep 5, 2017 at 10:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Sep 5, 2017 at 10:46 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> Add a separate flags argument (in addition to the open flags) to control
>> the behavior of d_real().
>>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> ---
> ...
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>>
>>  static struct dentry *ovl_d_real(struct dentry *dentry,
>>                                  const struct inode *inode,
>> -                                unsigned int open_flags)
>> +                                unsigned int open_flags, unsigned int flags)
>>  {
>>         struct dentry *real;
>>         int err;
>> @@ -102,7 +102,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>>                 goto bug;
>>
>>         /* Handle recursion */
>> -       real = d_real(real, inode, open_flags);
>> +       real = d_real(real, inode, open_flags, 0);
>>
>
> Shouldn't recursion pass on flags?
> The answer is probably per flag.
> The 2 currently proposed flags don't end up in recursion anyway,
> although it is arguable that D_REAL_ALL should end up in recursion
> because according to comment it should behave the same as
> d_real for regular files.
>
> For the purpose for which D_REAL_ALL was proposed (atime update)
> the recursion case doesn't really matter.
>
> Maybe a flag D_REAL_NORECURSE and then for
> update_ovl_inode_times() use D_REAL_ALL|D_REAL_NORECURSE
>
> Alternatively, update_ovl_inode_times() could use D_REAL_UPPER
> and then we explicitly say that we don't care about lower mtime/ctime
> modifications.

Well, D_REAL_ALL imples nonrecurse.  Maybe that needs better
documentation (comment above in ovl_d_real()) but I don't otherwise
see a problem with the current state of affairs.

Thanks,
Miklos
