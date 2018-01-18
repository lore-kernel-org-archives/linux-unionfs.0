From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/17] ovl: decode pure upper file handles
Date: Thu, 18 Jan 2018 16:34:52 +0200
Message-ID: <CAOQ4uxg34b6TZ6hwPczv_m_HquR6apnPy0gexHezixMedVqUZA@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-4-git-send-email-amir73il@gmail.com> <CAJfpegt=4Mk7B7E9c7CGJHdWZsVFQAqfJ_NbRNQNOpSZFYudrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegt=4Mk7B7E9c7CGJHdWZsVFQAqfJ_NbRNQNOpSZFYudrg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 18, 2018 at 4:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [Added Al Viro]
>
> On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Decoding an upper file handle is done by decoding the upper dentry from
>> underlying upper fs, finding or allocating an overlay inode that is
>> hashed by the real upper inode and instantiating an overlay dentry with
>> that inode.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/export.c    | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/overlayfs/namei.c     |  4 +--
>>  fs/overlayfs/overlayfs.h |  2 ++
>>  3 files changed, 95 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>> index 58c4f5e8a67e..5c72784a0b4d 100644
>> --- a/fs/overlayfs/export.c
>> +++ b/fs/overlayfs/export.c
>> @@ -93,6 +93,97 @@ static int ovl_encode_inode_fh(struct inode *inode, u32 *fid, int *max_len,
>>         return type;
>>  }
>>
>> +/*
>> + * Find or instantiate an overlay dentry from real dentries.
>> + */
>> +static struct dentry *ovl_obtain_alias(struct super_block *sb,
>> +                                      struct dentry *upper,
>> +                                      struct ovl_path *lowerpath)
>> +{
>> +       struct inode *inode;
>> +       struct dentry *dentry;
>> +       struct ovl_entry *oe;
>> +
>> +       /* TODO: obtain non pure-upper */
>> +       if (lowerpath)
>> +               return ERR_PTR(-EIO);
>> +
>> +       inode = ovl_get_inode(sb, dget(upper), NULL, NULL, 0);
>> +       if (IS_ERR(inode)) {
>> +               dput(upper);
>> +               return ERR_CAST(inode);
>> +       }
>> +
>> +       dentry = d_obtain_alias(inode);
>> +       if (IS_ERR(dentry) || dentry->d_fsdata)
>
> Racing two instances of this code, each thinking it got a new alias
> and trying to fill it, results in a memory leak.
>
> Haven't checked in too much depth, but apparently other filesystems
> are not affected, so we need something special here.
>
> One solution: split d_instantiate_anon(dentry, inode) out of
> __d_obtain_alias() and supply that with the already initialized
> dentry.
>

Can't we use &OVL_I(inode)->lock to avoid the race?

Thanks,
Amir.
