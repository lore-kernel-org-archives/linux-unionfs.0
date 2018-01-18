From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 03/17] ovl: decode pure upper file handles
Date: Fri, 19 Jan 2018 00:57:42 +0200
Message-ID: <CAOQ4uxhHUaorYA5ZAXQrfaOrp6Xa4cabz+ZFRdVBp6Mf-ebb0g@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
 <1515086449-26563-4-git-send-email-amir73il@gmail.com> <CAJfpegt=4Mk7B7E9c7CGJHdWZsVFQAqfJ_NbRNQNOpSZFYudrg@mail.gmail.com>
 <CAOQ4uxg34b6TZ6hwPczv_m_HquR6apnPy0gexHezixMedVqUZA@mail.gmail.com>
 <CAJfpegttoV7aPN2sS6RXONh0eFQ9xyoFxZbzVG7UMCcAJ+zjtg@mail.gmail.com>
 <CAOQ4uxhaC3b2N1rNCBgv0MTyBQgWFZKyVV60VWnudb_wY6A98Q@mail.gmail.com>
 <CAJfpeguVZztckNqML_hJRrEXumMMAeB6+Ha2djPrmCbqXz1brw@mail.gmail.com> <CAOQ4uxh0EEuhsLxD3M_xngMd14C=hGb8U12yPe=duELwb4yNDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:42301 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932419AbeARW5n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 17:57:43 -0500
In-Reply-To: <CAOQ4uxh0EEuhsLxD3M_xngMd14C=hGb8U12yPe=duELwb4yNDQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>

On Thu, Jan 18, 2018 at 10:35 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jan 18, 2018 at 10:10 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jan 18, 2018 at 8:49 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Thu, Jan 18, 2018 at 4:39 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Thu, Jan 18, 2018 at 3:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>> On Thu, Jan 18, 2018 at 4:09 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>>> [Added Al Viro]
>>>>>>
>>>>>> On Thu, Jan 4, 2018 at 6:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>>>>> Decoding an upper file handle is done by decoding the upper dentry from
>>>>>>> underlying upper fs, finding or allocating an overlay inode that is
>>>>>>> hashed by the real upper inode and instantiating an overlay dentry with
>>>>>>> that inode.
>>>>>>>
>>>>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>>>>> ---
>>>>>>>  fs/overlayfs/export.c    | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>  fs/overlayfs/namei.c     |  4 +--
>>>>>>>  fs/overlayfs/overlayfs.h |  2 ++
>>>>>>>  3 files changed, 95 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>>>>>>> index 58c4f5e8a67e..5c72784a0b4d 100644
>>>>>>> --- a/fs/overlayfs/export.c
>>>>>>> +++ b/fs/overlayfs/export.c
>>>>>>> @@ -93,6 +93,97 @@ static int ovl_encode_inode_fh(struct inode *inode, u32 *fid, int *max_len,
>>>>>>>         return type;
>>>>>>>  }
>>>>>>>
>>>>>>> +/*
>>>>>>> + * Find or instantiate an overlay dentry from real dentries.
>>>>>>> + */
>>>>>>> +static struct dentry *ovl_obtain_alias(struct super_block *sb,
>>>>>>> +                                      struct dentry *upper,
>>>>>>> +                                      struct ovl_path *lowerpath)
>>>>>>> +{
>>>>>>> +       struct inode *inode;
>>>>>>> +       struct dentry *dentry;
>>>>>>> +       struct ovl_entry *oe;
>>>>>>> +
>>>>>>> +       /* TODO: obtain non pure-upper */
>>>>>>> +       if (lowerpath)
>>>>>>> +               return ERR_PTR(-EIO);
>>>>>>> +
>>>>>>> +       inode = ovl_get_inode(sb, dget(upper), NULL, NULL, 0);
>>>>>>> +       if (IS_ERR(inode)) {
>>>>>>> +               dput(upper);
>>>>>>> +               return ERR_CAST(inode);
>>>>>>> +       }
>>>>>>> +
>>>>>>> +       dentry = d_obtain_alias(inode);
>>>>>>> +       if (IS_ERR(dentry) || dentry->d_fsdata)
>>>>>>
>>>>>> Racing two instances of this code, each thinking it got a new alias
>>>>>> and trying to fill it, results in a memory leak.
>>>>>>
>>>>>> Haven't checked in too much depth, but apparently other filesystems
>>>>>> are not affected, so we need something special here.
>>>>>>
>>>>>> One solution: split d_instantiate_anon(dentry, inode) out of
>>>>>> __d_obtain_alias() and supply that with the already initialized
>>>>>> dentry.
>>>>>>
>>>>>
>>>>> Can't we use &OVL_I(inode)->lock to avoid the race?
>>>>
>>>> We could.  But then d_splice_alias() will find our half baked dentry
>>>> and return that from ovl_lookup().
>>>
>>> No it won't, because we do not obtain dir dentries this way.
>>> We actually do in this patch [3/17], but since patch [4/17] we don't,
>>> so I only need to fix this patch not to obtain dir dentry and to
>>> protect concurrent decode of non-dir with &OVL_I(inode)->lock.
>>>
>>>> So we do need to have the dentry
>>>> fully initialized by the time it's added into the inode's alias list.
>>>>
>>>
>>> The only problems I see with adding a non-dir disconnected alias
>>> that is not fully baked are:
>>> 1. We can get it in ovl_encode_inode_fh() from d_find_any_alias()
>>> 2. nfsd can get it in exportfs_decode_fh() from find_acceptable_alias()
>>>     in a weird hypothetical case where the fully baked dentry we just
>>>     returned from ovl_obtain_alias() in NOT acceptable by nfsd but
>>>     the half baked dentry IS acceptable
>>> 3. Another kernel user that uses d_find_any_alias() or one of the use
>>>     case that only Al can think of...
>>>
>>> Cases 2 and 3, I don't know if they are for real.
>>>
>>> Case 1 is only a problem due to lack of export_operations method
>>> 'dentry_to_fh'. exportfs_encode_fh() has the right dentry, but it does
>>> not pass it to the filesystem for encoding, so I think it should be
>>> solved by adding this method.
>>
>> I agree with your analysis.
>>
>> However, I don't see what's wrong with adding fully baked dentries to
>> the inode.
>
> I agree that adding half baked dentries is not a good practice and
> we should avoid it.
>

How is this for an option?

===========================================

+/*
+ * Find or instantiate an overlay dentry from real dentries.
+ */
+static struct dentry *ovl_obtain_alias(struct super_block *sb,
+                                      struct dentry *upper,
+                                      struct ovl_path *lowerpath)
+{
+       struct inode *inode;
+       struct dentry *dentry;
+       struct ovl_entry *oe;
+       void *fsdata = &oe;
+
+       /* TODO: obtain non pure-upper */
+       if (lowerpath)
+               return ERR_PTR(-EIO);
+
+       inode = ovl_get_inode(sb, dget(upper), NULL, NULL, 0);
+       if (IS_ERR(inode)) {
+               dput(upper);
+               return ERR_CAST(inode);
+       }
+
+       oe = ovl_alloc_entry(0);
+       if (!oe) {
+               iput(inode);
+               return ERR_PTR(-ENOMEM);
+       }
+       oe->has_upper = true;
+
+       dentry = d_obtain_alias_fsdata(inode, fsdata);
+       /* A new allocated dentry assigns *fsdata and sets it to NULL */
+       if (oe)
+               kfree(oe);
+
+       return dentry;
+}
+


...


-static struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
+static struct dentry *__d_obtain_alias(struct inode *inode, int disconnected,
+                                      void **fsdata)
 {
        struct dentry *tmp;
        struct dentry *res;
@@ -1962,6 +1963,12 @@ static struct dentry *__d_obtain_alias(struct
inode *inode, int disconnected)
        if (disconnected)
                add_flags |= DCACHE_DISCONNECTED;

+       /* Take ownership of pre-allocated fs-specific data */
+       if (fsdata) {
+               tmp->d_fsdata = fsdata;
+               *fsdata = NULL;
+       }
+
        spin_lock(&tmp->d_lock);
        __d_set_inode_and_type(tmp, inode, add_flags);
        hlist_add_head(&tmp->d_u.d_alias, &inode->i_dentry);
@@ -1998,7 +2005,13 @@ static struct dentry *__d_obtain_alias(struct
inode *inode, int disconnected)
  */
 struct dentry *d_obtain_alias(struct inode *inode)
 {
-       return __d_obtain_alias(inode, 1);
+       return __d_obtain_alias(inode, 1, NULL);
+}
+EXPORT_SYMBOL(d_obtain_alias);
+
+struct dentry *d_obtain_alias_fsdata(struct inode *inode, void **fsdata)
+{
+       return __d_obtain_alias(inode, 1, fsdata);
 }
 EXPORT_SYMBOL(d_obtain_alias);

@@ -2019,7 +2032,7 @@ EXPORT_SYMBOL(d_obtain_alias);
  */
 struct dentry *d_obtain_root(struct inode *inode)
 {
-       return __d_obtain_alias(inode, 0);
+       return __d_obtain_alias(inode, 0, NULL);
 }
 EXPORT_SYMBOL(d_obtain_root);
