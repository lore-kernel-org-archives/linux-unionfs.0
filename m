From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH 0/3] Overlayfs restoring of origin fh
Date: Thu, 9 Nov 2017 19:46:07 +0800
Message-ID: <8464b57e-c6b7-fc0d-9fe9-7e9e2a7f68f9@huawei.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
 <CAJfpegu__w=VnxxVhm=FtGCUFkNdjLdB56S2tQ6mMTwwEqPV0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10044 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752747AbdKILqg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 06:46:36 -0500
In-Reply-To: <CAJfpegu__w=VnxxVhm=FtGCUFkNdjLdB56S2tQ6mMTwwEqPV0w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 2017/11/9 18:07, Miklos Szeredi Wrote:
> On Tue, Nov 7, 2017 at 10:38 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This series is complementary to the whiteouts expose patches.
>> Patch 2 restores origin xattr on lookup of merge dir (that was copied up
>> before v4.12).
>> Patch 3 sets a 'null' origin fh on dir if we happen to iterate an 'impure'
>> dir and find a whiteout while looking for copy ups. This is expected to
>> happen if merge dir was copied up before v4.12, but files inside it were
>> copied up after v4.12.
> 
> Applied 1/3.
> 
> Does the other two patches have any real usecase?   AFAICS this is not
> fixing a backward compatibility issue, so I'm sceptical of the value.
> 
> Even if there was a real usecase, we could introduce an "fsck.overlay"
> utility that would fix up overlays to be able to take advantage of new
> features.

Hi Miklos,

Now, I am working on the "fsck.overlay" in my spare time, and the following functions
have already been done:
1) Check and (auto)fix redundant whiteouts,
2) Check and (auto)fix invalid redirect/opaque xattr.

But it is still a very crude version now, maybe I can send out for some suggestions
next week. :)

Thanks,
Yi.

> Thanks,
> Miklos
> 
> 
