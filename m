Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9E1C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 06:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjD0GLc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjD0GLb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 02:11:31 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEB335A5
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 23:11:29 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Vh6EtZW_1682575886;
Received: from 30.97.48.233(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vh6EtZW_1682575886)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 14:11:27 +0800
Message-ID: <8c06f467-2ce5-5e99-a5a6-5c0f1e31a00a@linux.alibaba.com>
Date:   Thu, 27 Apr 2023 14:11:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH 1/7] ovl: update of dentry revalidate flags after copy up
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Larsson <alexl@redhat.com>,
        linux-unionfs@vger.kernel.org
References: <20230408164302.1392694-1-amir73il@gmail.com>
 <20230408164302.1392694-2-amir73il@gmail.com>
 <ae948b16-d35a-64eb-b9f4-127f66c232bb@linux.alibaba.com>
 <CAOQ4uxhTXy31nOXCF3691Cm6qPGOMu_H9aE=nz4KVRTs-1oVPQ@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOQ4uxhTXy31nOXCF3691Cm6qPGOMu_H9aE=nz4KVRTs-1oVPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 2023/4/27 13:48, Amir Goldstein wrote:
> On Fri, Apr 14, 2023 at 10:21 AM Gao Xiang <hsiangkao@linux.alibaba.com> wrote:
>>
>>
>>
>> On 2023/4/9 00:42, Amir Goldstein wrote:
>>> After copy up, we may need to update d_flags if upper dentry is on a
>>> remote fs and lower dentries are not.
>>>
>>> Add helpers to allow incremental update of the revalidate flags.
>>>
>>> Fixes: bccece1ead36 ("ovl: allow remote upper")
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>
>> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>>
>>> ---
>>>    fs/overlayfs/copy_up.c   |  2 ++
>>>    fs/overlayfs/dir.c       |  3 +--
>>>    fs/overlayfs/export.c    |  3 +--
>>>    fs/overlayfs/namei.c     |  3 +--
>>>    fs/overlayfs/overlayfs.h |  6 ++++--
>>>    fs/overlayfs/super.c     |  2 +-
>>>    fs/overlayfs/util.c      | 24 ++++++++++++++++++++----
>>>    7 files changed, 30 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>>> index c14e90764e35..7bf101e756c8 100644
>>> --- a/fs/overlayfs/copy_up.c
>>> +++ b/fs/overlayfs/copy_up.c
>>> @@ -576,6 +576,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
>>>                        /* Restore timestamps on parent (best effort) */
>>>                        ovl_set_timestamps(ofs, upperdir, &c->pstat);
>>>                        ovl_dentry_set_upper_alias(c->dentry);
>>> +                     ovl_dentry_update_reval(c->dentry, upper);
>>>                }
>>>        }
>>>        inode_unlock(udir);
>>> @@ -895,6 +896,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>>>                inode_unlock(udir);
>>>
>>>                ovl_dentry_set_upper_alias(c->dentry);
>>> +             ovl_dentry_update_reval(c->dentry, ovl_dentry_upper(c->dentry));
>>>        }
>>>
>>>    out:
>>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>>> index fc25fb95d5fc..9be52d8013c8 100644
>>> --- a/fs/overlayfs/dir.c
>>> +++ b/fs/overlayfs/dir.c
>>> @@ -269,8 +269,7 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
>>>
>>>        ovl_dir_modified(dentry->d_parent, false);
>>>        ovl_dentry_set_upper_alias(dentry);
>>> -     ovl_dentry_update_reval(dentry, newdentry,
>>> -                     DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
>>> +     ovl_dentry_init_reval(dentry, newdentry);
>>>
>>>        if (!hardlink) {
>>>                /*
>>> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
>>> index defd4e231ad2..5c36fb3a7bab 100644
>>> --- a/fs/overlayfs/export.c
>>> +++ b/fs/overlayfs/export.c
>>> @@ -326,8 +326,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>>>        if (upper_alias)
>>>                ovl_dentry_set_upper_alias(dentry);
>>>
>>> -     ovl_dentry_update_reval(dentry, upper,
>>> -                     DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
>>> +     ovl_dentry_init_reval(dentry, upper);
>>>
>>>        return d_instantiate_anon(dentry, inode);
>>>
>>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>>> index cfb3420b7df0..100a492d2b2a 100644
>>> --- a/fs/overlayfs/namei.c
>>> +++ b/fs/overlayfs/namei.c
>>> @@ -1122,8 +1122,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>>                        ovl_set_flag(OVL_UPPERDATA, inode);
>>>        }
>>>
>>> -     ovl_dentry_update_reval(dentry, upperdentry,
>>> -                     DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
>>> +     ovl_dentry_init_reval(dentry, upperdentry);
>>>
>>>        revert_creds(old_cred);
>>>        if (origin_path) {
>>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>>> index 4d0b278f5630..e100c55bb924 100644
>>> --- a/fs/overlayfs/overlayfs.h
>>> +++ b/fs/overlayfs/overlayfs.h
>>> @@ -375,8 +375,10 @@ bool ovl_index_all(struct super_block *sb);
>>>    bool ovl_verify_lower(struct super_block *sb);
>>>    struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
>>>    bool ovl_dentry_remote(struct dentry *dentry);
>>> -void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
>>> -                          unsigned int mask);
>>> +void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry);
>>> +void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry);
>>> +void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
>>> +                        unsigned int mask);
>>>    bool ovl_dentry_weird(struct dentry *dentry);
>>>    enum ovl_path_type ovl_path_type(struct dentry *dentry);
>>>    void ovl_path_upper(struct dentry *dentry, struct path *path);
>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>> index f1d9f75f8786..49b6956468f9 100644
>>> --- a/fs/overlayfs/super.c
>>> +++ b/fs/overlayfs/super.c
>>> @@ -1885,7 +1885,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
>>>        ovl_dentry_set_flag(OVL_E_CONNECTED, root);
>>>        ovl_set_upperdata(d_inode(root));
>>>        ovl_inode_init(d_inode(root), &oip, ino, fsid);
>>> -     ovl_dentry_update_reval(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
>>> +     ovl_dentry_init_flags(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
>>>
>>>        return root;
>>>    }
>>> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>>> index 923d66d131c1..6a0652bd51f2 100644
>>> --- a/fs/overlayfs/util.c
>>> +++ b/fs/overlayfs/util.c
>>> @@ -94,14 +94,30 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
>>>        return oe;
>>>    }
>>>
>>> +#define OVL_D_REVALIDATE (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)
>>> +
>>>    bool ovl_dentry_remote(struct dentry *dentry)
>>>    {
>>> -     return dentry->d_flags &
>>> -             (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE);
>>> +     return dentry->d_flags & OVL_D_REVALIDATE;
>>> +}
>>> +
>>> +void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry)
>>> +{
>>> +     if (!ovl_dentry_remote(realdentry))
>>> +             return;
>>> +
>>> +     spin_lock(&dentry->d_lock);
>>> +     dentry->d_flags |= realdentry->d_flags & OVL_D_REVALIDATE;
>>
>> Although I'm not sure if it could cause some lazy awareness due to dcache
>> RCU-walk, but maybe that is fine since such window is small?
>>
> 
> Good question.
> I am not sure.
> The alternative would be to the set revalidate flags on non-upper dentry
> if the upper fs is remote.

Yeah, I think that may be safer because I'm not sure

(DCACHE_OP_REVALIDATE, DCACHE_OP_WEAK_REVALIDATE)

could be changed dynamicly as safe after d_obtain_alias()..

Thanks,
Gao Xiang

> 
> Thanks,
> Amir.
