From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 0/7] Overlayfs exportfs tests
Date: Wed, 24 Jan 2018 12:48:04 +0200
Message-ID: <CAOQ4uxhzafe6iYAvfXiGGVJ_SwaeT0FJO5j3mE8zCwS9nrrD5A@mail.gmail.com>
References: <1516741152-20345-1-git-send-email-amir73il@gmail.com> <20180124104023.GB18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:38104 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932992AbeAXKsF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jan 2018 05:48:05 -0500
In-Reply-To: <20180124104023.GB18267@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jan 24, 2018 at 12:40 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jan 23, 2018 at 10:59:05PM +0200, Amir Goldstein wrote:
>> Eryu,
>>
>> This is the 2nd revision of test for overlayfs NFS export.
>>
>> Changes since v1:
>> - Added new generic/exportfs test instead of changing existing test
>> - Addressed review comments on open_by_handle [-i|-o] patch
>> - Added the test that uses open_by_handle [-i|-o] in the same patch
>> - Split new overlay/exportfs tests to four tests, a pair of tests
>>   for samefs and a pair of tests for non-samefs configuration.
>> - For each configuration, one test requires and enables redirect_dir
>>   for directory rename test cases and both tests require and enable
>>   nfs_export feature.
>>
>> The new overlay tests don't run on upstream kernel and pass with
>> my overlayfs NFS export V3 branch [1]. You may want to wait with
>> merging those tests until overlayfs NFS support is merged.
>
> Yeah, I probably will wait and let the kernel patches go first. (And
> I'll go through the overlay specific patches later.)
>
>>
>> Merging patches 1-3 seems like a good idea to me regardless of
>> overlayfs NFS export support.
>
> Patches 1-3 look good to me. One minor issue is that my compiler
> complained about "may be used uninitialized" on 'infile' and 'outfile'
>
> open_by_handle.c:350:12: warning: 'outfile' may be used uninitialized in this function [-Wmaybe-uninitialized]
>
> though I don't think we'll use them uninitialized in practice, I'd like
> to initialize them with NULL on commit.
>

That sounds good.

Thanks,
Amir.
