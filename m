From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [RFC PATCH V4] ovl: fix rmdir problem on origin dir
Date: Thu, 29 Jun 2017 21:29:15 +0800
Message-ID: <d4d0452f-1679-0c22-ee1f-409d46647828@huawei.com>
References: <1498641351-36052-1-git-send-email-yi.zhang@huawei.com>
 <CAOQ4uxjXkwBCG3fiNEg1OoS-14YsKz=QvDajvobTDoS7z9x64g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8404 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbdF2N32 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Jun 2017 09:29:28 -0400
In-Reply-To: <CAOQ4uxjXkwBCG3fiNEg1OoS-14YsKz=QvDajvobTDoS7z9x64g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com

On 2017/6/28 18:24, Amir Goldstein wrote:
> On Wed, Jun 28, 2017 at 12:15 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> BTW, I have a question, many features of overlayfs rely
>> on xattr/whiteouts of underlaying dir now, but xattr may
>> have some inconformity before we mount overlayfs or
>> "umount --> modify underlaying dir --> mount again"
>> (.e.g this whiteout case), so we cannot guarantee it's
>> behavior meet users expectations. Do you think we can make
>> a tools like e2fsck of Extfs in the future, let users to
>> check underlaying dir before mount? I think it can do the
>> following things:
>>
>> (1) Check invalid whiteouts and auto fix or ask user.
>> (2) Check redirect/impure/opaque xattr.
> (3) Check origin of merge dirs and auto fix them or ask user
> 
> 
> I think having to create fsck.overlay is inevitable.
> With the new inode index feature, a lot more can and needs to
> be checked. Specifically, inodes index checks that lower root dir
> matches origin stored in upper root dir and fails to mount overlay.
> 
> In order to allow mounting an indexed overlay after copying
> layers (to new lower inodes), a tool must be provided to perform
> 'checkpoint/restart' functionality, which converts 'origin' xattr
> (by fh) to 'redirect' xattr (by path) and vice versa.
> 
> As part of my TODO for overlayfs snapshots, I must deal with
> the 'checkpoint' part, so I do plan to start a poor mans
> implementation of an overlayfs-utils tool, but I have no plans to
> maintain a proper distribution packaged tool at community standard.
> 
> If you wish to start writing a proper tool, which performs the checks
> that you listed, that would be most welcome. You are welcome to
> contribute the code to the project I prepared for that purpose:
> https://github.com/amir73il/overlayfs
> 

I am glad to do some contribution, but I am not sure I have enough
time or not. Anyway, I can have a try in my spare time, thanks.

>> @@ -522,6 +525,7 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
>>  {
>>         int err;
>>         struct ovl_cache_entry *p;
>> +       struct ovl_cache_entry *n;
> 
> nit: I would do *p, *n;
> It's a matter of taste I suppose, because Miklos chose otherwise in
> ovl_cache_free()
> 

Yes, it's more cleaner, thanks for your suggestion.

Thanks,
ZhangYi.
