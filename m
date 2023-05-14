Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99F1C7EE22
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 May 2023 22:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjENWTR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 May 2023 18:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjENWTP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 May 2023 18:19:15 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6969910F0
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 15:19:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R871e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0ViYNzju_1684102748;
Received: from 192.168.3.7(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0ViYNzju_1684102748)
          by smtp.aliyun-inc.com;
          Mon, 15 May 2023 06:19:09 +0800
Message-ID: <0e9656e1-6055-2920-babd-ee1df606db14@linux.alibaba.com>
Date:   Mon, 15 May 2023 06:19:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/6] ovl: Add support for fs-verity checking of
 lowerdata
To:     Amir Goldstein <amir73il@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Larsson <alexl@redhat.com>, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, tytso@mit.edu,
        fsverity@lists.linux.dev
References: <cover.1683102959.git.alexl@redhat.com>
 <20230514190903.GC9528@sol.localdomain>
 <CAOQ4uxj73Tu1XKSte-csHKH4pUN_84Px42MdZ4rVt9hUdjHJ2g@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOQ4uxj73Tu1XKSte-csHKH4pUN_84Px42MdZ4rVt9hUdjHJ2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

On 2023/5/15 14:25, Amir Goldstein wrote:
> On Sun, May 14, 2023 at 10:09 PM Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> Hi Alexander,
>>
>> On Wed, May 03, 2023 at 10:51:33AM +0200, Alexander Larsson wrote:
>>> This patchset adds support for using fs-verity to validate lowerdata
>>> files by specifying an overlay.verity xattr on the metacopy
>>> files.
>>>
>>> This is primarily motivated by the Composefs usecase, where there will
>>> be a read-only EROFS layer that contains redirect into a base data
>>> layer which has fs-verity enabled on all files. However, it is also
>>> useful in general if you want to ensure that the lowerdata files
>>> matches the expected content over time.
>>>
>>> This patch series is based on the lazy lowerdata patch series by Amir[1].
>>>
>>> I have also added some tests for this feature to xfstests[2].
>>>
>>> I'm also CC:ing the fsverity list and maintainers because there is one
>>> (tiny) fsverity change, and there may be interest in this usecase.
>>>
>>> Changes since v1:
>>>   * Rebased on v2 lazy lowerdata series
>>>   * Dropped the "validate" mount option variant. We now only support
>>>     "off", "on" and "require", where "off" is the default.
>>>   * We now store the digest algorithm used in the overlay.verity xattr.
>>>   * Dropped ability to configure default verity options, as this could
>>>     cause problems moving layers between machines.
>>>   * We now properly resolve dependent mount options by automatically
>>>     enabling metacopy and redirect_dir if verity is on, or failing
>>>     if the specified options conflict.
>>>   * Streamlined and fixed the handling of creds in ovl_ensure_verity_loaded().
>>>   * Renamed new helpers from ovl_entry_path_ to ovl_e_path_
>>>
>>> [1] https://lore.kernel.org/linux-unionfs/20230427130539.2798797-1-amir73il@gmail.com/T/#m3968bf64a31946e77bdba8e3d07688a34cf79982
>>> [2] https://github.com/alexlarsson/xfstests/commits/verity-tests
>>>
>>> Alexander Larsson (6):
>>>    fsverity: Export fsverity_get_digest
>>>    ovl: Break out ovl_e_path_real() from ovl_i_path_real()
>>>    ovl: Break out ovl_e_path_lowerdata() from ovl_path_lowerdata()
>>>    ovl: Add framework for verity support
>>>    ovl: Validate verity xattr when resolving lowerdata
>>>    ovl: Handle verity during copy-up
>>>
>>>   Documentation/filesystems/overlayfs.rst |  27 ++++
>>>   fs/overlayfs/copy_up.c                  |  31 +++++
>>>   fs/overlayfs/namei.c                    |  42 +++++-
>>>   fs/overlayfs/overlayfs.h                |  12 ++
>>>   fs/overlayfs/ovl_entry.h                |   3 +
>>>   fs/overlayfs/super.c                    |  74 ++++++++++-
>>>   fs/overlayfs/util.c                     | 165 ++++++++++++++++++++++--
>>>   fs/verity/measure.c                     |   1 +
>>>   8 files changed, 343 insertions(+), 12 deletions(-)
>>
>> Thanks for presenting this topic at LSFMM!
>>
>> I'm not an expert in overlayfs, but I've been working through this patchset.
>>
>> One thing that seems to be missing, and has been tripping me up while reviewing
>> this patchset, is that the overlayfs documentation
>> (Documentation/filesystems/overlayfs.rst) is not properly up to date with the
>> use case that is intended here.
>>
>> For example, the overlayfs documentation says "An overlay filesystem combines
>> two filesystems - an 'upper' filesystem and a 'lower' filesystem.".
>>
>> Apparently, that is out of date.  I think a correct statement would be: An
>> overlay filesystem combines an optional upper directory with one or more lower
>> directories.
>>
>> And as I understand it, the use case here actually involves two lower
>> directories and no upper directory.
>>
>> There is also the "metacopy" feature, which the documentation describes in the
>> section "Metadata only copy up".  The documentation makes it sound like an
>> overlayfs internal optimization.
>>
>> However, when this patchset introduces the fsverity support, it talks about
>> "metacopy files".  As I understand it, the user is expected to create a
>> read-only filesystem that contains these "metacopy files".  It doesn't seem to
>> be documented what these are, exactly, and how to create them.  I assume that
>> these are part of the implementation of "Metadata only copy up", but there seems
>> to be a gap where the documentation goes from describing the behavior of
>> "metadata only copy up", to expecting users of overlayfs to know what a
>> "metacopy file" is and how to create them.
>>
> 
> What may confuse you is that Alexander has a tool mkfs.composefs
> that creates hand crafted overlayfs, but it is not up to overlayfs.rst to
> document this tool.

Although I also think it might be inappropriate to document the whole
mkfs.composefs tool in overlayfs.rst, I'm not sure if it could be helpful
to document (or mention) some other typical attractive use cases other than
the primary one ("present a filesystem which redirects writes to the upper
layer?") so people could easily find/use/develop such additional use cases
as well?

That could be in a seperate work though.

Thanks,
Gao Xiang
