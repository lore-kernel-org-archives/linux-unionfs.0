Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837ECC71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 12:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjIDMtY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 08:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjIDMtY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 08:49:24 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AE3EC
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 05:49:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VrLbFyX_1693831755;
Received: from 30.221.146.157(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VrLbFyX_1693831755)
          by smtp.aliyun-inc.com;
          Mon, 04 Sep 2023 20:49:16 +0800
Message-ID: <9a89150e-cd84-c541-8088-41c2dfe863ac@linux.alibaba.com>
Date:   Mon, 4 Sep 2023 20:49:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [potential issue, question] whiteout shows up in merged directory
Content-Language: en-US
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Xiang Gao <xiang@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
References: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
 <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
From:   Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

On 9/4/23 4:57 PM, Amir Goldstein wrote:
> On Mon, Sep 4, 2023 at 10:47 AM Jingbo Xu <jefflexu@linux.alibaba.com> wrote:
>>
>> Hi, all,
>>
>> I found an issue may be related to overlayfs on the latest master branch
>> [1] when I'm developing tarfs mode for erofs-utils [2], which converts
>> and merges tar layers into one merged erofs image with overlayfs-like model.
>>
>> The issue is that, the whiteout from lowerdir may still shows up in the
>> merged directory.  Though this issue is initially found with erofs, it
>> can also be reproduced with ext4.  Following is a simple reproducer with
>> ext4.
>>
>> ```
>> mkdir -p /mnt/lower1/dir /mnt/lower2
>> mknod /mnt/lower1/file1 c 0 0
>> mknod /mnt/lower1/dir/file2 c 0 0
>> mount -t overlay none -olowerdir=/mnt/lower1:/mnt/lower2 /mnt2
>>
>> # ls  -l /mnt2/
>> total 4
>> drwxr-xr-x 2 root root 4096 Sep  4 14:40 dir
>>
>> # ls  -l /mnt2/dir
>> ls: cannot access /mnt2/dir/file2: No such file or directory
>> total 0
>> c????????? ? ? ? ?            ? file2
>> ```
>>
>> It seems that this issue is relevant to whether the parent directory of
>> the whiteout is a merged directory or not.  In the above example, file1
>> is hidden from the merged directory as expected (with its parent
>> directory '/' a merged directory), while file2 shows up unexpectedly
>> (with its parent directory '/dir' from lowerdir).
>>
>>
>> I also noticed that this issue doesn't exist if the whiteout is created
>> by overlayfs itself rather than handcrafted with mknod like:
>>
>> ```
>> mkdir -p /mnt/lower/dir /mnt/upper /mnt/work
>> touch /mnt/lower/file1
>> touch /mnt/lower/dir/file2
>> mount -t overlay none
>> -olowerdir=/mnt/lower,upperdir=/mnt/upper,workdir=/mnt/work /mnt1
>> rm /mnt1/file1
>> rm /mnt1/dir/file2
>> umount /mnt1
>> mount -t overlay -olowerdir=/mnt/upper:/mnt/lower none /mnt2
>>
>> # ls -l /mnt2/
>> total 8
>> drwxr-xr-x 1 root root 4096 Sep  4 15:45 dir
>>
>> # ls -l /mnt2/dir/
>> total 0
>> ```
>>
>> I'm not sure if it's a known issue or not, or due to my mishandling.
>> Appreciate if you could shed a light on this.
>>
> 
> The case of whiteouts creates by overlayfs itself was reported
> by zhangyi and handled by this patchs set:
> 
> https://lore.kernel.org/linux-unionfs/1509486350-21362-1-git-send-email-amir73il@gmail.com/

Thanks for the reply and it's really helpful to me.

I can understand in the normal use case, whiteout can not appear in
non-merged directory without origin xattr, except it's hand crafted.

But indeed we suffer from this issue in the tarfs for erofs-utils we are
developing. As described previously, in tarfs mode erofs-utils can
convert each tar layer into one separate erofs image, and then merge
these erofs images into one merged erofs image in a overlayfs-like model.

Suppose:

layer 0 + layer 1   +        layer 2         -->  merged
	  /foo/bar   /foo/bar (whiteout)


To speed the merging process, we may merge the two top-most layers
(layer 1 and layer 2) first, and then make layer0 merged into the final
merged image as:



           layer 1   +        layer 2         -->  merged-intermediate
	  /foo/bar   /foo/bar (whiteout)

layer0 + merged-intermediate		      -->  merged

Then there comes the problem: when merging layer1 and layer2, I need to
keep the whiteout in the intermediate merged image though the target of
the whiteout has showed up in underlying layer (/foo/bar in layer 1),
because I have no idea if "/foo/bar" exits in the following further
underlying layer (layer 0).  Reusing this logic, the whiteout is kept
there in the final merged image after merging layer0 and
merged-intermediate.

Then if "/foo" is not a merged directory, the "/foo/bar" whiteout will
be exposed in the overlayfs unexpectedly.

Currently we work around this in erofs-utils side.  Apart from setting
origin xattr on the parent directory of the whiteout, I'm not sure if
the above use case is reasonable enough to fix this in the kernel side.

-- 
Thanks,
Jingbo
