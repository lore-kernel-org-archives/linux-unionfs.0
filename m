Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B65C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 07:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 429ED615E1
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Sep 2021 07:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348449AbhI3HFu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:05:50 -0400
Received: from n169-110.mail.139.com ([120.232.169.110]:44425 "EHLO
        n169-110.mail.139.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbhI3HFt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Sep 2021 03:05:49 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2021 03:05:49 EDT
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.255.10] (unknown[113.108.77.54])
        by rmsmtp-lg-appmail-08-12086 (RichMail) with SMTP id 2f3661555f3e397-57260;
        Thu, 30 Sep 2021 14:54:56 +0800 (CST)
X-RM-TRANSID: 2f3661555f3e397-57260
Message-ID: <598d41fd-e0a1-393d-f425-2067724e4cd6@139.com>
Date:   Thu, 30 Sep 2021 14:54:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
To:     Huang Jianan <huangjianan@oppo.com>,
        Chengguang Xu <cgxu519@mykernel.net>, mszeredi@redhat.com
Cc:     linux-unionfs@vger.kernel.org
References: <20210928124757.117556-1-cgxu519@mykernel.net>
 <2ef5a5e3-234f-5b1b-5463-726d200e7e96@oppo.com>
From:   Chengguang Xu <cgxu519@139.com>
In-Reply-To: <2ef5a5e3-234f-5b1b-5463-726d200e7e96@oppo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

在 2021/9/30 14:52, Huang Jianan 写道:
> This patch can ensure that loop devices based on erofs and overlayfs 
> can't set dio through __loop_update_dio.
>
> Tested-by: Huang Jianan <huangjianan@oppo.com>

HI Jianan,

Thanks for the test!



>
> Thanks,
> Jianan
>
> 在 2021/9/28 20:47, Chengguang Xu 写道:
>> Loop device checks the ability of DIRECT-IO by checking
>> a_ops->direct_IO of inode, in order to avoid this kind of
>> false detection we set a_ops->direct_IO for overlayfs inode
>> only when underlying inode really has DIRECT-IO ability.
>>
>> Reported-by: Huang Jianan <huangjianan@oppo.com>
>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> ---
>>   fs/overlayfs/dir.c       |  2 ++
>>   fs/overlayfs/inode.c     |  4 ++--
>>   fs/overlayfs/overlayfs.h |  1 +
>>   fs/overlayfs/util.c      | 14 ++++++++++++++
>>   4 files changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>> index 1fefb2b8960e..32a60f9e3f9e 100644
>> --- a/fs/overlayfs/dir.c
>> +++ b/fs/overlayfs/dir.c
>> @@ -648,6 +648,8 @@ static int ovl_create_object(struct dentry 
>> *dentry, int mode, dev_t rdev,
>>       /* Did we end up using the preallocated inode? */
>>       if (inode != d_inode(dentry))
>>           iput(inode);
>> +    else
>> +        ovl_inode_set_aops(inode);
>>     out_drop_write:
>>       ovl_drop_write(dentry);
>> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>> index 832b17589733..a7a327e4f790 100644
>> --- a/fs/overlayfs/inode.c
>> +++ b/fs/overlayfs/inode.c
>> @@ -659,7 +659,7 @@ static const struct inode_operations 
>> ovl_special_inode_operations = {
>>       .update_time    = ovl_update_time,
>>   };
>>   -static const struct address_space_operations ovl_aops = {
>> +const struct address_space_operations ovl_aops = {
>>       /* For O_DIRECT dentry_open() checks 
>> f_mapping->a_ops->direct_IO */
>>       .direct_IO        = noop_direct_IO,
>>   };
>> @@ -786,6 +786,7 @@ void ovl_inode_init(struct inode *inode, struct 
>> ovl_inode_params *oip,
>>       ovl_copyattr(realinode, inode);
>>       ovl_copyflags(realinode, inode);
>>       ovl_map_ino(inode, ino, fsid);
>> +    ovl_inode_set_aops(inode);
>>   }
>>     static void ovl_fill_inode(struct inode *inode, umode_t mode, 
>> dev_t rdev)
>> @@ -802,7 +803,6 @@ static void ovl_fill_inode(struct inode *inode, 
>> umode_t mode, dev_t rdev)
>>       case S_IFREG:
>>           inode->i_op = &ovl_file_inode_operations;
>>           inode->i_fop = &ovl_file_operations;
>> -        inode->i_mapping->a_ops = &ovl_aops;
>>           break;
>>         case S_IFDIR:
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index 3894f3347955..976c9d634293 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -349,6 +349,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry);
>>   char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry 
>> *dentry,
>>                    int padding);
>>   int ovl_sync_status(struct ovl_fs *ofs);
>> +void ovl_inode_set_aops(struct inode *inode);
>>     static inline void ovl_set_flag(unsigned long flag, struct inode 
>> *inode)
>>   {
>> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> index f48284a2a896..33535dbee1c3 100644
>> --- a/fs/overlayfs/util.c
>> +++ b/fs/overlayfs/util.c
>> @@ -1060,3 +1060,17 @@ int ovl_sync_status(struct ovl_fs *ofs)
>>         return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
>>   }
>> +
>> +extern const struct address_space_operations ovl_aops;
>> +void ovl_inode_set_aops(struct inode *inode)
>> +{
>> +    struct inode *realinode;
>> +
>> +    if (!S_ISREG(inode->i_mode))
>> +        return;
>> +
>> +    realinode = ovl_inode_realdata(inode);
>> +    if (realinode && realinode->i_mapping && 
>> realinode->i_mapping->a_ops &&
>> +        realinode->i_mapping->a_ops->direct_IO)
>> +        inode->i_mapping->a_ops = &ovl_aops;
>> +}
>

