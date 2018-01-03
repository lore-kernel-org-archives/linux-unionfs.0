From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 2/2] vfs: update overlay inode times on lease_get_mtime()
Date: Wed, 3 Jan 2018 10:40:10 +0200
Message-ID: <CAOQ4uxgTX=V4-REca8P_Rp00XBDrFPgbzP4bXEtcSMX0PpDzFQ@mail.gmail.com>
References: <1514896009-11468-1-git-send-email-amir73il@gmail.com>
 <1514896009-11468-3-git-send-email-amir73il@gmail.com> <20180102225437.GA1781@fieldses.org>
 <CAOQ4uxiaK=QRR+2+7fUfZv_MxtuVSpEAUuXwHL4mVvKKE6VdsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:45112 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeACIkL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 03:40:11 -0500
In-Reply-To: <CAOQ4uxiaK=QRR+2+7fUfZv_MxtuVSpEAUuXwHL4mVvKKE6VdsQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jan 3, 2018 at 8:48 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jan 3, 2018 at 12:54 AM, J . Bruce Fields <bfields@fieldses.org> wrote:
>> On Tue, Jan 02, 2018 at 02:26:49PM +0200, Amir Goldstein wrote:
>>> Instead of looking for all the places that update inode's m_time,
>>> update overlay inode i_mtime just before nfsd needs to read it.
>>>
>>> The non uptodate mtime issue was found and verified with the
>>> nfstest_posix test when run over NFS exported overlayfs:
>>>
>>>  $ nfstest_posix --runtest=link,write
>>>  ...
>>>  FAIL: link - parent directory st_mtime should be updated
>>>  FAIL: write - file st_mtime should be updated
>>
>> Grepping for users of i_mtime in fs/nfsd/....
>>
>> Looks like we might need something similar for fill_pre_wcc() ?  (And
>> maybe nfsd4_block_commit_blocks() ?)
>>
>> I don't think it's necessary for do_nfsd_create(), but it should be
>> harmless if we want to just make it a rule that nfsd shouldn't be
>> accessing i_mtime directly.
>>
>
> All right. I'll do that.
> While at it, do you think it will be fine to call vfs_getattr() from a helper
> nfsd_get_inode_mtime() instead of having to special case overlayfs?
> Or is there some reason why accessing i_mtime is a requirement?
>

Looking closer... in the callers of lease_get_mtime() vfs_getattr() is
already called before accessing i_mtime, but stat->mtime is ignored,
so I will change lease_get_mtime() to only *update* mtime for the
has_lease case and leave it at the stat->mtime value otherwise.

Regarding fill_pre_wcc() it is quite unbalanced that fill_pre_wcc()
reads i_mtime, while fill_post_wcc() reads stat->mtime.
I will change fill_pre_wcc() to use stat->mtime as well.

Regarding nfsd4_block_commit_blocks(), there is no concern with
respect to overlayfs and I have no means to test it, so I rather leave it be.

Patches to follow...

Thanks for your inputs,
Amir.
